defmodule StickWeb.DepartmentLive.FormComponent do
  use StickWeb, :live_component

  alias Stick.Units

  @impl true
  def update(%{department: department} = assigns, socket) do
    changeset =
      department
      |> Units.change_department()

    units = Units.list_units()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:units, units)}
  end

  @impl true
  def handle_event("validate", %{"department" => department_params}, socket) do
    params =
      department_params
      |> build_department_params()

    changeset =
      socket.assigns.department
      |> Units.change_department(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"department" => department_params}, socket) do
    save_department(socket, socket.assigns.action, department_params)
  end

  defp save_department(socket, :edit, department_params) do
    params =
      department_params
      |> build_department_params()

    socket.assigns.department

    department = socket.assigns.department

    case Units.update_department(department, params) do
      {:ok, _department} ->
        {:noreply,
         socket
         |> put_flash(:info, "Department updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_department(socket, :new, department_params) do
    params =
      department_params
      |> build_department_params()

    case Units.create_department(params) do
      {:ok, _department} ->
        {:noreply,
         socket
         |> put_flash(:info, "Department created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp build_department_params(%{} = department_params) do
    case department_params do
      %{"unit" => %{"title" => title}} ->
        Units.get_unit_by_title(title)
    end
    |> (fn unit ->
          department_params
          |> Map.put("unit", unit)
        end).()
  end
end
