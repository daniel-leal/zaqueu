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
    |> handle_insert()
  end

  defp handle_insert({:ok, transaction}) do
    transaction =
      Repo.get(Transaction, transaction.id) |> Repo.preload(:category)

    {:ok, transaction}
  end

  defp handle_insert({:error, changeset}), do: {:error, changeset}
end
