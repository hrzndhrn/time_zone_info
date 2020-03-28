defmodule UpdaterTest do
  use ExUnit.Case
  doctest Updater

  test "greets the world" do
    assert Updater.hello() == :world
  end
end
