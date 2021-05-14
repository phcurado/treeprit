defmodule TreepritTest do
  use ExUnit.Case
  doctest Treeprit

  test "Run functions" do
    result =
      Treeprit.new()
      |> Treeprit.run(:first, fn _ -> %{first_value: 1} end)
      |> Treeprit.run(:second, fn _ -> %{second_value: 2} end)
      |> Treeprit.run(:third, fn %{
                                   first: {:ok, %{first_value: first_value}},
                                   second: {:ok, %{second_value: second_value}}
                                 } ->
        %{third_value: first_value + second_value}
      end)
      |> Treeprit.run(:fourth, fn _ -> raise "random error" end)

    assert result == %Treeprit{
             operations: %{
               first: {:ok, %{first_value: 1}},
               second: {:ok, %{second_value: 2}},
               third: {:ok, %{third_value: 3}},
               fourth: {:error, %RuntimeError{message: "random error"}}
             },
             successful_operations: 3,
             failed_operations: 1,
             total_operations: 4
           }
  end
end
