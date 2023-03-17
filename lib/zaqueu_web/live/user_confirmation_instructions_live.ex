defmodule ZaqueuWeb.UserConfirmationInstructionsLive do
  use ZaqueuWeb, :live_view

  alias Zaqueu.Identity

  def render(assigns) do
    ~H"""
    <div class="w-full bg-white rounded-lg shadow dark:border md:mt-0 sm:max-w-md xl:p-0 dark:bg-slate-800 dark:border-gray-700">
      <div class="p-6 space-y-4 md:space-y-6 sm:p-8">
        <h1 class="text-center text-xl font-bold leading-tight tracking-tight text-gray-900 md:text-2xl dark:text-white">
          Reenviar instruções de confirmação
        </h1>
        <.simple_form
          for={@form}
          id="resend_confirmation_form"
          phx-submit="send_instructions"
          color="bg-slate-800"
        >
          <.input
            field={@form[:email]}
            type="email"
            label="Email"
            required
            label_color="text-gray-300"
            class="border border-gray-300 rounded text-gray-50 bg-gray-50 focus:ring-3 focus:ring-primary-300 dark:bg-gray-700 dark:border-gray-600 dark:focus:ring-primary-600 dark:ring-offset-gray-800"
          />
          <:actions>
            <.button phx-disable-with="Sending..." class="w-full">
              Reenviar instruções de confirmação
            </.button>
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

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("send_instructions", %{"user" => %{"email" => email}}, socket) do
    if user = Identity.get_user_by_email(email) do
      Identity.deliver_user_confirmation_instructions(
        user,
        &url(~p"/users/confirm/#{&1}")
      )
    end

    info =
      "Se o seu e-mail estiver cadastrado, você receberá um e-mail com as instruções de recuperação de senha"

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
