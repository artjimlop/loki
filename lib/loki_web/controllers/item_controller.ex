defmodule LokiWeb.ItemController do
  use LokiWeb, :controller

  alias Loki.Storage
  alias Loki.Storage.Item

  action_fallback(EathubWeb.FallbackController)

  def index(conn, _params) do
    items = Storage.list_items()
    render(conn, "index.json-api", data: items)
  end

  def new(conn, _params) do
    changeset = Storage.change_item(%Item{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"item" => item_params}) do
    changeset = Item.changeset(%Item{}, item_params)

    item_with_user =
      Ecto.Changeset.put_assoc(changeset, :user, conn.private.guardian_default_resource)

    with {:ok, item} <- Storage.create_item(item_with_user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_item_path(conn, :show, item))
      |> render("show.json-api", data: item)
    end
  end

  def show(conn, %{"id" => id}) do
    item = Storage.get_item!(id)
    render(conn, "show.json-api", data: item)
  end

  def edit(conn, %{"id" => id}) do
    item = Storage.get_item!(id)

    with {:ok, item} <- Storage.change_item(item) do
      conn
      |> render("show.json-api", data: item)
    end
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = Storage.get_item!(id)

    case Storage.update_item(item, item_params) do
      {:ok, item} ->
        conn
        |> render("show.json-api", data: item)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", item: item, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = Storage.get_item!(id)
    {:ok, _item} = Storage.delete_item(item)

    conn
    |> send_resp(:no_content, "")
  end
end
