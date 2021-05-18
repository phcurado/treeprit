defmodule Treeprit.ScriptBehaviour do
  @doc """
  Function to run the script
  """
  @callback run(map()) :: {:ok, term()} | {:error, String.t()} | :throw
end
