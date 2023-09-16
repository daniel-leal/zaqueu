defmodule ZaqueuWeb.CreditCardLive.Show do
  use ZaqueuWeb, :live_logged_in

  import ZaqueuWeb.DisplayHelpers

  alias Zaqueu.Financial.Queries.CreditCardQueries
  alias Zaqueu.Financial.Queries.InvoiceQueries

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def handle_params(
        %{"id" => id, "invoice_id" => invoice_id} = params,
        url,
        socket
      ) do
    socket =
      socket
      |> assign(:current_path, url)
      |> assign(:credit_card, CreditCardQueries.get_credit_card_by_id!(id))
      |> assign(:total, InvoiceQueries.get_total_invoices_by_credit_card(id))
      |> assign(:invoice, InvoiceQueries.get_invoice_by_id!(invoice_id))
      |> assign(:invoices, InvoiceQueries.list_invoices(id))

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_params(%{"id" => id}, url, socket) do
    {:noreply,
     socket
     |> assign(:current_path, url)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:credit_card, CreditCardQueries.get_credit_card_by_id!(id))
     |> assign(:total, InvoiceQueries.get_total_invoices_by_credit_card(id))
     |> assign(:invoices, InvoiceQueries.list_invoices(id))}
  end

  defp apply_action(socket, :edit, %{"id" => id, "invoice_id" => invoice_id}) do
    socket
    |> assign(:page_title, "Editar Fatura")
    |> assign(:credit_card, CreditCardQueries.get_credit_card_by_id!(id))
    |> assign(:invoice, InvoiceQueries.get_invoice_by_id!(invoice_id))
  end

  defp page_title(:show), do: "Cartão de crédito"
  defp page_title(:edit), do: "Editar"
end
