defmodule LokiWeb.AuthController do
  use LokiWeb, :controller
  plug(Ueberauth)

  alias Loki.Accounts.AuthUser
  alias Loki.Accounts.Guardian
  alias Loki.Accounts
  plug(:scrub_params, "user" when action in [:sign_in_user])

  def request(_params) do
  end

  def delete(conn, _params) do
    # Sign out the user
    jwt = Guardian.Plug.current_token(conn)
    claims = Guardian.Plug.current_claims(conn)
    Guardian.revoke(jwt, claims)
    json(conn, %{logout: true})
  end

  def logout(conn, _params) do
    # Sign out the user
    jwt = Guardian.Plug.current_token(conn)
    claims = Guardian.Plug.current_claims(conn)
    Guardian.revoke(jwt, claims)
    conn
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    # This callback is called when the user denies the app to get the data from the oauth provider
    conn
    |> put_status(401)
    |> render(LokiWeb.ErrorView, "401.json-api")
  end

  def identity_callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    case AuthUser.basic_info(auth) do
      {:ok, user} ->
        conn
        |> logout(user)
        |> sign_in_user(%{"user" => user})

      {:error} ->
        conn
        |> put_status(401)
        |> render(LokiWeb.ErrorView, "401.json-api")
    end
  end

  def sign_in_user(conn, %{"user" => user}) do
    previous_user = user

    if {:ok, user} =
         Accounts.authenticate_user(previous_user["username"], previous_user["password"]) do
      new_conn = Guardian.Plug.sign_in(conn, user)
      jwt = Guardian.Plug.current_token(new_conn)
      claims = Guardian.Plug.current_claims(new_conn)
      exp = Map.get(claims, "exp")

      new_conn
      |> put_resp_header("authorization", "Bearer #{jwt}")
      |> put_resp_header("x-expires", Kernel.inspect(exp))
      |> json(%{access_token: jwt, user: user})
    else
      # Unsuccessful login
      conn
      |> logout(user)
      |> put_status(401)
      |> render(LokiWeb.ErrorView, "401.json-api")
    end
  end

  def sign_up_user(conn, %{"user" => user}) do
    case Accounts.create_user(user) do
      {:ok, user} ->
        new_conn = Guardian.Plug.sign_in(conn, user)
        jwt = Guardian.Plug.current_token(new_conn)
        claims = Guardian.Plug.current_claims(new_conn)
        exp = Map.get(claims, "exp")

        new_conn
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> put_resp_header("x-expires", Kernel.inspect(exp))
        |> json(%{access_token: jwt, user: user})

      {:error, _changeset} ->
        conn
        |> put_status(422)
        |> render(LokiWeb.ErrorView, "422.json-api")
    end
  end

  def create_user(conn, %{"user" => user}) do
    case Accounts.create_user(user) do
      {:ok, user} ->
        new_conn = Guardian.Plug.sign_in(conn, user)
        jwt = Guardian.Plug.current_token(new_conn)
        claims = Guardian.Plug.current_claims(new_conn)
        exp = Map.get(claims, "exp")

        new_conn
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> put_resp_header("x-expires", Kernel.inspect(exp))
        |> json(%{access_token: jwt, user: user})

      {:error, _changeset} ->
        conn
        |> put_status(422)
        |> render(LokiWeb.ErrorView, "422.json-api")
    end
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> render(LokiWeb.ErrorView, "401.json-api")
  end

  def unauthorized(conn, _params) do
    conn
    |> put_status(403)
    |> render(LokiWeb.ErrorView, "403.json-api")
  end

  def already_authenticated(conn, _params) do
    conn
    |> put_status(200)
    |> render(LokiWeb.ErrorView, "200.json-api")
  end

  def no_resource(conn, _params) do
    conn
    |> put_status(404)
    |> render(LokiWeb.ErrorView, "404.json-api")
  end
end
