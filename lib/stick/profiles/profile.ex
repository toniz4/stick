defmodule Stick.Profiles.Profile do
  use Ecto.Schema
  import Ecto.Changeset
  alias Stick.Accounts.User

  @fields [:is_admin, :can_open_tickets, :can_close_tickets, :title]

  schema "profiles" do
    field :title, :string
    field :can_close_tickets, :boolean, default: false
    field :can_open_tickets, :boolean, default: false
    field :is_admin, :boolean, default: false
    has_many :users, User

    timestamps()
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, @fields)
    |> cast_assoc(:users)
    |> validate_required(@fields)
  end
end
