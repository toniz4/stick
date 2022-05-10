defmodule StickWeb.PlaceLiveTest do
  use StickWeb.ConnCase

  import Phoenix.LiveViewTest
  import Stick.UnitsFixtures

  @create_attrs %{title: "some title"}
  @update_attrs %{title: "some updated title"}
  @invalid_attrs %{title: nil}

  defp create_place(_) do
    place = place_fixture()
    %{place: place}
  end

  describe "Index" do
    setup [:create_place]

    test "lists all places", %{conn: conn, place: place} do
      {:ok, _index_live, html} = live(conn, Routes.place_index_path(conn, :index))

      assert html =~ "Listing Places"
      assert html =~ place.title
    end

    test "saves new place", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.place_index_path(conn, :index))

      assert index_live |> element("a", "New Place") |> render_click() =~
               "New Place"

      assert_patch(index_live, Routes.place_index_path(conn, :new))

      assert index_live
             |> form("#place-form", place: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#place-form", place: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.place_index_path(conn, :index))

      assert html =~ "Place created successfully"
      assert html =~ "some title"
    end

    test "updates place in listing", %{conn: conn, place: place} do
      {:ok, index_live, _html} = live(conn, Routes.place_index_path(conn, :index))

      assert index_live |> element("#place-#{place.id} a", "Edit") |> render_click() =~
               "Edit Place"

      assert_patch(index_live, Routes.place_index_path(conn, :edit, place))

      assert index_live
             |> form("#place-form", place: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#place-form", place: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.place_index_path(conn, :index))

      assert html =~ "Place updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes place in listing", %{conn: conn, place: place} do
      {:ok, index_live, _html} = live(conn, Routes.place_index_path(conn, :index))

      assert index_live |> element("#place-#{place.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#place-#{place.id}")
    end
  end

  describe "Show" do
    setup [:create_place]

    test "displays place", %{conn: conn, place: place} do
      {:ok, _show_live, html} = live(conn, Routes.place_show_path(conn, :show, place))

      assert html =~ "Show Place"
      assert html =~ place.title
    end

    test "updates place within modal", %{conn: conn, place: place} do
      {:ok, show_live, _html} = live(conn, Routes.place_show_path(conn, :show, place))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Place"

      assert_patch(show_live, Routes.place_show_path(conn, :edit, place))

      assert show_live
             |> form("#place-form", place: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#place-form", place: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.place_show_path(conn, :show, place))

      assert html =~ "Place updated successfully"
      assert html =~ "some updated title"
    end
  end
end