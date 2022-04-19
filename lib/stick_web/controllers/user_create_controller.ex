defmodule StickWeb.UserCreateController do
  use StickWeb, :controller

  alias Stick.Accounts
  alias Stick.Accounts.User
  alias Stick.Roles

  def new(conn, _params) do
    user_changeset = Accounts.change_user_registration(%User{})
    role_titles = Roles.list_roles_titles()

    render(conn, "new.html",
      user_changeset: user_changeset,
      role_titles: role_titles
    )
  end

  def create(conn, %{"user" => user_params}) do
    %{"role" => %{"title" => title}} = user_params

    role_titles = Roles.list_roles_titles()

    full_role =
      title
      |> Roles.get_role_by_title()

    user_role_params =
      user_params
      |> Map.put("role", full_role)

    case Accounts.register_user(user_role_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :edit, &1)
          )

        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.user_create_path(conn, :new))

      {:error, %Ecto.Changeset{} = user_changeset} ->
        render(conn, "new.html",
          user_changeset: user_changeset,
          role_titles: role_titles
        )
    end
  end
end
