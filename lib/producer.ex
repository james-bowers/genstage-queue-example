defmodule MyListener.Producer do
  use GenStage

  def start_link(number) do
    init_state = {:queue.new(), 0}
    GenStage.start_link(__MODULE__, init_state, name: __MODULE__)
  end

  def init(counter) do
    {:producer, counter}
  end

  def put_event(event) do
    send(__MODULE__, {:event, event})
    :ok
  end

  def handle_info({:event, event}, {queue, pending_demand}) do
    flush_events(:queue.in(event, queue), pending_demand, [])
  end

  def handle_demand(demand, {queue, pending_demand}) do
    flush_events(queue, pending_demand + demand, [])
  end

  @doc """
  When demand is 0, we need to flush any events that have been
  popped from the queue.
  """
  defp flush_events(queue, demand = 0, events_to_flush) do
    # As the events were prepended to the flush list, we need to
    # reverse the order so that the initial order is maintained
    {:noreply, Enum.reverse(events_to_flush), {queue, demand}}
  end

  defp flush_events(queue, demand, events_to_flush) do
    case :queue.out(queue) do
      {{:value, event}, queue} ->
        # prepend the popped event to the `events_to_flush` list
        flush_events(queue, demand - 1, [event | events_to_flush])

      {:empty, queue} ->
        # As the events were prepended to the flush list, we need to
        # reverse the order so that the initial order is maintained
        {:noreply, Enum.reverse(events_to_flush), {queue, demand}}
    end
  end
end
