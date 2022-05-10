defmodule Stick.UnitsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Stick.Units` context.
  """

  @doc """
  Generate a unit.
  """
  def unit_fixture(attrs \\ %{}) do
    {:ok, unit} =
      attrs
      |> Enum.into(%{
        address: "some address",
        phone: "some phone",
        title: "some title"
      })
      |> Stick.Units.create_unit()

    unit
  end

  @doc """
  Generate a department.
  """
  def department_fixture(attrs \\ %{}) do
    {:ok, department} =
      attrs
      |> Enum.into(%{
        extension: "some extension",
        title: "some title"
      })
      |> Stick.Units.create_department()

    department
  end

  @doc """
  Generate a place.
  """
  def place_fixture(attrs \\ %{}) do
    {:ok, place} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> Stick.Units.create_place()

    place
  end
end
