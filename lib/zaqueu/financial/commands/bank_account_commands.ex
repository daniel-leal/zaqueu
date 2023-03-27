defmodule Zaqueu.Financial.Commands.BankAccountCommands do
  alias Zaqueu.Financial.Schemas.BankAccount
  alias Zaqueu.Repo

  def create(attrs \\ %{}) do
    %BankAccount{}
    |> BankAccount.changeset(attrs)
    |> Repo.insert()
  end

  def update(%BankAccount{} = bank_account, attrs) do
    bank_account
    |> BankAccount.changeset(attrs)
    |> Repo.update()
  end

  def delete(%BankAccount{} = bank_account) do
    Repo.delete(bank_account)
  end

  def change(%BankAccount{} = bank_account, attrs \\ %{}) do
    BankAccount.changeset(bank_account, attrs)
  end
end
