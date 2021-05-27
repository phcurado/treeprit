defmodule Treeprit.Code do
  @moduledoc """
  This module will help compiling your scripts.
  Invoke the `load_scripts/1` inside your main script file. This function takes the folder path as the first argument and as result will load all scripts from that folder.
  That way your .exs file is ready to run all modules declared in that folder.
  """

  @doc """
  Load scripts inside a folder
  ## Example
      # inside your seed.exs file
      Treeprit.Code.load_scripts("repo/seeds")

      Treeprit.new()
      |> Treeprit.run(:role, MyProject.Seeds.Role)
      |> Treeprit.run(:user, MyProject.Seeds.User)
      |> Treeprit.run_if_env(:user_admin, MyProject.Seeds.UserAdmin, :dev)
      |> Treeprit.finally()
  """
  @spec load_scripts(String.t()) :: :ok | :throw
  def load_scripts(subdir) when is_binary(subdir) do
    :treeprit
    |> Application.fetch_env!(:app)
    |> load_scripts(subdir)
  end

  @doc """
  It is the same for `load_script/1`, but the first argument is the application name.
  """
  @spec load_scripts(atom(), String.t()) :: :ok | :throw
  def load_scripts(app, subdir) do
    scripts_dir = Path.join("#{:code.priv_dir(app)}", subdir)

    scripts_dir
    |> File.ls!()
    |> Enum.filter(fn path -> Path.extname(path) == ".exs" end)
    |> Enum.each(fn path ->
      Code.require_file(path, scripts_dir)
    end)
  end
end
