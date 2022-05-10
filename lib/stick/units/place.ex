defmodule Stick.Units.Place do
  use Ecto.Schema
  import Ecto.Changeset
  import Stick.Units.Util

  alias Stick.Units.Unit

  schema "places" do
    field :title, :string
    belongs_to :unit, Unit, on_replace: :nilify

    timestamps()
  end

  @doc false
  def changeset(place, attrs) do
    place
    |> cast(attrs, [:title])
    |> get_assoc(:unit, attrs)
    |> assoc_constraint(:unit)
    |> validate_required([:title])
    |> unique_constraint(:title)
  end
end
