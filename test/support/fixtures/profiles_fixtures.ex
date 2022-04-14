defmodule Stick.ProfilesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Stick.Profiles` context.
  """

  @doc """
  Generate a profile.
  """
  def profile_fixture(attrs \\ %{}) do
    {:ok, profile} =
      attrs
      |> Enum.into(%{
        can_close_tickets: true,
        can_open_ticket: true,
        is_admin: true
      })
      |> Stick.Profiles.create_profile()

    profile
  end
end
