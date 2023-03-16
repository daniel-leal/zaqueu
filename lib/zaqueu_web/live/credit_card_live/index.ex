defmodule ZaqueuWeb.CreditCardLive.Index do
  use ZaqueuWeb, :live_view

  import ZaqueuWeb.DisplayHelpers, only: [money: 1]

  alias Zaqueu.Financial
  alias Zaqueu.Financial.CreditCard

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :credit_cards, Financial.list_credit_cards())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar cartão")
    |> assign(:credit_card, Financial.get_credit_card!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Incluir cartão")
    |> assign(:credit_card, %CreditCard{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Cartões de crédito")
    |> assign(:credit_card, nil)
  end

  @impl true
  def handle_info({ZaqueuWeb.CreditCardLive.FormComponent, {:saved, credit_card}}, socket) do
    {:noreply, stream_insert(socket, :credit_cards, credit_card)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    credit_card = Financial.get_credit_card!(id)
    {:ok, _} = Financial.delete_credit_card(credit_card)

    {:noreply, stream_delete(socket, :credit_cards, credit_card)}
  end
end
