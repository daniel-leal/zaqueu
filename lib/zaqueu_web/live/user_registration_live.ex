defmodule ZaqueuWeb.UserRegistrationLive do
  use ZaqueuWeb, :live_view

  alias Zaqueu.Identity
  alias Zaqueu.Identity.User

  def render(assigns) do
    ~H"""
    <div class="w-full  rounded-lg shadow border md:mt-0 sm:max-w-md xl:p-0 bg-slate-800 border-gray-700">
      <div class="p-6 space-y-4 md:space-y-6 sm:p-8">
        <h1 class="text-center text-xl font-bold leading-tight tracking-tight md:text-2xl text-white">
          Registre-se
        </h1>
        <p class="text-center mt-2 text-sm leading-6 text-zinc-200">
          Já tem uma conta? Faça
          <.link
            navigate={~p"/users/log_in"}
            class="font-semibold text-brand hover:underline"
          >
            Login
          </.link>
        </p>
        <.simple_form
          for={@form}
          id="registration_form"
          phx-submit="save"
          phx-change="validate"
          phx-trigger-action={@trigger_submit}
          color="bg-slate-800"
          action={~p"/users/log_in?_action=registered"}
          method="post"
        >
          <.error :if={@check_errors}>
            Algo deu errado! Verifique os problemas abaixo:
          </.error>

          <.input
            field={@form[:email]}
            type="email"
            label="Email"
            label_color="text-gray-300"
            class="border  rounded text-gray-50  focus:ring-3 focus:ring-primary-300 bg-gray-700 border-gray-600 focus:ring-primary-600 ring-offset-gray-800"
            placeholder="email@example.com"
            required
          />

          <.input
            field={@form[:password]}
            type="password"
            label="Senha"
            label_color="text-gray-300"
            class="border  rounded text-gray-50  focus:ring-3 focus:ring-primary-300 bg-gray-700 border-gray-600 focus:ring-primary-600 ring-offset-gray-800"
            placeholder="••••••••••"
            required
          />

          <:actions>
            <.button phx-disable-with="Criando conta..." class="w-full">
              Crie sua conta
            </.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Identity.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Identity.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Identity.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Identity.change_user_registration(user)

        {:noreply,
         socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Identity.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
