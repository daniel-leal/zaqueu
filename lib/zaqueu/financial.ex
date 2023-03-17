defmodule Zaqueu.Financial do
  @moduledoc """
  The Financial context.
  """

  import Ecto.Query, warn: false

  alias Zaqueu.Financial.Commands.BankAccountCommands
  alias Zaqueu.Financial.Commands.CreditCardCommands
  alias Zaqueu.Financial.Queries.BankQueries
  alias Zaqueu.Financial.Queries.BankAccountQueries
  alias Zaqueu.Financial.Queries.CreditCardQueries

  @doc """
  Returns the list of banks.

  ## Examples

      iex> list_banks()
      [%Bank{}, ...]

  """
  defdelegate list_banks(), to: BankQueries, as: :list

  @doc """
  Gets a single bank.

  Raises `Ecto.NoResultsError` if the Bank does not exist.

  ## Examples

      iex> get_bank!(123)
      %Bank{}

      iex> get_bank!(456)
      ** (Ecto.NoResultsError)

  """
  defdelegate get_bank!(id), to: BankQueries, as: :get_by_id

  @doc """
  Returns the list of bank_accounts.

  ## Examples

      iex> list_bank_accounts()
      [%BankAccount{}, ...]

  """
  defdelegate list_bank_accounts(user_id), to: BankAccountQueries, as: :list

  @doc """
  Gets a single bank_account.

  Raises `Ecto.NoResultsError` if the Bank account does not exist.

  ## Examples

      iex> get_bank_account!(123)
      %BankAccount{}

      iex> get_bank_account!(456)
      ** (Ecto.NoResultsError)

  """
  defdelegate get_bank_account!(id), to: BankAccountQueries, as: :get_by_id

  @doc """
  Creates a bank_account.

  ## Examples

      iex> create_bank_account(%{field: value})
      {:ok, %BankAccount{}}

      iex> create_bank_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  defdelegate create_bank_account(attrs \\ %{}),
    to: BankAccountCommands,
    as: :create

  @doc """
  Updates a bank_account.

  ## Examples

      iex> update_bank_account(bank_account, %{field: new_value})
      {:ok, %BankAccount{}}

      iex> update_bank_account(bank_account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  defdelegate update_bank_account(bank_account, attrs \\ %{}),
    to: BankAccountCommands,
    as: :update

  @doc """
  Deletes a bank_account.

  ## Examples

      iex> delete_bank_account(bank_account)
      {:ok, %BankAccount{}}

      iex> delete_bank_account(bank_account)
      {:error, %Ecto.Changeset{}}

  """
  defdelegate delete_bank_account(bank_account),
    to: BankAccountCommands,
    as: :delete

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bank_account changes.

  ## Examples

      iex> change_bank_account(bank_account)
      %Ecto.Changeset{data: %BankAccount{}}

  """
  defdelegate change_bank_account(bank_account, attrs \\ %{}),
    to: BankAccountCommands,
    as: :change

  @doc """
  Returns the list of credit_cards.

  ## Examples

      iex> list_credit_cards()
      [%CreditCard{}, ...]

  """
  defdelegate list_credit_cards(), to: CreditCardQueries, as: :list

  @doc """
  Gets a single credit_card.

  Raises `Ecto.NoResultsError` if the Credit card does not exist.

  ## Examples

      iex> get_credit_card!(123)
      %CreditCard{}

      iex> get_credit_card!(456)
      ** (Ecto.NoResultsError)

  """
  defdelegate get_credit_card!(id), to: CreditCardQueries, as: :get_by_id!

  @doc """
  Creates a credit_card.

  ## Examples

      iex> create_credit_card(%{field: value})
      {:ok, %CreditCard{}}

      iex> create_credit_card(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  defdelegate create_credit_card(attrs \\ %{}),
    to: CreditCardCommands,
    as: :create

  @doc """
  Updates a credit_card.

  ## Examples

      iex> update_credit_card(credit_card, %{field: new_value})
      {:ok, %CreditCard{}}

      iex> update_credit_card(credit_card, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  defdelegate update_credit_card(credit_card, attrs \\ %{}),
    to: CreditCardCommands,
    as: :update

  @doc """
  Deletes a credit_card.

  ## Examples

      iex> delete_credit_card(credit_card)
      {:ok, %CreditCard{}}

      iex> delete_credit_card(credit_card)
      {:error, %Ecto.Changeset{}}

  """
  defdelegate delete_credit_card(credit_card),
    to: CreditCardCommands,
    as: :delete

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking credit_card changes.

  ## Examples

      iex> change_credit_card(credit_card)
      %Ecto.Changeset{data: %CreditCard{}}

  """
  defdelegate change_credit_card(credit_card, attrs \\ %{}),
    to: CreditCardCommands,
    as: :change
end
