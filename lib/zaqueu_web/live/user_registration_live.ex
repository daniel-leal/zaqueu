defmodule ZaqueuWeb.UserRegistrationLive do
  use ZaqueuWeb, :live_view

  alias Zaqueu.Identity
  alias Zaqueu.Identity.User

  @default_avatar [
    "https://images.unsplash.com/photo-1535378620166-273708d44e4c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2157&q=80"
  ]

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
            class="border rounded text-gray-50  focus:ring-3 focus:ring-primary-300 bg-gray-700 border-gray-600 focus:ring-primary-600 ring-offset-gray-800"
            placeholder="••••••••••"
            required
          />

          <.input field={@form[:avatar]} type="hidden" />

          <label class="block text-sm font-semibold leading-6 text-zinc-800 text-gray-300">
            Avatar
          </label>
          <.live_file_input
            upload={@uploads.avatar}
            class="border rounded text-gray-50 focus:ring-3 focus:ring-primary-300 bg-gray-700 border-gray-600 focus:ring-primary-600 ring-offset-gray-800"
          />

          <section phx-drop-target={@uploads.avatar.ref}>
            <%= for entry <- @uploads.avatar.entries do %>
              <article class="upload-entry">
                <figure>
                  <.live_img_preview entry={entry} width="120" />
                  <button
                    type="button"
                    phx-click="cancel-upload"
                    phx-value-ref={entry.ref}
                    aria-label="cancel"
                    class="bg-red-500 right hover:bg-red-700 text-white font-bold py-1 px-2 rounded mt-3"
                  >
                    &times;
                  </button>
                </figure>

                <%= for err <- upload_errors(@uploads.avatar, entry) do %>
                  <p class="alert alert-danger"><%= error_to_string(err) %></p>
                <% end %>
              </article>
            <% end %>

            <%= for err <- upload_errors(@uploads.avatar) do %>
              <p class="alert alert-danger"><%= error_to_string(err) %></p>
            <% end %>
          </section>

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
      |> allow_upload(:avatar, accept: ~w(.jpg .jpeg .png), max_entries: 1)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :avatar, fn %{path: path}, _entry ->
        dest =
          Path.join([
            :code.priv_dir(:zaqueu),
            "static",
            "uploads",
            Path.basename(path)
          ])

        File.cp!(path, dest)

        {:ok, "/uploads/#{Path.basename(dest)}"}
      end)

    uploaded_files = if Enum.empty?(uploaded_files), do: @default_avatar

    user_params = Map.put(user_params, "avatar", hd(uploaded_files))

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

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :avatar, ref)}
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"

  defp error_to_string(:not_accepted),
    do: "You have selected an unacceptable file type"

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
