defmodule ZaqueuWeb.Router do
  use ZaqueuWeb, :router

  import ZaqueuWeb.UserAuth

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {ZaqueuWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  if Application.compile_env(:zaqueu, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: ZaqueuWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end

  scope "/", ZaqueuWeb do
    pipe_through([:browser, :redirect_if_user_is_authenticated])

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{ZaqueuWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live("/users/register", UserRegistrationLive, :new)
      live("/users/log_in", UserLoginLive, :new)
      live("/users/reset_password", UserForgotPasswordLive, :new)
      live("/users/reset_password/:token", UserResetPasswordLive, :edit)
    end

    post("/users/log_in", UserSessionController, :create)
  end

  scope "/", ZaqueuWeb do
    pipe_through([:browser, :require_authenticated_user])

    live_session :require_authenticated_user,
      on_mount: [{ZaqueuWeb.UserAuth, :ensure_authenticated}] do
      live("/", BankAccountLive.Index, :index)
      live("/users/settings", UserSettingsLive, :edit)

      live(
        "/users/settings/confirm_email/:token",
        UserSettingsLive,
        :confirm_email
      )

      live("/bank_accounts", BankAccountLive.Index, :index)
      live("/bank_accounts/new", BankAccountLive.Index, :new)
      live("/bank_accounts/:id/edit", BankAccountLive.Index, :edit)
      live("/bank_accounts/:id", BankAccountLive.Show, :show)
      live("/bank_accounts/:id/show/edit", BankAccountLive.Show, :edit)

      live("/credit_cards", CreditCardLive.Index, :index)
      live("/credit_cards/new", CreditCardLive.Index, :new)
      live("/credit_cards/:id/edit", CreditCardLive.Index, :edit)
      live("/credit_cards/:id", CreditCardLive.Show, :show)
      live("/credit_cards/:id/show/edit", CreditCardLive.Show, :edit)

      live(
        "/credit_cards/:id/invoices/:invoice_id/edit",
        CreditCardLive.Show,
        :edit
      )

      live(
        "/credit_cards/:id/invoices/:invoice_id/transactions",
        TransactionLive.Index,
        :index
      )

      live(
        "/credit_cards/:id/invoices/:invoice_id/transactions/new",
        TransactionLive.Index,
        :new
      )

      live(
        "/credit_cards/:id/invoices/:invoice_id/transactions/:transaction_id",
        TransactionLive.Show,
        :show
      )

      live(
        "/credit_cards/:id/invoices/:invoice_id/transactions/:transaction_id/edit",
        TransactionLive.Index,
        :edit
      )

      live(
        "/credit_cards/:id/invoices/:invoice_id/transactions/:transaction_id/show/edit",
        TransactionLive.Show,
        :edit
      )
    end
  end

  scope "/", ZaqueuWeb do
    pipe_through([:browser])

    delete("/users/log_out", UserSessionController, :delete)

    live_session :current_user,
      on_mount: [{ZaqueuWeb.UserAuth, :mount_current_user}] do
      live("/users/confirm/:token", UserConfirmationLive, :edit)
      live("/users/confirm", UserConfirmationInstructionsLive, :new)
    end
  end
end
