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
alias Stick.{
  Accounts,
  Repo,
  Accounts.User,
  Roles,
  Roles.Role,
  Units,
  Units.Department,
  Units.Unit
}

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

unit1 = %{
  title: "Main",
  phone: "+88 88888-8888",
  address: "88 Street, Some City"
}

unit2 = %{
  title: "Second",
  phone: "+44 44444-44444",
  address: "44 Street, Some City"
}

Units.create_unit(unit1)
Units.create_unit(unit2)

department1 = %{
  title: "IT",
  extension: "5555",
  unit: Repo.one!(from u in Unit, where: u.title == "Main")
}

department2 = %{
  title: "HR",
  extension: "4444",
  unit: Repo.one!(from u in Unit, where: u.title == "Main")
}

Units.create_department(department1)

Units.create_department(department2)

admin = %{
  name: "admin",
  username: "admin",
  password: "admin123456789",
  role: ap,
  unit: Repo.one!(from u in Unit, where: u.title == "Main"),
  department: Repo.one!(from d in Department, where: d.title == "IT"),
  email: "admin@stick.com"
}

normal = %{
  name: "normal",
  username: "normal",
  password: "normal123456789",
  role: np,
  unit: Repo.one!(from u in Unit, where: u.title == "Main"),
  department: Repo.one!(from d in Department, where: d.title == "IT"),
  email: "normal@stick.com"
}

Accounts.register_user(admin)

Accounts.register_user(normal)
