defmodule ZaqueuWeb.UserConfirmationLive do
  use ZaqueuWeb, :live_view

  alias Zaqueu.Identity

  def render(%{live_action: :edit} = assigns) do
    ~H"""
    <div class="w-full bg-white rounded-lg shadow dark:border md:mt-0 sm:max-w-md xl:p-0 dark:bg-slate-800 dark:border-gray-700">
      <div class="p-6 space-y-4 md:space-y-6 sm:p-8">
        <h1 class="text-center text-xl font-bold leading-tight tracking-tight text-gray-900 md:text-2xl dark:text-white">
          Confirmar conta!
        </h1>
        <.simple_form
          for={@form}
          id="confirmation_form"
          phx-submit="confirm_account"
          color="bg-slate-800"
        >
          <.input field={@form[:token]} type="hidden" />
          <:actions>
            <.button phx-disable-with="Confirming..." class="w-full">Confirmar minha conta</.button>
          </:actions>
        </.simple_form>

        <p class="text-center mt-4">
          <.link href={~p"/users/log_in"} class="text-gray-400 hover:underline">
            Acessar
          </.link>
          <span class="text-gray-400">|</span>
          <.link href={~p"/users/register"} class="text-gray-400 hover:underline">
            Registre-se
          </.link>
        </p>
      </div>
    </div>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    form = to_form(%{"token" => token}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: nil]}
  end

  # Do not log in the user after confirmation to avoid a
  # leaked token giving the user access to the account.
  def handle_event("confirm_account", %{"user" => %{"token" => token}}, socket) do
    case Identity.confirm_user(token) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Usuário confirmado com sucesso!")
         |> redirect(to: ~p"/")}

      :error ->
        # If there is a current user and the account was already confirmed,
        # then odds are that the confirmation link was already visited, either
        # by some automation or by the user themselves, so we redirect without
        # a warning message.
        case socket.assigns do
          %{current_user: %{confirmed_at: confirmed_at}} when not is_nil(confirmed_at) ->
            {:noreply, redirect(socket, to: ~p"/")}

          %{} ->
            {:noreply,
             socket
             |> put_flash(:error, "O link de confirmação expirou, ou é inválido.")
             |> redirect(to: ~p"/")}
        end
    end
  end
end
