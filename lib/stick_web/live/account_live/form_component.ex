defmodule StickWeb.UserLive.FormComponent do
  use StickWeb, :live_component

  alias Stick.Accounts
  alias Stick.Roles
  alias Stick.Roles.Role
  alias Stick.Repo

  @impl true
  def update(%{user: user} = assigns, socket) do
    import Ecto.Query

    changeset =
      user
      |> Accounts.change_user_registration()

    roles = Roles.list_roles()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:roles, roles)}
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    # TODO: handle this without tons of requests
    params =
      user_params
      |> Map.put("role", Roles.get_role_by_title(user_params["role"]["title"]))

    changeset =
      socket.assigns.user
      # |> Accounts.change_user_registration(params)
      |> Accounts.User.registration_changeset(params, hash_password: false)
      |> Map.put(:action, :validate)
      |> IO.inspect()

      socket.assigns.user.hashed_password
      |> IO.inspect()

    # Accounts.User.edit_user_changeset(socket.assigns.user, params) |> IO.inspect()

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    save_user(socket, socket.assigns.action, user_params)
  end

  defp save_user(socket, :edit, user_params) do
    params =
      user_params
      |> Map.put("role", Roles.get_role_by_title(user_params["role"]["title"]))

    user = socket.assigns.user

    case Accounts.update_user_registration(user, params) do
      {:ok, _role} ->
        {:noreply,
         socket
         |> put_flash(:info, "Role updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_user(socket, :new, user_params) do
    params =
      user_params
      |> Map.put("role", Roles.get_role_by_title(user_params["role"]["title"]))

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
