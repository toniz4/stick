defmodule StickWeb.PlaceLive.FormComponent do
  use StickWeb, :live_component

  alias Stick.Units

  @impl true
  def update(%{place: place} = assigns, socket) do
    changeset = Units.change_place(place)

    units = Units.list_units()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:units, units)}
  end

  @impl true
  def handle_event("validate", %{"place" => place_params}, socket) do
    params =
      place_params
      |> build_place_params()

    changeset =
      socket.assigns.place
      |> Units.change_place(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"place" => place_params}, socket) do
    save_place(socket, socket.assigns.action, place_params)
  end

  defp save_place(socket, :edit, place_params) do
    params =
      place_params
      |> build_place_params()

    case Units.update_place(socket.assigns.place, params) do
      {:ok, _place} ->
        {:noreply,
         socket
         |> put_flash(:info, "Place updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_place(socket, :new, place_params) do
    params =
      place_params
      |> build_place_params()

    case Units.create_place(params) do
      {:ok, _place} ->
        {:noreply,
         socket
         |> put_flash(:info, "Place created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp build_place_params(%{} = place_params) do
    %{"unit" => %{"title" => title}} = place_params

    unit = Units.get_unit_by_title(title)

    place_params
    |> Map.put("unit", unit)
  end
end
