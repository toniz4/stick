defmodule Stick.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :title, :string, null: false
      add :is_admin, :boolean, default: false, null: false
      add :can_open_tickets, :boolean, default: false, null: false
      add :can_close_tickets, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:profiles, [:title])

    alter table(:users) do
      add :profile_id, references(:profiles, on_delete: :nothing)
    end

    create index(:users, [:profile_id])
  end
end
