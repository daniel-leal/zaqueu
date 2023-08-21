defmodule ZaqueuWeb.TransactionLive.FormComponent do
  use ZaqueuWeb, :live_component
  import Ecto.Changeset, warn: false

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
        id="transaction-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:invoice_id]} type="hidden" value={@invoice_id} />
        <.input field={@form[:kind_id]} type="hidden" value={@kind_id} />
        <.input field={@form[:description]} type="text" label="Descrição" />
        <.input
          field={@form[:amount]}
          type="number"
          label="Valor"
          step="0.01"
          placeholder="0.00"
        />
        <.input
          field={@form[:date]}
          type="date"
          label="Data da transação"
          value={
            if @form[:date].value == nil,
              do: Timex.today("America/Sao_Paulo"),
              else: @form[:date].value
          }
        />
        <.input
          field={@form[:category_id]}
          type="select"
          label="Categoria"
          prompt="Selecione uma categoria"
          options={Enum.map(@categories, &{&1.description, &1.id})}
        />
        <:actions>
          <.button phx-disable-with="Salvando...">Salvar</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{transaction: transaction} = assigns, socket) do
    changeset = Financial.change_transaction(transaction)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"transaction" => transaction_params}, socket) do
    changeset =
      socket.assigns.transaction
      |> Financial.change_transaction(transaction_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"transaction" => transaction_params}, socket) do
    save_transaction(socket, socket.assigns.action, transaction_params)
  end

  defp save_transaction(socket, :edit, transaction_params) do
    case Financial.update_transaction(
           socket.assigns.transaction,
           transaction_params
         ) do
      {:ok, transaction} ->
        notify_parent({:saved, transaction})

        {:noreply,
         socket
         |> put_flash(:info, "Transação atualizada!")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_transaction(socket, :new, transaction_params) do
    case Financial.create_transaction(transaction_params) do
      {:ok, transaction} ->
        notify_parent({:saved, transaction})

        {:noreply,
         socket
         |> put_flash(:info, "Transação incluída!")
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
