defmodule ZaqueuWeb.BankAccountLive.Show do
  use ZaqueuWeb, :live_logged_in

  import ZaqueuWeb.DisplayHelpers, only: [money: 1, local_date: 1]

  alias Zaqueu.Financial.Queries.BankAccountQueries

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, url, socket) do
    {:noreply,
     socket
     |> assign(:current_path, url)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:bank_account, BankAccountQueries.get_bank_account_by_id!(id))}
  end

  defp page_title(:show), do: "Conta bancária"
  defp page_title(:edit), do: "Editar conta"
end
