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
      |> Repo.preload(:role)
      |> Accounts.change_user_registration()

    roles = Repo.all(from r in Role, select: r.title)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:role_titles, roles)}
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    # TODO: handle this without tons of requests
    params =
      user_params
      |> Map.put("role", Roles.get_role_by_title(user_params["role"]["title"]))

    changeset =
      socket.assigns.user
      |> Repo.preload(:role)
      |> Accounts.change_user_registration(params)
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

    user =
      socket.assigns.user
      |> Repo.preload(:role)

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