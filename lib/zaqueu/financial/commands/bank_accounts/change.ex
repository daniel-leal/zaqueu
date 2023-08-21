defmodule Zaqueu.Financial.Commands.BankAccounts.Change do
  alias Zaqueu.Financial.Schemas.BankAccount

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bank_account changes.

  ## Examples

      iex> change(bank_account)
      %Ecto.Changeset{data: %BankAccount{}}

  """
  def change(%BankAccount{} = bank_account, attrs \\ %{}) do
    BankAccount.changeset(bank_account, attrs)
  end
end
