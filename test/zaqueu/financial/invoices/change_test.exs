defmodule Zaqueu.Financial.Invoices.ChangeTest do
  use Zaqueu.DataCase, async: true

  alias Zaqueu.Financial

  describe "change/2" do
    setup do
      invoice =
        insert(:invoice, %{
          expiry_date: ~D[2023-04-14],
          closing_date: ~D[2023-04-07],
          is_paid: true,
          amount: 100.00
        })

      {:ok, invoice: invoice}
    end

    test "when all params are valid, changeset should not contain errors", %{
      invoice: invoice
    } do
      changeset =
        Financial.change_invoice(invoice, %{
          expiry_date: ~D[2023-04-16],
          amount: Decimal.new("250.00")
        })

      assert %Ecto.Changeset{changes: changes, errors: errors, valid?: valid} =
               changeset

      assert changes == %{
               expiry_date: ~D[2023-04-16],
               amount: Decimal.new("250.00")
             }

      assert errors == []
      assert valid
    end

    test "when expiry_date is invalid, changeset should return an error", %{
      invoice: invoice
    } do
      changeset =
        Financial.change_invoice(invoice, %{
          expiry_date: ~D[2023-04-07],
          is_paid: true,
          amount: Decimal.new("250.00")
        })

      assert %Ecto.Changeset{changes: changes, errors: errors, valid?: valid} =
               changeset

      assert changes == %{
               expiry_date: ~D[2023-04-07],
               amount: Decimal.new("250.00")
             }

      assert errors == [
               {:expiry_date,
                {"A nova data de vencimento deve ter de 3 a 15 dias após a data de fechamento",
                 []}}
             ]

      assert not valid

      changeset =
        Financial.change_invoice(invoice, %{
          expiry_date: ~D[2023-04-28],
          amount: Decimal.new("250.00")
        })

      assert %Ecto.Changeset{changes: changes, errors: errors, valid?: valid} =
               changeset

      assert changes == %{
               expiry_date: ~D[2023-04-28],
               amount: Decimal.new("250.00")
             }

      assert errors == [
               {:expiry_date,
                {"A nova data de vencimento deve ter de 3 a 15 dias após a data de fechamento",
                 []}}
             ]

      assert not valid
    end

    test "when invoice is not paid, amount should be nil", %{invoice: invoice} do
      changeset = Financial.change_invoice(invoice, %{is_paid: false})

      assert %Ecto.Changeset{changes: changes, errors: errors, valid?: valid} =
               changeset

      assert changes == %{
               is_paid: false,
               amount: nil
             }

      assert errors == []

      assert valid == true
    end
  end
end
