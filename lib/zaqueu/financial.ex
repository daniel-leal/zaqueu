defmodule Zaqueu.Financial do
  @moduledoc """
  The Financial context.
  """

  import Ecto.Query, warn: false

  alias Zaqueu.Financial.Commands.Banks.CreateIfNotExists,
    as: CreateBankIfNotExists

  alias Zaqueu.Financial.Commands.BankAccounts.Change, as: ChangeBankAccount
  alias Zaqueu.Financial.Commands.BankAccounts.Create, as: CreateBankAccount
  alias Zaqueu.Financial.Commands.BankAccounts.Delete, as: DeleteBankAccount
  alias Zaqueu.Financial.Commands.BankAccounts.Update, as: UpdateBankAccount

  alias Zaqueu.Financial.Commands.Categories.CreateIfNotExists,
    as: CreateCategoryIfNotExists

  alias Zaqueu.Financial.Commands.CreditCards.Change, as: ChangeCreditCard
  alias Zaqueu.Financial.Commands.CreditCards.Create, as: CreateCreditCard
  alias Zaqueu.Financial.Commands.CreditCards.Delete, as: DeleteCreditCard
  alias Zaqueu.Financial.Commands.CreditCards.GenerateInvoices
  alias Zaqueu.Financial.Commands.CreditCards.Update, as: UpdateCreditCard

  alias Zaqueu.Financial.Commands.Invoices.Change, as: ChangeInvoice
  alias Zaqueu.Financial.Commands.Invoices.Update, as: UpdateInvoice

  alias Zaqueu.Financial.Commands.Kinds.CreateIfNotExists,
    as: CreateKindIfNotExists

  alias Zaqueu.Financial.Commands.Transactions.Change, as: ChangeTransaction
  alias Zaqueu.Financial.Commands.Transactions.Create, as: CreateTransaction
  alias Zaqueu.Financial.Commands.Transactions.Delete, as: DeleteTransaction
  alias Zaqueu.Financial.Commands.Transactions.Update, as: UpdateTransaction

  defdelegate change_bank_account(bank_account, attrs \\ %{}),
    to: ChangeBankAccount,
    as: :change

  defdelegate create_bank_account(attrs \\ %{}),
    to: CreateBankAccount,
    as: :create

  defdelegate delete_bank_account(bank_account),
    to: DeleteBankAccount,
    as: :delete

  defdelegate update_bank_account(bank_account, attrs \\ %{}),
    to: UpdateBankAccount,
    as: :update

  defdelegate change_credit_card(credit_card, attrs \\ %{}),
    to: ChangeCreditCard,
    as: :change

  defdelegate create_credit_card(attrs \\ %{}),
    to: CreateCreditCard,
    as: :create

  defdelegate delete_credit_card(credit_card),
    to: DeleteCreditCard,
    as: :delete

  defdelegate generate_invoices(credit_card),
    to: GenerateInvoices,
    as: :generate_invoices

  defdelegate update_credit_card(credit_card, attrs \\ %{}),
    to: UpdateCreditCard,
    as: :update

  defdelegate change_invoice(invoice, attrs \\ %{}),
    to: ChangeInvoice,
    as: :change

  defdelegate update_invoice(invoice, attrs \\ %{}),
    to: UpdateInvoice,
    as: :update

  defdelegate create_bank_if_not_exists(attrs),
    to: CreateBankIfNotExists,
    as: :create_if_not_exists

  defdelegate create_category_if_not_exists(attrs),
    to: CreateCategoryIfNotExists,
    as: :create_if_not_exists

  defdelegate create_kind_if_not_exists(attrs),
    to: CreateKindIfNotExists,
    as: :create_if_not_exists

  defdelegate change_transaction(transaction, attrs \\ %{}),
    to: ChangeTransaction,
    as: :change

  defdelegate create_transaction(attrs),
    to: CreateTransaction,
    as: :create

  defdelegate delete_transaction(transaction),
    to: DeleteTransaction,
    as: :delete

  defdelegate update_transaction(transaction, attrs),
    to: UpdateTransaction,
    as: :update
end
