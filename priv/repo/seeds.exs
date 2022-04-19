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
alias Stick.{Accounts, Repo, Accounts.User, Roles, Roles.Role}
import Ecto.Changeset
import Ecto
import Ecto.Query

admin_role = %{
  can_close_tickets: true,
  can_open_tickets: true,
  is_admin: true,
  title: "admin"
}

normal_role = %{
  can_close_tickets: false,
  can_open_tickets: true,
  is_admin: false,
  title: "normal"
}

Roles.create_role(admin_role)
Roles.create_role(normal_role)

normal_q = from p in Role, where: p.title == "normal"
admin_q = from p in Role, where: p.title == "admin"

np = Repo.one(normal_q)
ap = Repo.one(admin_q)

admin = %{
  name: "admin",
  username: "admin",
  password: "admin123456789",
  role: ap,
  email: "admin@stick.com"
}

normal = %{
  name: "normal",
  username: "normal",
  password: "normal123456789",
  role: np,
  email: "normal@stick.com"
}

user =
  Accounts.register_user(admin)
  |> IO.inspect()

user =
  Accounts.register_user(normal)
  |> IO.inspect()
