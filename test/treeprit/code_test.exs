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

    %Treeprit{
      results: results,
      names: names,
      errors: errors,
      successful_operations: successful_operations,
      failed_operations: failed_operations,
      total_operations: total_operations
    } = result

    assert results == %{test: "testing"}

    assert MapSet.equal?(MapSet.new([:test]), names)

    assert errors == %{}

    assert successful_operations == 1
    assert failed_operations == 0
    assert total_operations == 1
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
