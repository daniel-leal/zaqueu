defmodule Zaqueu.Financial do
  @moduledoc """
  The Financial context.
  """

  import Ecto.Query, warn: false

  alias Zaqueu.Financial.Commands.BankAccountCommands
  alias Zaqueu.Financial.Commands.CreditCardCommands
  alias Zaqueu.Financial.Commands.InvoiceCommands
  alias Zaqueu.Financial.Queries.BankAccountQueries
  alias Zaqueu.Financial.Queries.BankQueries
  alias Zaqueu.Financial.Queries.CreditCardQueries
  alias Zaqueu.Financial.Queries.InvoiceQueries

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
  defdelegate list_credit_cards(user_id), to: CreditCardQueries, as: :list

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

  defdelegate flags(), to: CreditCardQueries, as: :flags

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

  @doc """
  Returns the list of invoices of specific credit_card.

  ## Examples

      iex> list_invoices(credit_card_id)
      [%Invoice{}, ...]

  """
  defdelegate list_invoices(credit_card_id), to: InvoiceQueries, as: :list

  @doc """
  Gets a single invoice.

  Raises `Ecto.NoResultsError` if the Invoice does not exist.

  ## Examples

      iex> get_invoice!(123)
      %Invoice{}

      iex> get_invoice!(456)
      ** (Ecto.NoResultsError)

  """
  defdelegate get_invoice!(id), to: InvoiceQueries, as: :get_by_id!

  @doc """
  Returns a sum of invoices by credit_card_id.

  ## Examples

      iex> get_sum_by_credit_card(credit_card_id)
      Decimal.new(3254.15)

  """
  defdelegate get_sum_by_credit_card(credit_card_id),
    to: InvoiceQueries,
    as: :sum_by_credit_card

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking invoice changes.

  ## Examples

      iex> change_invoice(invoice)
      %Ecto.Changeset{data: %Invoice{}}

  """
  defdelegate change_invoice(invoice, attrs \\ %{}),
    to: InvoiceCommands,
    as: :change

  @doc """
  Updates a invoice.

  ## Examples

      iex> update_invoice(invoice, %{field: new_value})
      {:ok, %Invoice{}}

      iex> update_invoice(invoice, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  defdelegate update_invoice(invoice, attrs \\ %{}),
    to: InvoiceCommands,
    as: :update
end
