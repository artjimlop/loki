defmodule Loki.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :title, :string
      add :content, :string

      timestamps()
    end

  end
end
