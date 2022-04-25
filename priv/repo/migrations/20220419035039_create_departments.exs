defmodule Stick.Repo.Migrations.CreateDepartments do
  use Ecto.Migration

  def change do
    create table(:departments) do
      add :title, :string
      add :extension, :string
      add :unit_id, references(:units, on_delete: :delete_all)

      timestamps()
    end

    create index(:departments, [:unit_id])
    create unique_index(:departments, [:title])
  end
end
