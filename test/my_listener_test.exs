defmodule MyListenerTest do
  use ExUnit.Case
  doctest MyListener

  test "greets the world" do
    assert MyListener.hello() == :world
  end
end
