defmodule TreepritTest do
  use ExUnit.Case
  doctest Treeprit

  test "create new Treeprit struct" do
    assert Treeprit.new() == %Treeprit{}
  end
end
