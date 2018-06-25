defmodule Loki.Storage.Item do
  use Ecto.Schema
  import Ecto.Changeset


  schema "items" do
    field :content, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:title, :content])
    |> validate_required([:title, :content])
  end
end
