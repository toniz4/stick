defmodule Stick.Repo.Migrations.UserAddEnabled do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :enabled, :boolean, default: true, null: false
    end
  end
end
