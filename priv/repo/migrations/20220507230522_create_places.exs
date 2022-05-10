defmodule Stick.Repo.Migrations.CreatePlaces do
  use Ecto.Migration

  def change do
    create table(:places) do
      add :title, :string
      add :unit_id, references(:units, on_delete: :nothing)

      timestamps()
    end

    create index(:places, [:unit_id])
  end
end
