# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Stick.Repo.insert!(%Stick.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Stick.{Accounts, Repo, Accounts.User, Profiles, Profiles.Profile}
import Ecto.Changeset
import Ecto
import Ecto.Query

admin_profile = %{
  can_close_tickets: true,
  can_open_tickets: true,
  is_admin: true,
  title: "admin"
}

normal_profile = %{
  can_close_tickets: false,
  can_open_tickets: true,
  is_admin: false,
  title: "normal"
}

Profiles.create_profile(admin_profile)
Profiles.create_profile(normal_profile)

normal_q = from p in Profile, where: p.title == "normal"
admin_q = from p in Profile, where: p.title == "admin"

np = Repo.one(normal_q)
ap = Repo.one(admin_q)

admin = %{
  name: "admin",
  username: "admin",
  password: "admin123456789",
  profile: ap,
  email: "admin@stick.com"
}

normal = %{
  name: "normal",
  username: "normal",
  password: "normal123456789",
  profile: np,
  email: "normal@stick.com"
}

user =
  Accounts.register_user(admin)
  |> IO.inspect()

user =
  Accounts.register_user(normal)
  |> IO.inspect()
