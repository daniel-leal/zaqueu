defmodule Zaqueu.Financial.BankAccounts.UpdateTest do
  use Zaqueu.DataCase, async: true

  alias Zaqueu.Financial
  alias Zaqueu.Financial.Schemas.BankAccount

  describe "update/2" do
    test "when all params are valid, should update a bank_account" do
      bank_account =
        insert(:bank_account, user: insert(:user), bank: insert(:bank))

      bank_account_new_params =
        params_for(:bank_account, %{
          agency: "741258",
          initial_balance: "1825",
          initial_balance_date: ~D[2023-03-15],
          account_number: "44874"
        })

      response =
        Financial.update_bank_account(bank_account, bank_account_new_params)

      assert {:ok, %BankAccount{} = bank_account} = response
      assert bank_account.agency == "741258"
      assert bank_account.initial_balance == Decimal.new("1825")
      assert bank_account.initial_balance_date == ~D[2023-03-15]
      assert bank_account.account_number == "44874"
    end

    test "when all params are invalid, should not update a bank_account" do
      bank_account =
        insert(:bank_account, user: insert(:user), bank: insert(:bank))

      bank_account_new_invalid_params = %{
        agency: "01",
        account_number: "01",
        user_id: nil,
        bank_id: nil,
        initial_balance: nil,
        initial_balance_date: nil
      }

      response =
        Financial.update_bank_account(
          bank_account,
          bank_account_new_invalid_params
        )

      assert {:error, %Ecto.Changeset{} = changeset} = response

      assert %{
               errors: [
                 account_number:
                   {"should be at least %{count} character(s)",
                    [count: 3, validation: :length, kind: :min, type: :string]},
                 agency:
                   {"should be at least %{count} character(s)",
                    [count: 3, validation: :length, kind: :min, type: :string]},
                 user_id: {"can't be blank", [validation: :required]},
                 bank_id: {"can't be blank", [validation: :required]},
                 initial_balance: {"can't be blank", [validation: :required]},
                 initial_balance_date:
                   {"can't be blank", [validation: :required]}
               ]
             } = changeset
    end
  end
end
