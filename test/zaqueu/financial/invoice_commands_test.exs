defmodule Zaqueu.Financial.InvoiceCommandsTest do
  use Zaqueu.DataCase, async: true

  alias Zaqueu.Financial
  alias Zaqueu.Financial.Schemas.Invoice

  describe "update/2" do
    test "when all params are valid, should update an invoice" do
      invoice =
        insert(:invoice,
          user: insert(:user),
          credit_card: insert(:credit_card),
          expiry_date: ~D[2023-04-14]
        )

      invoice_new_params =
        params_for(:invoice, %{
          amount: "500.00",
          expiry_date: ~D[2023-04-10],
          is_paid: true
        })

      response = Financial.update_invoice(invoice, invoice_new_params)

      assert {:ok, %Invoice{} = invoice} = response
      assert invoice.amount == Decimal.new("500.00")
      assert invoice.expiry_date == ~D[2023-04-10]
      assert invoice.is_paid
    end
  end
end
