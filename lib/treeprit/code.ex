defmodule Treeprit.Code do
  @moduledoc """
  This module will help compiling your scripts
  """

  @spec load_scripts(String.t()) :: :ok | :throw
  def load_scripts(subdir) when is_binary(subdir) do
    :treeprit
    |> Application.fetch_env!(:app)
    |> load_scripts(subdir)
  end

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
