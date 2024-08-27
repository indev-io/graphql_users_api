defmodule GraphqlUsersApi.Repo do
  use Ecto.Repo,
    otp_app: :graphql_users_api,
    adapter: Ecto.Adapters.Postgres
end
