defmodule Treeprit.Repo.Seeds.User do

  @behaviour Treeprit.ScriptBehaviour

  @impl true
  def run(%{role: role}) do
    {:ok, %{username: "test_test", role: role}}
  end
end
