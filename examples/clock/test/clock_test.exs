defmodule ClockTest do
  use ExUnit.Case
  doctest Clock

  test "greets the world" do
    assert Clock.hello() == :world
  end
end
