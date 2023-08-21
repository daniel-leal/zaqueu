defmodule Zaqueu.Financial.Commands.BankAccounts.Update do
  alias Zaqueu.Financial.Schemas.BankAccount
  alias Zaqueu.Repo

  @doc """
  Updates a bank_account.

  ## Examples

      iex> update(bank_account, %{field: new_value})
      {:ok, %BankAccount{}}

      iex> update(bank_account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%BankAccount{} = bank_account, attrs) do
    bank_account
    |> BankAccount.changeset(attrs)
    |> Repo.update()
  end
end
