[
  import_deps: [:ecto, :ecto_sql, :phoenix],
  subdirectories: ["priv/*/migrations"],
  plugins: [Phoenix.LiveView.HTMLFormatter],
  inputs:
    Enum.flat_map(
      [
        "*.{heex,ex,exs}",
        "{config,lib,test}/**/*.{heex,ex,exs}",
        "priv/*/seeds.exs"
      ],
      &Path.wildcard(&1, match_dot: true)
    ) -- [".credo.exs", "lib/zaqueu_web/components/core_components.ex"],
  line_length: 80
]
