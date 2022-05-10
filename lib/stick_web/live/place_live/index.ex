defmodule StickWeb.PlaceLive.Index do
  use StickWeb, :live_view

  alias Stick.Units
  alias Stick.Units.Place
  alias Stick.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :places, list_places())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Place")
    |> assign(:place, Units.get_place!(id) |> Repo.preload(:unit))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Place")
    |> assign(:place, %Place{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Places")
    |> assign(:place, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    place = Units.get_place!(id)
    {:ok, _} = Units.delete_place(place)

    {:noreply, assign(socket, :places, list_places())}
  end

  defp list_places do
    Units.list_places() 
    |> Repo.preload(:unit)
  end
end
