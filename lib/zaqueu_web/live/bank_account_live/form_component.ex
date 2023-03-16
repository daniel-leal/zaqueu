defmodule ZaqueuWeb.BankAccountLive.FormComponent do
  use ZaqueuWeb, :live_component

  alias Zaqueu.Financial

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
      </.header>

      <.simple_form
        for={@form}
        id="bank_account-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:bank_id]}
          type="select"
          label="Banco"
          prompt="Selecione um banco..."
          options={Enum.map(@banks, &{&1.name, &1.id})}
        />
        <.input field={@form[:initial_balance]} type="number" label="Saldo Inicial" step="0.01" />
        <.input field={@form[:initial_balance_date]} type="date" label="Data do saldo" />
        <.input field={@form[:agency]} type="text" label="Agência" />
        <.input field={@form[:account_number]} type="text" label="Conta" />
        <:actions>
          <.button phx-disable-with="Salvando...">Salvar</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{bank_account: bank_account} = assigns, socket) do
    changeset = Financial.change_bank_account(bank_account)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"bank_account" => bank_account_params}, socket) do
    changeset =
      socket.assigns.bank_account
      |> Financial.change_bank_account(bank_account_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"bank_account" => bank_account_params}, socket) do
    save_bank_account(socket, socket.assigns.action, bank_account_params)
  end

  defp save_bank_account(socket, :edit, bank_account_params) do
    case Financial.update_bank_account(socket.assigns.bank_account, bank_account_params) do
      {:ok, bank_account} ->
        notify_parent({:saved, bank_account})

        {:noreply,
         socket
         |> put_flash(:info, "Conta bancária atualizada!")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_bank_account(socket, :new, bank_account_params) do
    bank_account_params = Map.put(bank_account_params, "user_id", socket.assigns.user_id)

    case Financial.create_bank_account(bank_account_params) do
      {:ok, bank_account} ->
        notify_parent({:saved, bank_account})

        {:noreply,
         socket
         |> put_flash(:info, "Conta bancária incluída!")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
