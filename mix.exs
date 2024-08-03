defmodule BackBreeze.MixProject do
  use Mix.Project

  def project do
    [
      app: :back_breeze,
      description: "A terminal layout rendering library.",
      package: package(),
      version: "0.2.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "BackBreeze",
      source_url: "https://github.com/Gazler/back_breeze"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package() do
    [
      files: ~w(lib .formatter.exs mix.exs README.md LICENCE.md),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/Gazler/back_breeze"}
    ]
  end

  defp deps do
    [
      {:termite, "~> 0.2.0"},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false}
    ]
  end
end
