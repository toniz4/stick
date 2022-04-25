defmodule Stick.Units.Department do
  use Ecto.Schema
  import Ecto.Changeset

  alias Stick.Units.Unit

  schema "departments" do
    field :extension, :string
    field :title, :string
    belongs_to :unit, Unit, on_replace: :nilify

    timestamps()
  end

  @doc false
  def changeset(department, attrs) do
    department
    |> cast(attrs, [:title, :extension])
    |> put_assoc(:unit, get_unit_assoc(department, attrs))
    |> assoc_constraint(:unit)
    |> validate_required([:title, :extension])
  end

  defp get_unit_assoc(_department, %{:unit => unit} = _attrs), do: unit

  defp get_unit_assoc(_department, %{"unit" => unit} = _attrs), do: unit

  defp get_unit_assoc(%__MODULE__{unit: unit = %Unit{}} = _department, _attrs), do: unit

  defp get_unit_assoc(_department, _attrs), do: %{}
end
