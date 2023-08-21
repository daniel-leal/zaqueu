defmodule Zaqueu.Financial.Commands.BankAccounts.Delete do
  alias Zaqueu.Financial.Schemas.BankAccount
  alias Zaqueu.Repo

  @doc """
  Deletes a bank_account.

  ## Examples

      iex> delete(bank_account)
      {:ok, %BankAccount{}}

      iex> delete(bank_account)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%BankAccount{} = bank_account) do
    Repo.delete(bank_account)
  end
end
