defmodule ErlWebScaffold.Mixfile do
  use Mix.Project

  def project do
    [app: :erl_web_scaffold,
      version: "0.0.1",
      elixir: "~> 1.7",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      language: :erlang,
      erlc_options: [:debug_info, {:d, :debug}],
    ]
  end

  def application do
    [mod: {:erl_web_scaffold, []},
    ]
  end

  defp deps do
    [
      {:mix_erlang_tasks, "0.1.0"},
      {:cowboy, "~> 2.4"},
      {:epgsql, "~> 4.1"},
      {:dialyxir, "~> 0.5.1"},
      {:lager, "~> 3.2"},
    ]
  end
end