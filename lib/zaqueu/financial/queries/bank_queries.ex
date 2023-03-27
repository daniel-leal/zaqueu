defmodule Zaqueu.Financial.Queries.BankQueries do
  import Ecto.Query, warn: false

  alias Zaqueu.Repo

  alias Zaqueu.Financial.Schemas.Bank

  def list do
    Repo.all(
      from(b in Bank,
        order_by: b.name
      )
    )
  end

  def get_by_id(id), do: Repo.get!(Bank, id)
end
