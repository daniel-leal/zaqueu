defmodule ZaqueuWeb.BankAccountLive.Index do
  use ZaqueuWeb, :live_logged_in

  import ZaqueuWeb.DisplayHelpers, only: [local_date: 1, money: 1]

  alias Zaqueu.Financial
  alias Zaqueu.Financial.Queries.BankAccountQueries
  alias Zaqueu.Financial.Queries.BankQueries
  alias Zaqueu.Financial.Schemas.BankAccount

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    socket =
      socket
      |> assign(:banks, BankQueries.list_banks())
      |> stream(
        :bank_accounts,
        BankAccountQueries.list_bank_accounts(current_user.id)
      )

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
    |> assign(:page_title, "Editar conta bancária")
    |> assign(:bank_account, BankAccountQueries.get_bank_account_by_id!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Incluir conta bancária")
    |> assign(:bank_account, %BankAccount{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Contas Bancárias")
    |> assign(:bank_account, nil)
  end

  @impl true
  def handle_info(
        {ZaqueuWeb.BankAccountLive.FormComponent, {:saved, bank_account}},
        socket
      ) do
    {:noreply, stream_insert(socket, :bank_accounts, bank_account)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    bank_account = BankAccountQueries.get_bank_account_by_id!(id)
    {:ok, _} = Financial.delete_bank_account(bank_account)

    {:noreply, stream_delete(socket, :bank_accounts, bank_account)}
  end
end
