defmodule StickWeb.UserLive.FormComponent do
  use StickWeb, :live_component

  alias Stick.Accounts
  alias Stick.Roles
  alias Stick.Units

  @impl true
  def update(%{user: user} = assigns, socket) do
    changeset =
      user
      |> Accounts.change_user_registration()

    roles = Roles.list_roles()
    units = Units.list_units()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:roles, roles)
     |> assign(:units, units)}
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    # TODO: handle this without tons of requests
    params =
      user_params
      |> Map.put("role", Roles.get_role_by_title(user_params["role"]["title"]))
      |> Map.put("unit", Units.get_unit_by_title(user_params["unit"]["title"]))

    changeset =
      socket.assigns.user
      |> Accounts.User.registration_changeset(params, hash_password: false)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    save_user(socket, socket.assigns.action, user_params)
  end

  defp save_user(socket, :edit, user_params) do
    params =
      user_params
      |> Map.put("role", Roles.get_role_by_title(user_params["role"]["title"]))
      |> Map.put("unit", Units.get_unit_by_title(user_params["unit"]["title"]))

    user = socket.assigns.user

    case Accounts.update_user_registration(user, params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Account updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_user(socket, :new, user_params) do
    params =
      user_params
      |> Map.put("role", Roles.get_role_by_title(user_params["role"]["title"]))
      |> Map.put("unit", Units.get_unit_by_title(user_params["unit"]["title"]))

    case Accounts.register_user(params) do
      {:ok, _role} ->
        {:noreply,
         socket
         |> put_flash(:info, "Role updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
