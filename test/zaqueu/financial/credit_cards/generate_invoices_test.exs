defmodule Zaqueu.Financial.CreditCards.GenerateInvoicesTest do
  alias Zaqueu.DataCase, async: true

  alias Zaqueu.Financial.Commands.CreditCards.GenerateInvoices

  describe "generate_invoices/1" do
    test "when all params are valid, should create invoices" do
      credit_card = insert(:credit_card, %{closing_day: 8})

      invoices = GenerateInvoices.generate_invoices(credit_card)
    end
  end
end
