defmodule ZaqueuWeb.TransactionLive.Index do
  use ZaqueuWeb, :live_logged_in

  import ZaqueuWeb.DisplayHelpers

  alias Zaqueu.Financial
  alias Zaqueu.Financial.Queries.CategoryQueries
  alias Zaqueu.Financial.Queries.InvoiceQueries
  alias Zaqueu.Financial.Queries.KindQueries
  alias Zaqueu.Financial.Queries.TransactionQueries
  alias Zaqueu.Financial.Schemas.Transaction

  @impl true
  def mount(%{"id" => id, "invoice_id" => invoice_id}, _session, socket) do
    month = InvoiceQueries.get_invoice_month_name(invoice_id)
    transactions = TransactionQueries.get_transactions_by_invoice_id(invoice_id)

    credit_card_kind_id =
      KindQueries.get_kind_by_description("Cartão de Crédito").id

    socket =
      socket
      |> assign(:month, month)
      |> assign(:credit_card_id, id)
      |> assign(:invoice_id, invoice_id)
      |> assign(:kind_id, credit_card_kind_id)
      |> assign(:kinds, KindQueries.list_kinds())
      |> assign(:categories, CategoryQueries.list_categories())
      |> stream(:transactions, transactions)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, url, socket) do
    socket = assign(socket, :current_path, url)
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"transaction_id" => transaction_id}) do
    socket
    |> assign(:page_title, "Editar Transação")
    |> assign(
      :transaction,
      TransactionQueries.get_transaction_by_id!(transaction_id)
    )
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Incluir Transação")
    |> assign(:transaction, %Transaction{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Transações")
    |> assign(:transaction, nil)
  end

  @impl true
  def handle_info(
        {ZaqueuWeb.TransactionLive.FormComponent, {:saved, transaction}},
        socket
      ) do
    {:noreply, stream_insert(socket, :transactions, transaction)}
  end

  @impl true
  def handle_event("delete", %{"transaction_id" => transaction_id}, socket) do
    transaction = TransactionQueries.get_transaction_by_id!(transaction_id)
    {:ok, _} = Financial.delete_transaction(transaction)

    {:noreply, stream_delete(socket, :transactions, transaction)}
  end
end
