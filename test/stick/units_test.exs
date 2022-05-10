defmodule Stick.UnitsTest do
  use Stick.DataCase

  alias Stick.Units

  describe "units" do
    alias Stick.Units.Unit

    import Stick.UnitsFixtures

    @invalid_attrs %{address: nil, phone: nil, title: nil}

    test "list_units/0 returns all units" do
      unit = unit_fixture()
      assert Units.list_units() == [unit]
    end

    test "get_unit!/1 returns the unit with given id" do
      unit = unit_fixture()
      assert Units.get_unit!(unit.id) == unit
    end

    test "create_unit/1 with valid data creates a unit" do
      valid_attrs = %{address: "some address", phone: "some phone", title: "some title"}

      assert {:ok, %Unit{} = unit} = Units.create_unit(valid_attrs)
      assert unit.address == "some address"
      assert unit.phone == "some phone"
      assert unit.title == "some title"
    end

    test "create_unit/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Units.create_unit(@invalid_attrs)
    end

    test "update_unit/2 with valid data updates the unit" do
      unit = unit_fixture()

      update_attrs = %{
        address: "some updated address",
        phone: "some updated phone",
        title: "some updated title"
      }

      assert {:ok, %Unit{} = unit} = Units.update_unit(unit, update_attrs)
      assert unit.address == "some updated address"
      assert unit.phone == "some updated phone"
      assert unit.title == "some updated title"
    end

    test "update_unit/2 with invalid data returns error changeset" do
      unit = unit_fixture()
      assert {:error, %Ecto.Changeset{}} = Units.update_unit(unit, @invalid_attrs)
      assert unit == Units.get_unit!(unit.id)
    end

    test "delete_unit/1 deletes the unit" do
      unit = unit_fixture()
      assert {:ok, %Unit{}} = Units.delete_unit(unit)
      assert_raise Ecto.NoResultsError, fn -> Units.get_unit!(unit.id) end
    end

    test "change_unit/1 returns a unit changeset" do
      unit = unit_fixture()
      assert %Ecto.Changeset{} = Units.change_unit(unit)
    end
  end

  describe "departments" do
    alias Stick.Units.Department

    import Stick.UnitsFixtures

    @invalid_attrs %{extension: nil, title: nil}

    test "list_departments/0 returns all departments" do
      department = department_fixture()
      assert Units.list_departments() == [department]
    end

    test "get_department!/1 returns the department with given id" do
      department = department_fixture()
      assert Units.get_department!(department.id) == department
    end

    test "create_department/1 with valid data creates a department" do
      valid_attrs = %{extension: "some extension", title: "some title"}

      assert {:ok, %Department{} = department} = Units.create_department(valid_attrs)
      assert department.extension == "some extension"
      assert department.title == "some title"
    end

    test "create_department/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Units.create_department(@invalid_attrs)
    end

    test "update_department/2 with valid data updates the department" do
      department = department_fixture()
      update_attrs = %{extension: "some updated extension", title: "some updated title"}

      assert {:ok, %Department{} = department} =
               Units.update_department(department, update_attrs)

      assert department.extension == "some updated extension"
      assert department.title == "some updated title"
    end

    test "update_department/2 with invalid data returns error changeset" do
      department = department_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Units.update_department(department, @invalid_attrs)

      assert department == Units.get_department!(department.id)
    end

    test "delete_department/1 deletes the department" do
      department = department_fixture()
      assert {:ok, %Department{}} = Units.delete_department(department)
      assert_raise Ecto.NoResultsError, fn -> Units.get_department!(department.id) end
    end

    test "change_department/1 returns a department changeset" do
      department = department_fixture()
      assert %Ecto.Changeset{} = Units.change_department(department)
    end
  end

  describe "places" do
    alias Stick.Units.Place

    import Stick.UnitsFixtures

    @invalid_attrs %{title: nil}

    test "list_places/0 returns all places" do
      place = place_fixture()
      assert Units.list_places() == [place]
    end

    test "get_place!/1 returns the place with given id" do
      place = place_fixture()
      assert Units.get_place!(place.id) == place
    end

    test "create_place/1 with valid data creates a place" do
      valid_attrs = %{title: "some title"}

      assert {:ok, %Place{} = place} = Units.create_place(valid_attrs)
      assert place.title == "some title"
    end

    test "create_place/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Units.create_place(@invalid_attrs)
    end

    test "update_place/2 with valid data updates the place" do
      place = place_fixture()
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Place{} = place} = Units.update_place(place, update_attrs)
      assert place.title == "some updated title"
    end

    test "update_place/2 with invalid data returns error changeset" do
      place = place_fixture()
      assert {:error, %Ecto.Changeset{}} = Units.update_place(place, @invalid_attrs)
      assert place == Units.get_place!(place.id)
    end

    test "delete_place/1 deletes the place" do
      place = place_fixture()
      assert {:ok, %Place{}} = Units.delete_place(place)
      assert_raise Ecto.NoResultsError, fn -> Units.get_place!(place.id) end
    end

    test "change_place/1 returns a place changeset" do
      place = place_fixture()
      assert %Ecto.Changeset{} = Units.change_place(place)
    end
  end
end
