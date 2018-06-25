defmodule Loki.Storage.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias Loki.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "items" do
    field(:content, :string)
    field(:title, :string)
    belongs_to(:user, User)
    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:title, :content])
    |> validate_required([:title, :content])
  end
end
