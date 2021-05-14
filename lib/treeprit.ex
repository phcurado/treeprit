defmodule Treeprit do
  @moduledoc """
  Documentation for `Treeprit`.
  """

  # @type operation :: {:ok, map()} | {:error, any()}

  @type t :: %__MODULE__{
    total_operations: integer(),
    skipped_operations: integer(),
    successful_operations: integer(),
    failed_operations: integer(),
    operations: map()
  }

  defstruct total_operations: 0, skipped_operations: 0, successful_operations: 0, failed_operations: 0, operations: %{}


  @doc """
  Create the treeprit struct.

  ## Examples

      iex> Treeprit.new()
      %Treeprit{}

  """
  def new, do: %__MODULE__{}

  @doc """
  Run your operation

  ## Examples

      iex> Treeprit.new() |> Treeprit.run(:add_val, fn _ -> %{val: "my value"} end)
      %Treeprit{
        failed_operations: 0,
        operations: %{add_val: {:ok, %{val: "my value"}}},
        skipped_operations: 0,
        successful_operations: 1,
        total_operations: 1
      }

  """
  def run(treeprit, name, func) when is_atom(name) and is_function(func) do
    treeprit = try do
      result = func.(treeprit.operations)
      successful_result(treeprit, name, result)
    rescue
      error -> failed_result(treeprit, name, inspect(error))
    end

    treeprit
    |> increment_total_operations()
  end

  defp successful_result(treeprit, name, result) do
    treeprit
    |> increment_successful_operations()
    |> add_operation(name, {:ok, result})
  end

  defp failed_result(treeprit, name, result) do
    treeprit
    |> increment_failed_operations()
    |> add_operation(name, {:error, result})
  end

  defp increment_total_operations(treeprit) do
    %{treeprit | total_operations: treeprit.total_operations + 1}
  end

  defp increment_successful_operations(treeprit) do
    %{treeprit | successful_operations: treeprit.successful_operations + 1}
  end

  defp increment_failed_operations(treeprit) do
    %{treeprit | failed_operations: treeprit.failed_operations + 1}
  end

  defp add_operation(treeprit, name, operation) do
    new_operation = Map.new() |> Map.put(name, operation)
    %{treeprit | operations: Map.merge(treeprit.operations, new_operation)}
  end
end
