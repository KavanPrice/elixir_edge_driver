defmodule ElixirEdgeDriver.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_edge_driver,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ElixirEdgeDriver.Application, []}
    ]
  end

  defp deps do
    [
      {:tortoise311, "~> 0.12.0"}
    ]
  end
end
