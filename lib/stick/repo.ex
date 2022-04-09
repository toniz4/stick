defmodule Stick.Repo do
  use Ecto.Repo,
    otp_app: :stick,
    adapter: Ecto.Adapters.Postgres
end
