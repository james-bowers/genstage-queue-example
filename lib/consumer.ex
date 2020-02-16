defmodule MyListener.Consumer do
  use GenStage

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, :no_meaningful_state)
  end

  def init(_opts) do
    opts = [subscribe_to: [{MyListener.Producer, max_demand: 1}]]
    {:consumer, :the_state_does_not_matter, opts}
  end

  def handle_events(events, _from, state) do
    IO.inspect(events, label: "events")

    # We are a consumer, so we would never emit items.
    {:noreply, [], state}
  end
end
