defmodule Zaqueu.FinancialFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Zaqueu.Financial` context.
  """

  @doc """
  Generate a unique bank code.
  """
  def unique_bank_code, do: "some code#{System.unique_integer([:positive])}"

  @doc """
  Generate a bank.
  """
  def bank_fixture(attrs \\ %{}) do
    {:ok, bank} =
      attrs
      |> Enum.into(%{
        code: unique_bank_code(),
        logo: "some logo",
        name: "some name"
      })
      |> Zaqueu.Financial.create_bank()

    bank
  end

  @doc """
  Generate a bank_account.
  """
  def bank_account_fixture(attrs \\ %{}) do
    {:ok, bank_account} =
      attrs
      |> Enum.into(%{
        account_number: "some account_number",
        agency: "some agency",
        initial_balance: "120.5",
        initial_balance_date: ~D[2023-03-14]
      })
      |> Zaqueu.Financial.create_bank_account()

    bank_account
  end

  @doc """
  Generate a credit_card.
  """
  def credit_card_fixture(attrs \\ %{}) do
    {:ok, credit_card} =
      attrs
      |> Enum.into(%{
        closing_day: 42,
        description: "some description",
        flag: "some flag",
        limit: "120.5"
      })
      |> Zaqueu.Financial.create_credit_card()

    credit_card
  end
end
