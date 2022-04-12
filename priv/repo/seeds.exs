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
alias Stick.{Accounts, Repo, Accounts.User}

account = %{
  name: "admin",
  username: "admin",
  password: "123",
  email: "admin@stick.com"
}

Accounts.register_user(account)
|> IO.inspect()
