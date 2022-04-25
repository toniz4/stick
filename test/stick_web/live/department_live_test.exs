defmodule StickWeb.DepartmentLiveTest do
  use StickWeb.ConnCase

  import Phoenix.LiveViewTest
  import Stick.UnitsFixtures

  @create_attrs %{extension: "some extension", title: "some title"}
  @update_attrs %{extension: "some updated extension", title: "some updated title"}
  @invalid_attrs %{extension: nil, title: nil}

  defp create_department(_) do
    department = department_fixture()
    %{department: department}
  end

  describe "Index" do
    setup [:create_department]

    test "lists all departments", %{conn: conn, department: department} do
      {:ok, _index_live, html} = live(conn, Routes.department_index_path(conn, :index))

      assert html =~ "Listing Departments"
      assert html =~ department.extension
    end

    test "saves new department", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.department_index_path(conn, :index))

      assert index_live |> element("a", "New Department") |> render_click() =~
               "New Department"

      assert_patch(index_live, Routes.department_index_path(conn, :new))

      assert index_live
             |> form("#department-form", department: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#department-form", department: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.department_index_path(conn, :index))

      assert html =~ "Department created successfully"
      assert html =~ "some extension"
    end

    test "updates department in listing", %{conn: conn, department: department} do
      {:ok, index_live, _html} = live(conn, Routes.department_index_path(conn, :index))

      assert index_live
             |> element("#department-#{department.id} a", "Edit")
             |> render_click() =~
               "Edit Department"

      assert_patch(index_live, Routes.department_index_path(conn, :edit, department))

      assert index_live
             |> form("#department-form", department: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#department-form", department: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.department_index_path(conn, :index))

      assert html =~ "Department updated successfully"
      assert html =~ "some updated extension"
    end

    test "deletes department in listing", %{conn: conn, department: department} do
      {:ok, index_live, _html} = live(conn, Routes.department_index_path(conn, :index))

      assert index_live
             |> element("#department-#{department.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#department-#{department.id}")
    end
  end

  describe "Show" do
    setup [:create_department]

    test "displays department", %{conn: conn, department: department} do
      {:ok, _show_live, html} =
        live(conn, Routes.department_show_path(conn, :show, department))

      assert html =~ "Show Department"
      assert html =~ department.extension
    end

    test "updates department within modal", %{conn: conn, department: department} do
      {:ok, show_live, _html} =
        live(conn, Routes.department_show_path(conn, :show, department))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Department"

      assert_patch(show_live, Routes.department_show_path(conn, :edit, department))

      assert show_live
             |> form("#department-form", department: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#department-form", department: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.department_show_path(conn, :show, department))

      assert html =~ "Department updated successfully"
      assert html =~ "some updated extension"
    end
  end
end
