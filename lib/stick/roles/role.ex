defmodule Stick.Roles.Role do
  use Ecto.Schema
  import Ecto.Changeset
  alias Stick.Accounts.User

  @fields [:is_admin, :can_open_tickets, :can_close_tickets, :title]

  schema "roles" do
    field :title, :string
    field :can_close_tickets, :boolean, default: false
    field :can_open_tickets, :boolean, default: false
    field :is_admin, :boolean, default: false
    has_many :users, User

    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, @fields)
    |> validate_length(:title, min: 3, max: 160)
    |> validate_required(@fields)
  end
end
