defmodule ZaqueuWeb.CreditCardLive.FormInvoiceComponent do
  use ZaqueuWeb, :live_component

  alias Zaqueu.Financial
  alias Zaqueu.Financial.Schemas.Invoice

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
      </.header>

      <.simple_form
        for={@form}
        id="invoice-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:expiry_date]} type="date" label="Data de Vencimento" />

        <%= if Invoice.payable?(@invoice) do %>
          <.input
            field={@form[:is_paid]}
            type="select"
            label="Pago?"
            options={[{"Sim", true}, {"Não", false}]}
            phx-change="is_paid_changed"
          />
        <% end %>

        <%= if @is_paid == "true" or @is_paid == true do %>
          <.input
            field={@form[:amount]}
            id="amount"
            type="number"
            label="Valor Pago"
            step="0.01"
            placeholder="0.00"
            value={@amount}
          />
        <% end %>

        <:actions>
          <.button phx-disable-with="Salvando...">Salvar</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{invoice: invoice} = assigns, socket) do
    changeset = Financial.change_invoice(invoice)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:is_paid, assigns.invoice.is_paid)
     |> assign_form(changeset)}
  end

  def handle_event(
        "is_paid_changed",
        %{"invoice" => %{"is_paid" => is_paid}},
        socket
      ) do
    {:noreply, assign(socket, is_paid: is_paid)}
  end

  @impl true
  def handle_event("validate", %{"invoice" => invoice_params}, socket) do
    changeset =
      socket.assigns.invoice
      |> Financial.change_invoice(invoice_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"invoice" => invoice_params}, socket) do
    save_invoice(socket, socket.assigns.action, invoice_params)
  end

  defp save_invoice(socket, :edit, invoice_params) do
    case Financial.update_invoice(
           socket.assigns.invoice,
           invoice_params
         ) do
      {:ok, invoice} ->
        notify_parent({:saved, invoice})

        {:noreply,
         socket
         |> put_flash(:info, "Fatura atualizada com sucesso!")
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
