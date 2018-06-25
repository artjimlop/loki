defmodule Loki.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Loki.Storage.Item

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field(:password, :string)
    field(:username, :string)
    has_many(:items, Item)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
  end
end
