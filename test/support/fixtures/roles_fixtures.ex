defmodule Stick.RolesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Stick.Roles` context.
  """

  @doc """
  Generate a role.
  """
  def role_fixture(attrs \\ %{}) do
    {:ok, role} =
      attrs
      |> Enum.into(%{
        can_close_tickets: true,
        can_open_ticket: true,
        is_admin: true
      })
      |> Stick.Roles.create_role()

    role
  end
end
