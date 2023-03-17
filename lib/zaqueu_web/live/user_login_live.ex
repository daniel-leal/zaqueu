defmodule ZaqueuWeb.UserLoginLive do
  use ZaqueuWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="w-full bg-white rounded-lg shadow dark:border md:mt-0 sm:max-w-md xl:p-0 dark:bg-slate-800 dark:border-gray-700">
      <div class="p-6 space-y-4 md:space-y-6 sm:p-8">
        <h1 class="text-xl font-bold leading-tight tracking-tight text-gray-900 md:text-2xl dark:text-white">
          Acesse sua Conta
        </h1>
        <p class="mt-2 text-sm leading-6 text-zinc-200">
          Ainda não tem uma conta?
          <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline">
            Registre-se
          </.link>
        </p>
        <.simple_form
          for={@form}
          id="login_form"
          action={~p"/users/log_in"}
          color="bg-slate-800"
          phx-update="ignore"
        >
          <.input
            field={@form[:email]}
            type="email"
            label="Email"
            label_color="text-gray-300"
            class="border border-gray-300 rounded text-gray-50 bg-gray-50 focus:ring-3 focus:ring-primary-300 dark:bg-gray-700 dark:border-gray-600 dark:focus:ring-primary-600 dark:ring-offset-gray-800"
            placeholder="email@example.com"
            required
          />

          <.input
            field={@form[:password]}
            type="password"
            label="Senha"
            label_color="text-gray-300"
            class="border border-gray-300 rounded text-gray-50 bg-gray-50 focus:ring-3 focus:ring-primary-300 dark:bg-gray-700 dark:border-gray-600 dark:focus:ring-primary-600 dark:ring-offset-gray-800"
            placeholder="••••••••••"
            required
          />

          <:actions>
            <.input field={@form[:remember_me]} type="checkbox" label="Mantenha-me logado" />
            <.link href={~p"/users/reset_password"} class="text-sm font-semibold text-gray-300">
              Esqueceu sua senha?
            </.link>
          </:actions>
          <:actions>
            <.button phx-disable-with="Acessando..." class="w-full">
              Login <span aria-hidden="true">→</span>
            </.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
