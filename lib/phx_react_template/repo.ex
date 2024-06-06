defmodule PhxReactTemplate.Repo do
  use Ecto.Repo,
    otp_app: :phx_react_template,
    adapter: Ecto.Adapters.Postgres
end
