defmodule Stick.Repo.Migrations.UserAddUnit do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :unit_id, references(:units, on_delete: :nothing)
    end
  end
end
