defmodule Stick.Units.Department do
  use Ecto.Schema
  import Ecto.Changeset
  import Stick.Units.Util

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
    |> get_assoc(:unit, attrs)
    |> assoc_constraint(:unit)
    |> validate_required([:title, :extension])
    |> unique_constraint(:title)
  end
end
