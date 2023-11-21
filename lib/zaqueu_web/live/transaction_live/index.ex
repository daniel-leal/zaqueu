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
    transactions = TransactionQueries.get_transactions_by_invoice_id(invoice_id)
    month = InvoiceQueries.get_invoice_month_name(invoice_id)
    total_amount = get_transactions_amount(transactions)

    credit_card_kind_id =
      KindQueries.get_kind_by_description("Cartão de Crédito").id

    socket =
      socket
      |> assign(:month, month)
      |> assign(:total_amount, total_amount)
      |> assign(:credit_card_id, id)
      |> assign(:invoice_id, invoice_id)
      |> assign(:kind_id, credit_card_kind_id)
      |> assign(:kinds, KindQueries.list_kinds())
      |> assign(:categories, CategoryQueries.list_categories())
      |> assign(:search, "")
      |> assign(:transactions_count, length(transactions))
      |> stream(:transactions, transactions)

    {:ok, socket}
  end

  def handle_params(%{"search" => search}, _url, socket) do
    {:noreply, search(socket, search)}
  end

  @impl true
  def handle_params(params, url, socket) do
    socket =
      socket
      |> assign(:current_path, url)

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
    current_amount = socket.assigns.total_amount

    socket =
      socket
      |> assign(
        :total_amount,
        Decimal.add(current_amount, transaction.amount)
      )

    {:noreply, stream_insert(socket, :transactions, transaction)}
  end

  @impl true
  def handle_event("delete", %{"transaction_id" => transaction_id}, socket) do
    current_amount = socket.assigns.total_amount
    transaction = TransactionQueries.get_transaction_by_id!(transaction_id)
    {:ok, _} = Financial.delete_transaction(transaction)

    socket =
      socket
      |> assign(
        :total_amount,
        Decimal.sub(current_amount, transaction.amount)
      )

    {:noreply, stream_delete(socket, :transactions, transaction)}
  end

  @impl true
  def handle_event("search", %{"value" => ""}, socket) do
    id = socket.assigns[:credit_card_id]
    invoice_id = socket.assigns[:invoice_id]

    transactions = TransactionQueries.get_transactions_by_invoice_id(invoice_id)

    socket =
      socket
      |> assign(:total_amount, get_transactions_amount(transactions))
      |> stream(:transactions, transactions, reset: true)

    {:noreply,
     push_patch(socket,
       to: ~p"/credit_cards/#{id}/invoices/#{invoice_id}/transactions/",
       replace: true
     )}
  end

  @impl true
  def handle_event("search", %{"value" => search}, socket) do
    id = socket.assigns[:credit_card_id]
    invoice_id = socket.assigns[:invoice_id]

    {:noreply,
     push_patch(socket,
       to:
         ~p"/credit_cards/#{id}/invoices/#{invoice_id}/transactions/?#{%{search: search}}",
       replace: true
     )}
  end

  def search(socket, search) do
    invoice_id = socket.assigns[:invoice_id]

    transactions_search_result =
      TransactionQueries.search_transactions_by_description(invoice_id, search)

    socket
    |> assign(:form, to_form(%{"search" => search}))
    |> assign(
      :total_amount,
      get_transactions_amount(transactions_search_result)
    )
    |> stream(:transactions, transactions_search_result, reset: true)
  end

  defp get_transactions_amount(transactions) do
    transactions
    |> Enum.map(fn t -> Map.get(t, :amount, 0) end)
    |> Enum.reduce(0, fn t, acc -> Decimal.add(t, acc) end)
  end
end
