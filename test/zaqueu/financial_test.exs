defmodule Zaqueu.FinancialTest do
  use Zaqueu.DataCase

  alias Zaqueu.Financial

  describe "banks" do
    alias Zaqueu.Financial.Bank

    import Zaqueu.FinancialFixtures

    @invalid_attrs %{code: nil, logo: nil, name: nil}

    test "list_banks/0 returns all banks" do
      bank = bank_fixture()
      assert Financial.list_banks() == [bank]
    end

    test "get_bank!/1 returns the bank with given id" do
      bank = bank_fixture()
      assert Financial.get_bank!(bank.id) == bank
    end

    test "create_bank/1 with valid data creates a bank" do
      valid_attrs = %{code: "some code", logo: "some logo", name: "some name"}

      assert {:ok, %Bank{} = bank} = Financial.create_bank(valid_attrs)
      assert bank.code == "some code"
      assert bank.logo == "some logo"
      assert bank.name == "some name"
    end

    test "create_bank/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Financial.create_bank(@invalid_attrs)
    end

    test "update_bank/2 with valid data updates the bank" do
      bank = bank_fixture()

      update_attrs = %{
        code: "some updated code",
        logo: "some updated logo",
        name: "some updated name"
      }

      assert {:ok, %Bank{} = bank} = Financial.update_bank(bank, update_attrs)
      assert bank.code == "some updated code"
      assert bank.logo == "some updated logo"
      assert bank.name == "some updated name"
    end

    test "update_bank/2 with invalid data returns error changeset" do
      bank = bank_fixture()
      assert {:error, %Ecto.Changeset{}} = Financial.update_bank(bank, @invalid_attrs)
      assert bank == Financial.get_bank!(bank.id)
    end

    test "delete_bank/1 deletes the bank" do
      bank = bank_fixture()
      assert {:ok, %Bank{}} = Financial.delete_bank(bank)
      assert_raise Ecto.NoResultsError, fn -> Financial.get_bank!(bank.id) end
    end

    test "change_bank/1 returns a bank changeset" do
      bank = bank_fixture()
      assert %Ecto.Changeset{} = Financial.change_bank(bank)
    end
  end

  describe "bank_accounts" do
    alias Zaqueu.Financial.BankAccount

    import Zaqueu.FinancialFixtures

    @invalid_attrs %{
      account_number: nil,
      agency: nil,
      initial_balance: nil,
      initial_balance_date: nil
    }

    test "list_bank_accounts/0 returns all bank_accounts" do
      bank_account = bank_account_fixture()
      assert Financial.list_bank_accounts() == [bank_account]
    end

    test "get_bank_account!/1 returns the bank_account with given id" do
      bank_account = bank_account_fixture()
      assert Financial.get_bank_account!(bank_account.id) == bank_account
    end

    test "create_bank_account/1 with valid data creates a bank_account" do
      valid_attrs = %{
        account_number: "some account_number",
        agency: "some agency",
        initial_balance: "120.5",
        initial_balance_date: ~D[2023-03-14]
      }

      assert {:ok, %BankAccount{} = bank_account} = Financial.create_bank_account(valid_attrs)
      assert bank_account.account_number == "some account_number"
      assert bank_account.agency == "some agency"
      assert bank_account.initial_balance == Decimal.new("120.5")
      assert bank_account.initial_balance_date == ~D[2023-03-14]
    end

    test "create_bank_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Financial.create_bank_account(@invalid_attrs)
    end

    test "update_bank_account/2 with valid data updates the bank_account" do
      bank_account = bank_account_fixture()

      update_attrs = %{
        account_number: "some updated account_number",
        agency: "some updated agency",
        initial_balance: "456.7",
        initial_balance_date: ~D[2023-03-15]
      }

      assert {:ok, %BankAccount{} = bank_account} =
               Financial.update_bank_account(bank_account, update_attrs)

      assert bank_account.account_number == "some updated account_number"
      assert bank_account.agency == "some updated agency"
      assert bank_account.initial_balance == Decimal.new("456.7")
      assert bank_account.initial_balance_date == ~D[2023-03-15]
    end

    test "update_bank_account/2 with invalid data returns error changeset" do
      bank_account = bank_account_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Financial.update_bank_account(bank_account, @invalid_attrs)

      assert bank_account == Financial.get_bank_account!(bank_account.id)
    end

    test "delete_bank_account/1 deletes the bank_account" do
      bank_account = bank_account_fixture()
      assert {:ok, %BankAccount{}} = Financial.delete_bank_account(bank_account)
      assert_raise Ecto.NoResultsError, fn -> Financial.get_bank_account!(bank_account.id) end
    end

    test "change_bank_account/1 returns a bank_account changeset" do
      bank_account = bank_account_fixture()
      assert %Ecto.Changeset{} = Financial.change_bank_account(bank_account)
    end
  end

  describe "credit_cards" do
    alias Zaqueu.Financial.CreditCard

    import Zaqueu.FinancialFixtures

    @invalid_attrs %{closing_day: nil, description: nil, flag: nil, limit: nil}

    test "list_credit_cards/0 returns all credit_cards" do
      credit_card = credit_card_fixture()
      assert Financial.list_credit_cards() == [credit_card]
    end

    test "get_credit_card!/1 returns the credit_card with given id" do
      credit_card = credit_card_fixture()
      assert Financial.get_credit_card!(credit_card.id) == credit_card
    end

    test "create_credit_card/1 with valid data creates a credit_card" do
      valid_attrs = %{
        closing_day: 42,
        description: "some description",
        flag: "some flag",
        limit: "120.5"
      }

      assert {:ok, %CreditCard{} = credit_card} = Financial.create_credit_card(valid_attrs)
      assert credit_card.closing_day == 42
      assert credit_card.description == "some description"
      assert credit_card.flag == "some flag"
      assert credit_card.limit == Decimal.new("120.5")
    end

    test "create_credit_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Financial.create_credit_card(@invalid_attrs)
    end

    test "update_credit_card/2 with valid data updates the credit_card" do
      credit_card = credit_card_fixture()

      update_attrs = %{
        closing_day: 43,
        description: "some updated description",
        flag: "some updated flag",
        limit: "456.7"
      }

      assert {:ok, %CreditCard{} = credit_card} =
               Financial.update_credit_card(credit_card, update_attrs)

      assert credit_card.closing_day == 43
      assert credit_card.description == "some updated description"
      assert credit_card.flag == "some updated flag"
      assert credit_card.limit == Decimal.new("456.7")
    end

    test "update_credit_card/2 with invalid data returns error changeset" do
      credit_card = credit_card_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Financial.update_credit_card(credit_card, @invalid_attrs)

      assert credit_card == Financial.get_credit_card!(credit_card.id)
    end

    test "delete_credit_card/1 deletes the credit_card" do
      credit_card = credit_card_fixture()
      assert {:ok, %CreditCard{}} = Financial.delete_credit_card(credit_card)
      assert_raise Ecto.NoResultsError, fn -> Financial.get_credit_card!(credit_card.id) end
    end

    test "change_credit_card/1 returns a credit_card changeset" do
      credit_card = credit_card_fixture()
      assert %Ecto.Changeset{} = Financial.change_credit_card(credit_card)
    end
  end
end
