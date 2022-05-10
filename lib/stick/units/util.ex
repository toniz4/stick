defmodule Stick.Units.Util do
  import Ecto.Changeset

  def get_assoc(changeset, :unit, attrs) do
    unit =
      changeset
      |> get_unit_assoc(attrs)

    changeset
    |> put_assoc(:unit, unit)
  end

  def get_assoc(changeset, :role, attrs) do
    role =
      changeset
      |> get_role_assoc(attrs)

    changeset
    |> put_assoc(:role, role)
  end

  def get_assoc(changeset, :department, attrs) do
    department =
      changeset
      |> get_department_assoc(attrs)

    changeset
    |> put_assoc(:department, department)
  end

  defp get_unit_assoc(changeset, attrs) do
    case attrs do
      %{:unit => unit} ->
        unit

      %{"unit" => unit} ->
        unit

      _ ->
        case changeset.data do
          %{unit_id: nil} ->
            %{}

          %{unit: unit} ->
            unit
        end
    end
  end

  defp get_role_assoc(changeset, attrs) do
    case attrs do
      %{:role => role} ->
        role

      %{"role" => role} ->
        role

      _ ->
        case changeset.data do
          %{role_id: nil} ->
            %{}

          %{role: role} ->
            role
        end
    end
  end

  defp get_department_assoc(changeset, attrs) do
    case attrs do
      %{:department => department} ->
        department

      %{"department" => department} ->
        department

      _ ->
        case changeset.data do
          %{department_id: nil} ->
            %{}

          %{department: department} ->
            department
        end
    end
  end
end
