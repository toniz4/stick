defmodule StickWeb.DepartmentLive.Index do
  use StickWeb, :live_view

  alias Stick.Units
  alias Stick.Units.Department
  alias Stick.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :departments, list_departments())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Department")
    |> assign(:department, Units.get_department!(id) |> Repo.preload(:unit))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Department")
    |> assign(:department, %Department{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Departments")
    |> assign(:department, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    department = Units.get_department!(id)
    {:ok, _} = Units.delete_department(department)

    {:noreply, assign(socket, :departments, list_departments())}
  end

  defp list_departments do
    Units.list_departments()
    |> Repo.preload(:unit)
  end
end
