defmodule Zaqueu.Financial.CreditCards.UpdateTest do
  use Zaqueu.DataCase, async: true

  alias Zaqueu.Financial
  alias Zaqueu.Financial.Schemas.CreditCard

  describe "update/2" do
    test "when all params are valid, should update credit card" do
      user = insert(:user)

      credit_card =
        insert(:credit_card, %{
          brand: "Visa",
          user: user,
          closing_day: 1,
          expiry_day: 10,
          description: "Nubank Yasmin",
          limit: Decimal.new("1500.00")
        })

      {:ok, updated_credit_card} =
        Financial.update_credit_card(credit_card, %{brand: "MasterCard"})

      assert %CreditCard{
               brand: "MasterCard",
               closing_day: 1,
               expiry_day: 10,
               description: "Nubank Yasmin",
               limit: limit
             } = updated_credit_card

      assert limit == Decimal.new("1500.00")
    end

    test "when params are invalid, should return a changeset" do
      credit_card = insert(:credit_card)

      {:error, changeset} = Financial.update_credit_card(credit_card, %{})

      assert %Ecto.Changeset{errors: errors, valid?: valid?} = changeset
      assert errors == [user_id: {"can't be blank", [validation: :required]}]
      assert not valid?
    end
  end
end
