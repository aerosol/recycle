defmodule Gencycle.MixProject do
  use Mix.Project

  def project do
    [
      app: :recycle,
      description: "Convenience wrapper around gen_cycle behaviour",
      version: "0.1.1",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
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
      {:gen_cycle, "1.0.2"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["Adam Rutkowski"],
      licenses: ["Apache2"],
      links: %{"GitHub" => "https://github.com/aerosol/recycle"}
    ]
  end
end
