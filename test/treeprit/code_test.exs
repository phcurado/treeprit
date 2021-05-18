defmodule Treeprit.CodeTest do
  use ExUnit.Case

  defmodule ExampleWithBehavior do
    @behaviour Treeprit.ScriptBehaviour

    def run(_) do
      {:ok, "testing"}
    end
  end

  defmodule ExampleWithoutBehavior do
    def run(_) do
      {:ok, "testing"}
    end
  end

  test "Test module behavior without function" do
    result =
      Treeprit.new()
      |> Treeprit.run(:test, ExampleWithBehavior)
      |> Treeprit.finally()

    assert result == %Treeprit{
             results: %{
               test: "testing"
             },
             successful_operations: 1,
             failed_operations: 0,
             total_operations: 1
           }
  end

  test "Test module behavior function" do
    assert_raise RuntimeError,
                 "Module Treeprit.CodeTest.ExampleWithoutBehavior must implement the ScriptBehavior to be used",
                 fn ->
                   Treeprit.new()
                   |> Treeprit.run(:test, ExampleWithoutBehavior)
                   |> Treeprit.finally()
                 end
  end
end
