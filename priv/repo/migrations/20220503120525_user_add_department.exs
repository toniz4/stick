defmodule Stick.Repo.Migrations.UserAddDepartment do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :department_id, references(:departments, on_delete: :nothing)
    end
  end
end
