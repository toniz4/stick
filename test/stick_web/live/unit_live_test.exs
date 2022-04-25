defmodule StickWeb.UnitLiveTest do
  use StickWeb.ConnCase

  import Phoenix.LiveViewTest
  import Stick.UnitsFixtures

  @create_attrs %{address: "some address", phone: "some phone", title: "some title"}
  @update_attrs %{
    address: "some updated address",
    phone: "some updated phone",
    title: "some updated title"
  }
  @invalid_attrs %{address: nil, phone: nil, title: nil}

  defp create_unit(_) do
    unit = unit_fixture()
    %{unit: unit}
  end

  describe "Index" do
    setup [:create_unit]

    test "lists all units", %{conn: conn, unit: unit} do
      {:ok, _index_live, html} = live(conn, Routes.unit_index_path(conn, :index))

      assert html =~ "Listing Units"
      assert html =~ unit.address
    end

    test "saves new unit", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.unit_index_path(conn, :index))

      assert index_live |> element("a", "New Unit") |> render_click() =~
               "New Unit"

      assert_patch(index_live, Routes.unit_index_path(conn, :new))

      assert index_live
             |> form("#unit-form", unit: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#unit-form", unit: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.unit_index_path(conn, :index))

      assert html =~ "Unit created successfully"
      assert html =~ "some address"
    end

    test "updates unit in listing", %{conn: conn, unit: unit} do
      {:ok, index_live, _html} = live(conn, Routes.unit_index_path(conn, :index))

      assert index_live |> element("#unit-#{unit.id} a", "Edit") |> render_click() =~
               "Edit Unit"

      assert_patch(index_live, Routes.unit_index_path(conn, :edit, unit))

      assert index_live
             |> form("#unit-form", unit: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#unit-form", unit: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.unit_index_path(conn, :index))

      assert html =~ "Unit updated successfully"
      assert html =~ "some updated address"
    end

    test "deletes unit in listing", %{conn: conn, unit: unit} do
      {:ok, index_live, _html} = live(conn, Routes.unit_index_path(conn, :index))

      assert index_live |> element("#unit-#{unit.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#unit-#{unit.id}")
    end
  end

  describe "Show" do
    setup [:create_unit]

    test "displays unit", %{conn: conn, unit: unit} do
      {:ok, _show_live, html} = live(conn, Routes.unit_show_path(conn, :show, unit))

      assert html =~ "Show Unit"
      assert html =~ unit.address
    end

    test "updates unit within modal", %{conn: conn, unit: unit} do
      {:ok, show_live, _html} = live(conn, Routes.unit_show_path(conn, :show, unit))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Unit"

      assert_patch(show_live, Routes.unit_show_path(conn, :edit, unit))

      assert show_live
             |> form("#unit-form", unit: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#unit-form", unit: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.unit_show_path(conn, :show, unit))

      assert html =~ "Unit updated successfully"
      assert html =~ "some updated address"
    end
  end
end
