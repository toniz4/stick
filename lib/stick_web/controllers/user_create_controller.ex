defmodule StickWeb.UserCreateController do
  use StickWeb, :controller

  alias Stick.Accounts
  alias Stick.Accounts.User
  alias Stick.Profiles

  def new(conn, _params) do
    user_changeset = Accounts.change_user_registration(%User{})
    profile_titles = Profiles.list_profiles_titles()

    render(conn, "new.html",
      user_changeset: user_changeset,
      profile_titles: profile_titles
    )
  end

  def create(conn, %{"user" => user_params}) do
    %{"profile" => %{"title" => title}} = user_params

    profile_titles = Profiles.list_profiles_titles()

    full_profile = title
    |> Profiles.get_profile_by_name()

    user_profile_params = user_params
    |> Map.put("profile", full_profile)

    case Accounts.register_user(user_profile_params) do
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
          user_changeset: user_changeset)
    end
  end
end
