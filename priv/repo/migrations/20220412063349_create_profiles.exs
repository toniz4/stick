defmodule Stick.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :title, :string, null: false
      add :is_admin, :boolean, default: false, null: false
      add :can_open_tickets, :boolean, default: false, null: false
      add :can_close_tickets, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:roles, [:title])

    alter table(:users) do
      add :role_id, references(:roles, on_delete: :nothing)
    end

    create index(:users, [:role_id])
  end
end
