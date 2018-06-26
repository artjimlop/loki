defmodule LokiWeb.UserController do
  use LokiWeb, :controller

  alias Loki.Accounts
  alias Loki.Accounts.User

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json-api", data: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_user_path(conn, :show, user))
      |> render("show.json-api", data: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json-api", data: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "show.json-api", data: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, user} <- Accounts.update_user(user, user_params) do
      conn
      |> render("show.json-api", data: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> send_resp(:no_content, "")
  end
end
