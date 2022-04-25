defmodule StickWeb.DepartmentLive.Show do
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
     |> assign(:department, Units.get_department!(id) |> Repo.preload(:unit))}
  end

  defp page_title(:show), do: "Show Department"
  defp page_title(:edit), do: "Edit Department"
end
