defmodule Zaqueu.Identity.UserNotifier do
  import Swoosh.Email

  alias Zaqueu.Mailer

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"Zaqueu", "zaqueu@noreply.com"})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    deliver(user.email, "Instruções de confirmação", """

    ==============================

    Olá #{user.email},

    Você pode confirmar seu cadastro clicando no link abaixo:

    #{url}

    Se não foi você que criou esta conta, por favor ignore.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    deliver(user.email, "Instruções de recuperação de senha", """

    ==============================

    Olá #{user.email},

    Você pode resetar sua senha clicano no link abaixo:

    #{url}

    Se não foi você que fez esta solicitação, por favor ignore.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    deliver(user.email, "Instruções de atualização de e-mail", """

    ==============================

    Olá #{user.email},

    Você pode alterar seu e-mail clicando no link abaixo:

    #{url}

    Se não foi você que fez esta solicitação, por favor ignore.
    ==============================
    """)
  end
end
