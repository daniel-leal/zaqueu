defmodule Zaqueu.Financial.Commands.Transactions.Delete do
  alias Zaqueu.Financial.Schemas.Transaction
  alias Zaqueu.Repo

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete(transaction)
      {:ok, %Transaction{}}

      iex> delete(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end
end
