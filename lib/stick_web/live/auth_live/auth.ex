defmodule StickWeb.AuthLive do
  import Phoenix.LiveView

  alias StickWeb.Router.Helpers, as: Routes
  alias Stick.Accounts

  def on_mount(:default, _params, %{"user_token" => user_token} = _session, socket) do
    socket =
      assign_new(socket, :current_user, fn ->
        Accounts.get_user_by_session_token(user_token)
      end)

    case socket.assigns.current_user do
      nil ->
        {:halt,
         socket
         |> put_flash(:error, "You must be logged in to acess this page")
         |> redirect(to: Routes.user_session_path(socket, :new))}

      %Accounts.User{} = _user ->
        {:cont, socket}
    end
  end
end
