defmodule Zaqueu.Financial.CreditCards.ChangeTest do
  use Zaqueu.DataCase, async: true

  alias Zaqueu.Financial

  describe "change/2" do
    test "success change existing CreditCard" do
      credit_card = insert(:credit_card)

      changeset = Financial.change_credit_card(credit_card, %{brand: "Visa"})

      assert %Ecto.Changeset{changes: changes, errors: errors, valid?: valid} =
               changeset

      assert changes == %{brand: "Visa"}
      assert errors == [user_id: {"can't be blank", [validation: :required]}]
      assert not valid
    end
  end
end
