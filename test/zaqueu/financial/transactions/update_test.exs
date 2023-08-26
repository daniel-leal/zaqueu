defmodule Zaqueu.Financial.Transactions.UpdateTest do
  use Zaqueu.DataCase, async: true

  alias Zaqueu.Financial
  alias Zaqueu.Financial.Schemas.Transaction

  describe "update/2" do
    setup do
      kind = insert(:kind, description: "Transferência Bancária")
      transaction = insert(:transaction, kind: kind)
      {:ok, transaction: transaction}
    end

    test "when all params are valid, should update the transaction", %{
      transaction: transaction
    } do
      attrs = %{
        amount: Decimal.new("14.88"),
        date: ~D[2023-02-01],
        description: "IFood"
      }

      response = Financial.update_transaction(transaction, attrs)

      assert {:ok, %Transaction{} = transaction} = response
      assert transaction.amount == Decimal.new("14.88")
      assert transaction.date == ~D[2023-02-01]
      assert transaction.description == "IFood"
    end

    test "when params are invalid, should return a changeset with errors", %{
      transaction: transaction
    } do
      invalid_attrs = %{
        amount: nil,
        date: nil,
        description: nil,
        category_id: nil,
        kind_id: nil
      }

      response = Financial.update_transaction(transaction, invalid_attrs)

      assert {:error, %Ecto.Changeset{errors: errors}} = response

      assert errors == [
               {:amount, {"can't be blank", [validation: :required]}},
               {:date, {"can't be blank", [validation: :required]}},
               {:description, {"can't be blank", [validation: :required]}},
               {:category_id, {"can't be blank", [validation: :required]}},
               {:kind_id, {"can't be blank", [validation: :required]}}
             ]
    end

    test "when amount less or equal than 0, should return a changeset with errors",
         %{
           transaction: transaction
         } do
      attrs = %{amount: Decimal.new("0.00")}

      response = Financial.update_transaction(transaction, attrs)

      assert {:error, %Ecto.Changeset{errors: errors}} = response

      assert errors == [
               {:amount,
                {"must be greater than %{number}",
                 [
                   validation: :number,
                   kind: :greater_than,
                   number: Decimal.new("0.00")
                 ]}}
             ]
    end
  end
end
