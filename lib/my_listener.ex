defmodule MyListener do
  @moduledoc """
  Documentation for MyListener.
  """

  @doc """
  Hello world.

  ## Examples

      iex> MyListener.hello()
      :world

  """
  def hello do
    :world
  end

  def stress_test(amt) do
    Enum.each(1..amt, fn num ->
      MyListener.Producer.put_event("handle this #{num}!")
    end)
  end
end
