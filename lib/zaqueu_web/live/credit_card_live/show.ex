defmodule ZaqueuWeb.CreditCardLive.Show do
  use ZaqueuWeb, :live_logged_in

  import ZaqueuWeb.DisplayHelpers

  alias Zaqueu.Financial

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def handle_params(
        %{"id" => id, "invoice_id" => invoice_id} = params,
        _url,
        socket
      ) do
    socket =
      socket
      |> assign(:credit_card, Financial.get_credit_card!(id))
      |> assign(:total, Financial.get_sum_by_credit_card(id))
      |> assign(:invoice, Financial.get_invoice!(invoice_id))
      |> assign(:invoices, Financial.list_invoices(id))

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:credit_card, Financial.get_credit_card!(id))
     |> assign(:total, Financial.get_sum_by_credit_card(id))
     |> assign(:invoices, Financial.list_invoices(id))}
  end

  defp apply_action(socket, :edit, %{"id" => id, "invoice_id" => invoice_id}) do
    socket
    |> assign(:page_title, "Editar Fatura")
    |> assign(:credit_card, Financial.get_credit_card!(id))
    |> assign(:invoice, Financial.get_invoice!(invoice_id))
  end

  defp page_title(:show), do: "Cartão de crédito"
  defp page_title(:edit), do: "Editar"
end
