defmodule Zaqueu.Financial.Queries.BankAccountQueries do
  import Ecto.Query, warn: false

  alias Zaqueu.Repo
  alias Zaqueu.Financial.Schemas.BankAccount
  alias Zaqueu.Financial.Schemas.Bank

  def list(user_id) do
    bank_names = from(b in Bank, select: b.name, order_by: :name)

    Repo.all(
      from(b in BankAccount,
        where: b.user_id == ^user_id,
        preload: [bank: ^bank_names]
      )
    )
  end

  def get_by_id(id) do
    bank_names = from(b in Bank, select: b.name, order_by: :name)

    Repo.one!(
      from(b in BankAccount,
        where: b.id == ^id,
        preload: [bank: ^bank_names]
      )
    )
  end
end
