defmodule Zaqueu.Financial.CreditCards.CreateTest do
  use Zaqueu.DataCase, async: true

  alias Zaqueu.Financial
  alias Zaqueu.Financial.Schemas.CreditCard

  describe "create/1" do
    test "when all params are valid, create a credit_card and invoices" do
      user = insert(:user)
      attrs = params_for(:credit_card, user: user)

      response = Financial.create_credit_card(attrs)

      assert {
               :ok,
               %{
                 credit_card:
                   %CreditCard{
                     id: _,
                     closing_day: 7,
                     expiry_day: 14,
                     description: "Itau Card",
                     brand: "MasterCard",
                     limit: _,
                     user_id: _
                   } = credit_card,
                 invoices: {rows, nil}
               }
             } = response

      assert Decimal.compare(1500, credit_card.limit)
      assert rows > 0
    end
  end

  test "when params are invalid, returns the changeset errors" do
    response = Financial.create_credit_card(%{})

    assert {:error, :credit_card,
            %Ecto.Changeset{
              action: :insert,
              changes: %{},
              errors: [
                expiry_day: {"can't be blank", [validation: :required]},
                description: {"can't be blank", [validation: :required]},
                brand: {"can't be blank", [validation: :required]},
                closing_day: {"can't be blank", [validation: :required]},
                limit: {"can't be blank", [validation: :required]},
                user_id: {"can't be blank", [validation: :required]}
              ],
              data: _data,
              valid?: false
            }, _} = response
  end

  test "when numbers are invalid, returns the changeset errors" do
    user = insert(:user)

    attrs =
      params_for(:credit_card, %{
        user: user,
        closing_day: 32,
        expiry_day: 32,
        limit: 0
      })

    response = Financial.create_credit_card(attrs)

    expected_errors = [
      {:limit,
       {"must be greater than %{number}",
        [validation: :number, kind: :greater_than, number: Decimal.new("0")]}},
      {:expiry_day,
       {"must be less than %{number}",
        [validation: :number, kind: :less_than, number: 32]}},
      {:closing_day,
       {"must be less than %{number}",
        [validation: :number, kind: :less_than, number: 32]}}
    ]

    assert {:error, :credit_card, %Ecto.Changeset{} = changeset, _} = response
    assert expected_errors == changeset.errors
  end
end
