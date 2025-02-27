defmodule ElixirEdgeDriverTest do
  use ExUnit.Case
  doctest ElixirEdgeDriver

  test "greets the world" do
    assert ElixirEdgeDriver.hello() == :world
  end
end
