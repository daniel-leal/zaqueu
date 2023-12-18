defmodule Zaqueu.Financial.Commands.Transactions.GenerateExcel do
  alias Elixlsx.{Sheet, Workbook}

  @doc """
  Generates an Excel spreadsheet containing transaction data.

  ## Parameters

  - `transactions` (list): A list of transaction structs.

  ## Returns

  An Excel spreadsheet in memory containing the transaction data.

  ## Example
  transactions = [
    %Transaction{
      description: "Purchase 1",
      category: %Category{description: "Shopping"},
      amount: Decimal.new(50.00),
      date: ~D[2023-01-15]
    },
    %Transaction{
      description: "Deposit",
      category: %Category{description: "Income"},
      amount: Decimal.new(100.00),
      date: ~D[2023-01-20]
    }
  ]
  """
  def generate_excel(transactions) do
    columns = build_headers()
    rows = build_rows(transactions)
    table_data = [columns] ++ rows

    sheet = build_transactions_sheet(table_data)

    workbook = %Workbook{sheets: [sheet]}
    Elixlsx.write_to_memory(workbook, "invoice_transactions.xlsx")
  end

  defp build_headers do
    [
      ["description", bold: true, align_horizontal: :center],
      ["category", bold: true, align_horizontal: :center],
      ["amount", bold: true, align_horizontal: :right],
      ["date", bold: true, align_horizontal: :right]
    ]
  end

  defp build_rows(transactions) do
    for t <- transactions,
        do: [
          t.description,
          t.category.description,
          Decimal.to_float(t.amount),
          [Date.to_string(t.date), align_horizontal: :right]
        ]
  end

  defp build_transactions_sheet(table_data) do
    %Sheet{
      name: "Transactions",
      rows: table_data
    }
    |> Sheet.set_row_height(1, 20)
    |> Sheet.set_col_width("A", 30)
    |> Sheet.set_col_width("B", 30)
    |> Sheet.set_col_width("C", 18)
    |> Sheet.set_col_width("D", 18)
  end
end
