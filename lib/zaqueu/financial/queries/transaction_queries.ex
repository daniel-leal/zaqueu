defmodule Zaqueu.Financial.Queries.TransactionQueries do
  import Ecto.Query, warn: false

  alias Zaqueu.Financial.Schemas.Transaction
  alias Zaqueu.Repo

  @doc """
  Retrieves transactions by invoice ID.

  ## Examples

      iex> get_transactions_by_invoice_id(123)
      [%Transaction{...}, %Transaction{...}, ...]

  """
  def get_transactions_by_invoice_id(invoice_id) do
    query =
      from(
        t in Transaction,
        where: t.invoice_id == ^invoice_id,
        order_by: t.date,
        preload: [:category]
      )

    Repo.all(query)
  end

  @doc """
  Gets a single Kind.

  Raises `Ecto.NoResultsError` if the Bank does not exist.

  ## Examples

      iex> get_transaction_by_id!(123)
      %Kind{}

      iex> get_transaction_by_id!(456)
      Ecto.NoResultsError

  """
  def get_transaction_by_id!(transaction_id) do
    Repo.get!(Transaction, transaction_id)
  end

  def search_transactions_by_description(invoice_id, description) do
    search_params = "%#{description}%"

    query =
      from(
        t in Transaction,
        where:
          t.invoice_id == ^invoice_id and ilike(t.description, ^search_params),
        order_by: t.date,
        preload: [:category]
      )

    Repo.all(query)
  end
end
