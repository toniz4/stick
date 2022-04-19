defmodule StickWeb.AuthLive.Admin do
  import Phoenix.LiveView

  # alias StickWeb.Router.Helpers, as: Routes

  alias Stick.Accounts
  alias Stick.Repo

  def on_mount(:default, _params, %{"user_token" => user_token} = _session, socket) do
    socket =
      assign_new(socket, :current_user, fn ->
        Accounts.get_user_by_session_token(user_token)
      end)

    user =
      socket.assigns.current_user
      |> Repo.preload(:role)

    case user.role.is_admin do
      true ->
        {:cont, socket}

      false ->
        {:halt,
         socket
         |> redirect(to: "/")
         |> put_flash(:error, "You must be an admin to acess this page")}
    end
  end
end
