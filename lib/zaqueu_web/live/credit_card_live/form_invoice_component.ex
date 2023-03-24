defmodule ZaqueuWeb.CreditCardLive.FormInvoiceComponent do
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
        id="invoice-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:expiry_date]} type="date" label="Data de Vencimento" />
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
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"invoice" => invoice_params}, socket) do
    changeset =
      socket.assigns.invoice
      |> Financial.change_invoice(invoice_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"credit_card" => credit_card_params}, socket) do
    save_credit_card(socket, socket.assigns.action, credit_card_params)
  end

  defp save_credit_card(socket, :edit, credit_card_params) do
    case Financial.update_credit_card(
           socket.assigns.credit_card,
           credit_card_params
         ) do
      {:ok, credit_card} ->
        notify_parent({:saved, credit_card})

        {:noreply,
         socket
         |> put_flash(:info, "Cartão de crédito atualizado")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_credit_card(socket, :new, credit_card_params) do
    case Financial.create_credit_card(credit_card_params) do
      {:ok, %{credit_card: credit_card}} ->
        notify_parent({:saved, credit_card})

        {:noreply,
         socket
         |> put_flash(:info, "Cartão de crédito incluído")
         |> push_patch(to: socket.assigns.patch)}

      {:error, :credit_card, %Ecto.Changeset{} = changeset, _} ->
        {:noreply, assign_form(socket, changeset)}

      {:error, :invoice, _, _} ->
        {:noreply,
         socket
         |> put_flash(
           :error,
           "Ocorreu um erro interno. Entre em contato com o administrador!"
         )
         |> push_patch(to: socket.assigns.patch)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
