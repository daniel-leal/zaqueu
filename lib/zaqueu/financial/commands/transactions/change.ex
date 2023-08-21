defmodule Zaqueu.Financial.Commands.Transactions.Change do
  alias Zaqueu.Financial.Schemas.Transaction

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction credit_card changes.

  ## Examples

      iex> change(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end
end
