defmodule Treeprit do
  @moduledoc """
  Documentation for `Treeprit`.
  """

  @type t :: %__MODULE__{
          total_operations: integer(),
          skipped_operations: integer(),
          successful_operations: integer(),
          failed_operations: integer(),
          names: MapSet.t(),
          results: map(),
          operations: map(),
          errors: map()
        }

  defstruct total_operations: 0,
            skipped_operations: 0,
            successful_operations: 0,
            failed_operations: 0,
            names: MapSet.new(),
            results: Map.new(),
            operations: Map.new(),
            errors: Map.new()

  @doc """
  Create the treeprit struct.

  ## Examples

      iex> Treeprit.new()
      %Treeprit{}

  """
  @spec new() :: t()
  def new, do: %__MODULE__{}

  @doc """
  Run your operation

  ## Examples

      iex> Treeprit.new() |> Treeprit.run(:add_val, fn _ -> {:ok, "my value"} end) |> Treeprit.finally()
      %Treeprit{
        failed_operations: 0,
        names: #MapSet<[:add_val]>,
        results: %{add_val: "my value"},
        skipped_operations: 0,
        successful_operations: 1,
        total_operations: 1
      }

  """
  @spec run(%Treeprit{}, atom(), atom() | function()) :: %Treeprit{}
  def run(treeprit, name, module) when is_atom(name) and is_atom(module) do
    assert_module(module)

    run(treeprit, name, &module.run/1)
  end

  def run(treeprit, name, func) when is_atom(name) and is_function(func) do
    if MapSet.member?(treeprit.names, name) do
      raise "Operation name #{name} already defined"
    end

    treeprit
    |> add_operation(name, func)
    |> increment_total_operations()
  end

  def finally(treeprit) do
    treeprit.operations
    |> Enum.reduce(treeprit, fn operation, acc ->
      exec(acc, operation)
    end)
  end

  defp exec(treeprit, {name, func}) do
    try do
      result = func.(treeprit.operations)
      parse_result(treeprit, name, result)
    rescue
      error -> parse_result(treeprit, name, {:error, error})
    end
  end

  defp parse_result(treeprit, name, {:ok, result}) do
    treeprit
    |> increment_successful_operations()
    |> add_result(name, result)
  end

  defp parse_result(treeprit, name, {:error, error}) do
    treeprit
    |> increment_failed_operations()
    |> add_error(name, error)
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

    %{
      treeprit
      | names: MapSet.put(treeprit.names, name),
        operations: Map.merge(treeprit.operations, new_operation)
    }
  end

  defp add_result(treeprit, name, result) do
    new_result = Map.new() |> Map.put(name, result)
    %{treeprit | results: Map.merge(treeprit.results, new_result)}
  end

  defp add_error(treeprit, name, error) do
    new_error = Map.new() |> Map.put(name, error)
    %{treeprit | errors: Map.merge(treeprit.errors, new_error)}
  end

  defp assert_module(module) do
    behavior = module.module_info()[:attributes][:behaviour]

    unless behavior != nil and Enum.member?(behavior, Treeprit.ScriptBehaviour) do
      raise "Module #{inspect(module)} must implement the ScriptBehavior to be used"
    end
  end
end
