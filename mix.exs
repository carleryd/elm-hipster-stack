defmodule App.Mixfile do
  use Mix.Project

  def project do
    [app: :app,
     version: "0.0.1",
     elixir: "~> 1.0",
     aliases: ["phoenix.digest": "app.digest"],
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {App, []},
     applications: [:phoenix, :phoenix_html, :cowboy, :logger,
                    :plug_graphql, :phoenix_ecto, :postgrex]]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [{:phoenix, "~> 1.1.4"},
     {:phoenix_ecto, "~> 1.2"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.2"},
     {:phoenix_live_reload, "~> 1.0"},
     {:cowboy, "~> 1.0"},
     {:graphql_relay, "~> 0.0.9"},
     {:plug_graphql, git: "https://github.com/seanabrahams/plug_graphql.git", branch: "relay"},
     {:rethinkdb,"~> 0.3.2"},
     {:cors_plug, "~> 1.1"},
     {:json, "~> 0.3.0"}
     ]
  end
end
