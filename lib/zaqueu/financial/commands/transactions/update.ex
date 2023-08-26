defmodule Zaqueu.Financial.Commands.Transactions.Update do
  alias Zaqueu.Financial.Schemas.Transaction
  alias Zaqueu.Repo

  @doc """
  Updates a transaction.

  ## Examples

      iex> update(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.update_changeset(attrs)
    |> Repo.update()
  end
end
