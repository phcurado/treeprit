defmodule Treeprit.Repo.Seeds.Role do

  @behaviour Treeprit.ScriptBehaviour

  @impl true
  def run(_) do
    {:ok, %{name: "admin"}}
  end
end
