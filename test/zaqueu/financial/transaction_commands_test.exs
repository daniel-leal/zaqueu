defmodule Zaqueu.Financial.TransactionCommandsTest do
  use Zaqueu.DataCase, async: true

  alias Zaqueu.Financial
  alias Zaqueu.Financial.Schemas.Transaction

  describe "create/1" do
    test "when all params are valid, create a transaction" do
      category = insert(:category)
      kind = insert(:kind, %{description: "Transferência Bancária"})

      transaction_params =
        params_for(:transaction, %{
          category: category,
          kind: kind
        })

      response = Financial.create_transaction(transaction_params)

      assert {:ok, %Transaction{}} = response
    end

    test "when kind is credit_card, invoice should be defined" do
      category = insert(:category)
      kind = insert(:kind, %{description: "Cartão de Crédito"})
      invoice = insert(:invoice)

      transaction_params =
        params_for(:transaction, %{
          category: category,
          kind: kind,
          invoice: invoice
        })

      response = Financial.create_transaction(transaction_params)

      assert {:ok, %Transaction{}} = response
    end

    test "when kind is credit_card, and invoice is not defined, should raise a changeset error" do
      category = insert(:category)
      kind = insert(:kind, %{description: "Cartão de Crédito"})

      transaction_params =
        params_for(:transaction, %{
          category: category,
          kind: kind
        })

      response = Financial.create_transaction(transaction_params)

      assert {:error, %Ecto.Changeset{} = changeset} = response

      assert changeset.errors == [
               invoice_id: {"can't be blank", [{:validation, :required}]}
             ]
    end
  end
end
