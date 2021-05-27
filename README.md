# Treeprit

Treeprit helps you run sequentially commands that may or may not fail during the process.

```Elixir
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
```

Then when you try to run this module on your shell, you will have the given results:

```Elixir
iex> MyApp.Commands.run()
%Treeprit{
  results: %{
    first: 1,
    second: 2,
    third: 3
  },
  errors: %{
    fourth: %RuntimeError{message: "random error"},
    fifth: :first_or_fourth_not_available
  },
  successful_operations: 3,
  failed_operations: 2,
  total_operations: 5
}
```

## Installation

Add this project to your dependencies

```Elixir
def deps do
  [
    {:treeprit, "~> 0.1"}
  ]
end
```

## Usage

A great example for this library usage is the common `seed.exs` in Ecto projects. If you need a more structured way for running seeds, you can use this package and organize them with modules. Take a look at [this](priv/repo) example.


