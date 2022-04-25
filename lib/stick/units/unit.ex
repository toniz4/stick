defmodule Stick.Units.Unit do
  use Ecto.Schema
  import Ecto.Changeset

  alias Stick.Units.Department

  @fiels [:title, :address, :phone]
  schema "units" do
    field :address, :string
    field :phone, :string
    field :title, :string
    has_many :departments, Department

    timestamps()
  end

  @doc false
  def changeset(unit, attrs) do
    unit
    |> cast(attrs, @fiels)
    |> validate_required(@fiels)
    |> validate_title()
  end

  defp validate_title(changeset) do
    changeset
    |> validate_length(:title, min: 3, max: 200)
  end
end
