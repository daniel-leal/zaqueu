defmodule Zaqueu.Repo do
  use Ecto.Repo,
    otp_app: :zaqueu,
    adapter: Ecto.Adapters.Postgres
end
