defmodule Zaqueu.Financial.CreditCards.GenerateInvoicesTest do
  use Zaqueu.DataCase, async: true
  import Mock

  alias Zaqueu.Financial.Commands.CreditCards.GenerateInvoices

  describe "generate_invoices/1" do
    test "when all params are valid, should create invoices" do
      with_mocks([{Timex, [:passthrough], [today: fn -> ~D[2023-11-08] end]}]) do
        credit_card = insert(:credit_card)

        invoices = GenerateInvoices.generate_invoices(credit_card)

        assert [
                 %{
                   closing_date: ~D[2023-12-07],
                   credit_card_id: _,
                   expiry_date: ~D[2023-12-14],
                   inserted_at: _,
                   is_paid: false,
                   start_date: ~D[2023-11-07],
                   updated_at: _,
                   user_id: nil
                 },
                 %{
                   closing_date: ~D[2024-01-07],
                   credit_card_id: _,
                   expiry_date: ~D[2024-01-14],
                   inserted_at: _,
                   is_paid: false,
                   start_date: ~D[2023-12-07],
                   updated_at: _,
                   user_id: nil
                 }
               ] = invoices
      end
    end
  end
end
