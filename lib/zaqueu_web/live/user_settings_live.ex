defmodule ZaqueuWeb.UserSettingsLive do
  use ZaqueuWeb, :live_logged_in

  alias Zaqueu.Identity

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mb-8">
      <.header>Change Email</.header>

      <.simple_form
        for={@email_form}
        id="email_form"
        phx-submit="update_email"
        phx-change="validate_email"
        color="bg-gray"
      >
        <.input field={@email_form[:email]} type="email" label="E-mail" required />
        <.input
          field={@email_form[:current_password]}
          name="current_password"
          id="current_password_for_email"
          type="password"
          label="Senha atual"
          value={@email_form_current_password}
          required
        />
        <:actions>
          <.button phx-disable-with="Alterando...">Alterar e-mail</.button>
        </:actions>
      </.simple_form>
    </div>

    <div>
      <.header>Alterar a senha</.header>

      <.simple_form
        for={@password_form}
        id="password_form"
        action={~p"/users/log_in?_action=password_updated"}
        method="post"
        phx-change="validate_password"
        phx-submit="update_password"
        color="bg-gray"
        phx-trigger-action={@trigger_submit}
      >
        <.input field={@password_form[:email]} type="hidden" value={@current_email} />
        <.input
          field={@password_form[:password]}
          type="password"
          label="Nova senha"
          required
        />
        <.input
          field={@password_form[:password_confirmation]}
          type="password"
          label="Confirmação de senha"
        />
        <.input
          field={@password_form[:current_password]}
          name="current_password"
          type="password"
          label="Senha atual"
          id="current_password_for_password"
          value={@current_password}
          required
        />
        <:actions>
          <.button phx-disable-with="Changing...">Change Password</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Identity.update_user_email(socket.assigns.current_user, token) do
        :ok ->
          put_flash(socket, :info, "Email changed successfully.")

        :error ->
          put_flash(
            socket,
            :error,
            "Email change link is invalid or it has expired."
          )
      end

    {:ok, push_navigate(socket, to: ~p"/users/settings")}
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    email_changeset = Identity.change_user_email(user)
    password_changeset = Identity.change_user_password(user)

    socket =
      socket
      |> assign(:current_password, nil)
      |> assign(:email_form_current_password, nil)
      |> assign(:current_email, user.email)
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:trigger_submit, false)
      |> assign(:page_title, "Configurações da conta")

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, url, socket) do
    socket =
      socket
      |> assign(:current_path, url)

    {:noreply, socket}
  end

  @impl true
  def handle_event("validate_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    email_form =
      socket.assigns.current_user
      |> Identity.change_user_email(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply,
     assign(socket,
       email_form: email_form,
       email_form_current_password: password
     )}
  end

  @impl true
  def handle_event("update_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Identity.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Identity.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          &url(~p"/users/settings/confirm_email/#{&1}")
        )

        info =
          "A link to confirm your email change has been sent to the new address."

        {:noreply,
         socket
         |> put_flash(:info, info)
         |> assign(email_form_current_password: nil)}

      {:error, changeset} ->
        {:noreply,
         assign(
           socket,
           :email_form,
           to_form(Map.put(changeset, :action, :insert))
         )}
    end
  end

  @impl true
  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    password_form =
      socket.assigns.current_user
      |> Identity.change_user_password(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply,
     assign(socket, password_form: password_form, current_password: password)}
  end

  @impl true
  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Identity.update_user_password(user, password, user_params) do
      {:ok, user} ->
        password_form =
          user
          |> Identity.change_user_password(user_params)
          |> to_form()

        {:noreply,
         assign(socket, trigger_submit: true, password_form: password_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end
end
