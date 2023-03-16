defmodule ZaqueuWeb.CreditCardLive.Show do
  use ZaqueuWeb, :live_view

  import ZaqueuWeb.DisplayHelpers, only: [money: 1]

  alias Zaqueu.Financial

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:credit_card, Financial.get_credit_card!(id))}
  end

  defp page_title(:show), do: "Cartão de crédito"
  defp page_title(:edit), do: "Editar"
end
