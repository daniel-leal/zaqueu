defmodule ZaqueuWeb.UserSessionControllerTest do
  use ZaqueuWeb.ConnCase, async: true

  import Zaqueu.IdentityFixtures

  setup do
    %{user: user_fixture()}
  end

  describe "POST /users/log_in" do
    test "logs the user in with remember me", %{conn: conn, user: user} do
      conn =
        post(conn, ~p"/users/log_in", %{
          "user" => %{
            "email" => user.email,
            "password" => valid_user_password(),
            "remember_me" => "true"
          }
        })

      assert conn.resp_cookies["_zaqueu_web_user_remember_me"]
      assert redirected_to(conn) == ~p"/"
    end

    test "logs the user in with return to", %{conn: conn, user: user} do
      conn =
        conn
        |> init_test_session(user_return_to: "/foo/bar")
        |> post(~p"/users/log_in", %{
          "user" => %{
            "email" => user.email,
            "password" => valid_user_password()
          }
        })

      assert redirected_to(conn) == "/foo/bar"

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "Bem-vindo de volta!"
    end

    test "login following registration", %{conn: conn, user: user} do
      conn =
        conn
        |> post(~p"/users/log_in", %{
          "_action" => "registered",
          "user" => %{
            "email" => user.email,
            "password" => valid_user_password()
          }
        })

      assert redirected_to(conn) == ~p"/"

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "Registro efetuado com sucesso!"
    end

    test "login following password update", %{conn: conn, user: user} do
      conn =
        conn
        |> post(~p"/users/log_in", %{
          "_action" => "password_updated",
          "user" => %{
            "email" => user.email,
            "password" => valid_user_password()
          }
        })

      assert redirected_to(conn) == ~p"/users/settings"

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "Senha atualizada com sucesso!"
    end

    test "redirects to login page with invalid credentials", %{conn: conn} do
      conn =
        post(conn, ~p"/users/log_in", %{
          "user" => %{
            "email" => "invalid@email.com",
            "password" => "invalid_password"
          }
        })

      assert Phoenix.Flash.get(conn.assigns.flash, :error) ==
               "E-mail ou senha inválidos"

      assert redirected_to(conn) == ~p"/users/log_in"
    end
  end

  describe "DELETE /users/log_out" do
    test "logs the user out", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> delete(~p"/users/log_out")
      assert redirected_to(conn) == ~p"/"
      refute get_session(conn, :user_token)

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "Logout realizado com sucesso!."
    end

    test "succeeds even if the user is not logged in", %{conn: conn} do
      conn = delete(conn, ~p"/users/log_out")
      assert redirected_to(conn) == ~p"/"
      refute get_session(conn, :user_token)

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "Logout realizado com sucesso!."
    end
  end
end
