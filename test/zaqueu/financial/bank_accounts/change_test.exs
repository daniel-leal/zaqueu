defmodule Zaqueu.Financial.BankAccounts.ChangeTest do
  use Zaqueu.DataCase, async: true

  alias Zaqueu.Financial

  describe "change/2" do
    test "success change existing bank_account" do
      bank_account = insert(:bank_account)

      changeset =
        Financial.change_bank_account(bank_account, %{account_number: "45775"})

      assert %Ecto.Changeset{changes: changes, errors: errors, valid?: valid?} =
               changeset

      assert changes == %{account_number: "45775"}
      assert errors == []
      assert valid?
    end
  end
end
