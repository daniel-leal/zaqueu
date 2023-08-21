defmodule Zaqueu.Financial.Commands.BankAccounts.Create do
  alias Zaqueu.Financial.Schemas.BankAccount
  alias Zaqueu.Repo

  @doc """
  Creates a bank_account.

  ## Examples

      iex> create_bank_account(%{field: value})
      {:ok, %BankAccount{}}

      iex> create_bank_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs \\ %{}) do
    %BankAccount{}
    |> BankAccount.changeset(attrs)
    |> Repo.insert()
    |> handle_insert()
  end

  defp handle_insert({:ok, bank_account}) do
    bank_account_with_bank = Repo.preload(bank_account, :bank)
    {:ok, bank_account_with_bank}
  end

  defp handle_insert({:error, changeset}), do: {:error, changeset}
end
