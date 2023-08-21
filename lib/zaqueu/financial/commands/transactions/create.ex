defmodule Zaqueu.Financial.Commands.Transactions.Create do
  alias Zaqueu.Financial.Schemas.Transaction
  alias Zaqueu.Repo

  @doc """
  Creates a transaction.

  ## Examples

      iex> create(%{field: value})
      {:ok, %Transaction{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end
end
