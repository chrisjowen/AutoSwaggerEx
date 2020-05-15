defmodule AutoSwagger.MixProject do
  use Mix.Project

  def project do
    [
      app: :auto_swagger,
      version: "0.1.0",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib", "test/support"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, "~> 1.3.2"},
      {:phoenix_swagger, "~> 0.8"},
      {:phoenix_ecto, "~> 4.0"},
      {:inflex, "~> 2.0.0"},
      {:rubbergloves, "~> 0.0.6"},
    ]
  end
end
