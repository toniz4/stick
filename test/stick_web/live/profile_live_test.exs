defmodule StickWeb.ProfileLiveTest do
  use StickWeb.ConnCase

  import Phoenix.LiveViewTest
  import Stick.ProfilesFixtures

  @create_attrs %{can_close_tickets: true, can_open_ticket: true, is_admin: true}
  @update_attrs %{can_close_tickets: false, can_open_ticket: false, is_admin: false}
  @invalid_attrs %{can_close_tickets: false, can_open_ticket: false, is_admin: false}

  defp create_profile(_) do
    profile = profile_fixture()
    %{profile: profile}
  end

  describe "Index" do
    setup [:create_profile]

    test "lists all profiles", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.profile_index_path(conn, :index))

      assert html =~ "Listing Profiles"
    end

    test "saves new profile", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.profile_index_path(conn, :index))

      assert index_live |> element("a", "New Profile") |> render_click() =~
               "New Profile"

      assert_patch(index_live, Routes.profile_index_path(conn, :new))

      assert index_live
             |> form("#profile-form", profile: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#profile-form", profile: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.profile_index_path(conn, :index))

      assert html =~ "Profile created successfully"
    end

    test "updates profile in listing", %{conn: conn, profile: profile} do
      {:ok, index_live, _html} = live(conn, Routes.profile_index_path(conn, :index))

      assert index_live |> element("#profile-#{profile.id} a", "Edit") |> render_click() =~
               "Edit Profile"

      assert_patch(index_live, Routes.profile_index_path(conn, :edit, profile))

      assert index_live
             |> form("#profile-form", profile: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#profile-form", profile: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.profile_index_path(conn, :index))

      assert html =~ "Profile updated successfully"
    end

    test "deletes profile in listing", %{conn: conn, profile: profile} do
      {:ok, index_live, _html} = live(conn, Routes.profile_index_path(conn, :index))

      assert index_live |> element("#profile-#{profile.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#profile-#{profile.id}")
    end
  end

  describe "Show" do
    setup [:create_profile]

    test "displays profile", %{conn: conn, profile: profile} do
      {:ok, _show_live, html} = live(conn, Routes.profile_show_path(conn, :show, profile))

      assert html =~ "Show Profile"
    end

    test "updates profile within modal", %{conn: conn, profile: profile} do
      {:ok, show_live, _html} = live(conn, Routes.profile_show_path(conn, :show, profile))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Profile"

      assert_patch(show_live, Routes.profile_show_path(conn, :edit, profile))

      assert show_live
             |> form("#profile-form", profile: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#profile-form", profile: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.profile_show_path(conn, :show, profile))

      assert html =~ "Profile updated successfully"
    end
  end
end
