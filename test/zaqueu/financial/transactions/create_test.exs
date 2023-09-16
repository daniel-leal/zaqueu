defmodule Zaqueu.Financial.Transactions.CreateTest do
  use Zaqueu.DataCase, async: true

  alias Zaqueu.Financial
  alias Zaqueu.Financial.Schemas.Transaction

  describe "create/1" do
    test "when all params are valid, create a transaction" do
      attrs = params_with_assocs(:transaction)

      response = Financial.create_transaction(attrs)

      assert {:ok, %Transaction{} = transaction} = response

      assert %{
               amount: amount,
               date: ~D[2023-04-02],
               description: "Uber"
             } = transaction

      assert amount == transaction.amount
    end

    test "when params are invalid, should return a changeset with errors" do
      invalid_attrs = %{
        amount: nil,
        date: nil,
        description: nil,
        category_id: nil,
        kind_id: nil
      }

      response = Financial.create_transaction(invalid_attrs)

      assert {:error, %Ecto.Changeset{errors: errors}} = response

      assert errors == [
               {:amount, {"can't be blank", [validation: :required]}},
               {:date, {"can't be blank", [validation: :required]}},
               {:description, {"can't be blank", [validation: :required]}},
               {:category_id, {"can't be blank", [validation: :required]}},
               {:kind_id, {"can't be blank", [validation: :required]}}
             ]
    end

    test "when amount less or equal than 0, should return a changeset with errors" do
      attrs = params_with_assocs(:transaction, amount: 0.00)

      response = Financial.create_transaction(attrs)

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

    test "when transaction kind is credit_card, should have an invoice_id" do
      credit_card_kind = insert(:kind, description: "Cartão de Crédito")
      category = insert(:category)

      attrs =
        params_for(:transaction, %{kind: credit_card_kind, category: category})

      response = Financial.create_transaction(attrs)

      assert {:error, %Ecto.Changeset{errors: errors, valid?: valid?}} =
               response

      assert errors == [
               {:invoice_id, {"can't be blank", [validation: :required]}}
             ]

      assert not valid?
    end

    test "when transaction kind is credit_card, date should be within invoice period" do
      credit_card_kind = insert(:kind, description: "Cartão de Crédito")
      category = insert(:category)

      invoice =
        insert(:invoice,
          start_date: ~D[2023-08-26],
          closing_date: ~D[2023-09-26]
        )

      attrs =
        params_for(:transaction, %{
          kind: credit_card_kind,
          category: category,
          invoice: invoice,
          date: ~D[2023-09-27]
        })

      response = Financial.create_transaction(attrs)

      assert {:error, %Ecto.Changeset{errors: errors, valid?: valid?}} =
               response

      assert not valid?

      assert errors == [
               {:date,
                {"A data da transação deve estar dentro do período da fatura, de: 26/08/2023 até 26/09/2023",
                 []}}
             ]

      attrs =
        params_for(:transaction, %{
          kind: credit_card_kind,
          category: category,
          invoice: invoice,
          date: ~D[2023-08-26]
        })

      response = Financial.create_transaction(attrs)

      assert {:ok, %Transaction{}} = response
    end
  end
end
