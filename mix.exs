defmodule Treeprit.MixProject do
  use Mix.Project

  @source_url "https://github.com/phcurado/treeprit"
  @version "0.1.0"

  def project do
    [
      app: :treeprit,
      version: @version,
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Hex
      name: "Treeprit",
      description:
        "Run sequentially commands by leverage function results throught pipe operations",
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.24", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "Treeprit",
      source_ref: "v#{@version}",
      source_url: @source_url
    ]
  end

  defp package() do
    [
      maintainers: ["Paulo Curado"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url}
    ]
  end
end
