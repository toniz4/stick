defmodule StickWeb.ProfileLive.Index do
  use StickWeb, :live_view

  alias Stick.Profiles
  alias Stick.Profiles.Profile

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :profiles, list_profiles())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Profile")
    |> assign(:profile, Profiles.get_profile!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Profile")
    |> assign(:profile, %Profile{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Profiles")
    |> assign(:profile, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    profile = Profiles.get_profile!(id)
    {:ok, _} = Profiles.delete_profile(profile)

    {:noreply, assign(socket, :profiles, list_profiles())}
  end

  defp list_profiles do
    Profiles.list_profiles()
  end
end
