defmodule Stick.Repo.Migrations.CreateUnits do
  use Ecto.Migration

  def change do
    create table(:units) do
      add :title, :string
      add :address, :string
      add :phone, :string

      timestamps()
    end

    create unique_index(:units, [:title])
  end
end
