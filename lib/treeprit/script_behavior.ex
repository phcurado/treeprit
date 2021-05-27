defmodule Treeprit.ScriptBehaviour do
  @doc """
  Behavior for running your scripts
  """
  @callback run(map()) :: {:ok, term()} | {:error, String.t()} | :throw
end
