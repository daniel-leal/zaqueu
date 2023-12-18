defmodule Zaqueu.Financial.Transactions.GenerateExcelTest do
  use ExUnit.Case

  alias Zaqueu.Financial.Commands.Transactions.GenerateExcel
  alias Zaqueu.Financial.Schemas.{Category, Transaction}

  test "generate_excel/1 writes correct data to Excel" do
    # Arrange
    transactions = [
      %Transaction{
        description: "Purchase 1",
        category: %Category{description: "Shopping"},
        amount: Decimal.new("50.00"),
        date: ~D[2023-01-15]
      },
      %Transaction{
        description: "Deposit",
        category: %Category{description: "Income"},
        amount: Decimal.new("100.00"),
        date: ~D[2023-01-20]
      }
    ]

    # Act
    result = GenerateExcel.generate_excel(transactions)

    # Assert
    assert {:ok, {filename, filecontent}} = result
    assert is_binary(filecontent)
    assert filename == ~c"invoice_transactions.xlsx"
  end
end
