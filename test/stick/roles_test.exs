defmodule Stick.RolesTest do
  use Stick.DataCase

  alias Stick.Roles

  describe "roles" do
    alias Stick.Roles.Role

    import Stick.RolesFixtures

    @invalid_attrs %{can_close_tickets: nil, can_open_ticket: nil, is_admin: nil}

    test "list_roles/0 returns all roles" do
      role = role_fixture()
      assert Roles.list_roles() == [role]
    end

    test "get_role!/1 returns the role with given id" do
      role = role_fixture()
      assert Roles.get_role!(role.id) == role
    end

    test "create_role/1 with valid data creates a role" do
      valid_attrs = %{can_close_tickets: true, can_open_ticket: true, is_admin: true}

      assert {:ok, %Role{} = role} = Roles.create_role(valid_attrs)
      assert role.can_close_tickets == true
      assert role.can_open_ticket == true
      assert role.is_admin == true
    end

    test "create_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Roles.create_role(@invalid_attrs)
    end

    test "update_role/2 with valid data updates the role" do
      role = role_fixture()
      update_attrs = %{can_close_tickets: false, can_open_ticket: false, is_admin: false}

      assert {:ok, %Role{} = role} = Roles.update_role(role, update_attrs)
      assert role.can_close_tickets == false
      assert role.can_open_ticket == false
      assert role.is_admin == false
    end

    test "update_role/2 with invalid data returns error changeset" do
      role = role_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Roles.update_role(role, @invalid_attrs)

      assert role == Roles.get_role!(role.id)
    end

    test "delete_role/1 deletes the role" do
      role = role_fixture()
      assert {:ok, %Role{}} = Roles.delete_role(role)
      assert_raise Ecto.NoResultsError, fn -> Roles.get_role!(role.id) end
    end

    test "change_role/1 returns a role changeset" do
      role = role_fixture()
      assert %Ecto.Changeset{} = Roles.change_role(role)
    end
  end
end
