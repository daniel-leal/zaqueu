defmodule Zaqueu.Financial.BankAccounts.CreateTest do
  use Zaqueu.DataCase, async: true

  alias Zaqueu.Financial
  alias Zaqueu.Financial.Schemas.BankAccount

  describe "create/1" do
    test "when all params are valid, should create a bank_account" do
      user = insert(:user)
      bank = insert(:bank)

      bank_account_params = params_for(:bank_account, %{user: user, bank: bank})

      response = Financial.create_bank_account(bank_account_params)

      assert {:ok, %BankAccount{} = bank_account} = response
      assert bank_account.id != nil
    end

    test "when params are invalid, should return a changeset with errors" do
      invalid_attrs = %{
        agency: "01",
        account_number: "01",
        user_id: nil,
        bank_id: nil,
        initial_balance: nil,
        initial_balance_date: nil
      }

      response = Financial.create_bank_account(invalid_attrs)

      assert {:error, %Ecto.Changeset{} = changeset} = response

      assert %{
               account_number: ["should be at least 3 character(s)"],
               agency: ["should be at least 3 character(s)"],
               bank_id: ["can't be blank"],
               initial_balance: ["can't be blank"],
               initial_balance_date: ["can't be blank"],
               user_id: ["can't be blank"]
             } == errors_on(changeset)
    end
  end
end
