defmodule TestScss.MixProject do
  use Mix.Project

  def project do
    [
      app: :test_scss,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, "~> 1.6.15 or ~> 1.7.0"},
      {:phoenix_live_view, ">= 0.0.0"}
    ]
  end
end
