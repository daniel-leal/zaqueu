defmodule ZaqueuWeb.TransactionsController do
  use ZaqueuWeb, :controller

  alias Zaqueu.Financial
  alias Zaqueu.Financial.Queries.TransactionQueries

  def export(conn, %{"invoice_id" => invoice_id}) do
    {:ok, {filename, binary}} =
      invoice_id
      |> TransactionQueries.get_transactions_by_invoice_id()
      |> Financial.generate_transactions_excel()

    send_download(conn, {:binary, binary}, filename: List.to_string(filename))
  end
end
