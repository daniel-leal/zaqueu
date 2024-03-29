defmodule ZaqueuWeb.CreditCardLive.Index do
  use ZaqueuWeb, :live_logged_in

  import ZaqueuWeb.DisplayHelpers, only: [money: 1]

  alias Zaqueu.Financial
  alias Zaqueu.Financial.Queries.CreditCardQueries
  alias Zaqueu.Financial.Schemas.CreditCard

  @impl true
  def mount(_params, _session, socket) do
    current_user_id = socket.assigns.current_user.id
    credit_cards = CreditCardQueries.list_credit_cards(current_user_id)

    total_limits =
      CreditCardQueries.get_credit_cards_total_limit(current_user_id)

    socket =
      socket
      |> assign(:total_limits, total_limits)
      |> assign(:credit_cards_count, length(credit_cards))
      |> stream(:credit_cards, credit_cards)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, url, socket) do
    socket =
      socket
      |> assign(:current_path, url)

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar cartão")
    |> assign(:credit_card, CreditCardQueries.get_credit_card_by_id!(id))
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
  def handle_info(
        {ZaqueuWeb.CreditCardLive.FormComponent, {:saved, credit_card}},
        socket
      ) do
    {:noreply, stream_insert(socket, :credit_cards, credit_card)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    credit_card = CreditCardQueries.get_credit_card_by_id!(id)
    {:ok, _} = Financial.delete_credit_card(credit_card)

    {:noreply, stream_delete(socket, :credit_cards, credit_card)}
  end
end
