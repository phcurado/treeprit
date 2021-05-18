defmodule TreepritTest do
  use ExUnit.Case
  doctest Treeprit

  test "Run functions" do
    result =
      Treeprit.new()
      |> Treeprit.run(:first, fn _ -> {:ok, 1} end)
      |> Treeprit.run(:second, fn _ -> {:ok, 2} end)
      |> Treeprit.run(:third, fn %{first: first_value, second: second_value} ->
        {:ok, first_value + second_value}
      end)
      |> Treeprit.run(:fourth, fn _ -> raise "random error" end)
      |> Treeprit.run(:fifth, fn _ -> {:error, :not_found} end)
      |> Treeprit.finally()

    %Treeprit{
      results: results,
      names: names,
      errors: errors,
      successful_operations: successful_operations,
      failed_operations: failed_operations,
      total_operations: total_operations
    } = result

    assert results == %{
             first: 1,
             second: 2,
             third: 3
           }

    assert MapSet.equal?(MapSet.new([:first, :second, :third, :fourth, :fifth]), names)

    assert errors == %{
             fourth: %RuntimeError{message: "random error"},
             fifth: :not_found
           }

    assert successful_operations == 3
    assert failed_operations == 2
    assert total_operations == 5
  end

  defmodule MyApp.Commands do
    def run() do
      Treeprit.new()
      |> Treeprit.run(:first, fn _ -> {:ok, 1} end)
      |> Treeprit.run(:second, fn _ -> {:ok, 2} end)
      |> Treeprit.run(:third, &sum_first_and_second_value/1)
      |> Treeprit.run(:fourth, fn _ -> raise "random error" end)
      |> Treeprit.run(:fifth, &sum_first_and_fourth_value/1)
      |> Treeprit.finally()
    end

    # This function will always pattern match because :first and :second runners has these return values
    defp sum_first_and_second_value(%{first: first_value, second: second_value}) do
      {:ok, first_value + second_value}
    end

    # This will not match because :first and :second is always returning {:ok, value}
    defp sum_first_and_second_value(_not_ok) do
      {:error, :first_or_second_not_available}
    end

    # This will not match because :fourth is throwing an error, so it will never pattern match with fourth atom inside the map
    defp sum_first_and_fourth_value(%{first: first_value, fourth: fourth_value}) do
      {:ok, first_value + fourth_value}
    end

    # This will match
    defp sum_first_and_fourth_value(_not_ok) do
      {:error, :first_or_fourth_not_available}
    end
  end

  test "Test readme example" do
    %Treeprit{
      results: results,
      names: names,
      errors: errors,
      successful_operations: successful_operations,
      failed_operations: failed_operations,
      total_operations: total_operations
    } = MyApp.Commands.run()

    assert results == %{
             first: 1,
             second: 2,
             third: 3
           }

    assert MapSet.equal?(MapSet.new([:first, :second, :third, :fourth, :fifth]), names)

    assert errors == %{
             fourth: %RuntimeError{message: "random error"},
             fifth: :first_or_fourth_not_available
           }

    assert successful_operations == 3
    assert failed_operations == 2
    assert total_operations == 5
  end
end
