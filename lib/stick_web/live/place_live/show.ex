defmodule StickWeb.PlaceLive.Show do
  use StickWeb, :live_view

  alias Stick.Units
  alias Stick.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:place, Units.get_place!(id) |> Repo.preload(:unit))}
  end

  defp page_title(:show), do: "Show Place"
  defp page_title(:edit), do: "Edit Place"
end
