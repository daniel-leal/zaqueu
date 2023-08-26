defmodule Zaqueu.Financial.Transactions.ChangeTest do
  use Zaqueu.DataCase, async: true

  alias Zaqueu.Financial

  describe "change/2" do
    test "success change existing Transaction" do
      transaction = insert(:transaction)

      changeset =
        Financial.change_transaction(transaction, %{
          amount: Decimal.new("315.27")
        })

      assert %Ecto.Changeset{changes: changes, errors: errors, valid?: valid?} =
               changeset

      assert changes == %{amount: Decimal.new("315.27")}
      assert errors == []
      assert valid?
    end
  end
end
