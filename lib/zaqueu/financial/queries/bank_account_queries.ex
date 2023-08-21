defmodule Zaqueu.Financial.Queries.BankAccountQueries do
  import Ecto.Query, warn: false

  alias Zaqueu.Financial.Schemas.Bank
  alias Zaqueu.Financial.Schemas.BankAccount
  alias Zaqueu.Repo

  @doc """
  Returns the list of bank_accounts.

  ## Examples

      iex> list(123)
      [%BankAccount{}, ...]

  """
  def list_bank_accounts(user_id) do
    Repo.all(
      from(b in BankAccount,
        where: b.user_id == ^user_id,
        preload: [:bank]
      )
    )
  end

  @doc """
  Gets a single bank_account.

  Raises `Ecto.NoResultsError` if the Bank account does not exist.

  ## Examples

      iex> get_bank_account_by_id!(123)
      %BankAccount{}

      iex> get_bank_account_by_id!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bank_account_by_id!(id) do
    bank_names = from(b in Bank, select: b.name, order_by: :name)

    Repo.one!(
      from(b in BankAccount,
        where: b.id == ^id,
        preload: [bank: ^bank_names]
      )
    )
  end
end
