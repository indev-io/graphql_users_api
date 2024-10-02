defmodule GraphqlUsersApi.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias GraphqlUsersApi.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import GraphqlUsersApi.DataCase

    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(GraphqlUsersApi.Repo)
    unless tags[:async] do
    Ecto.Adapters.SQL.Sandbox.mode(GraphqlUsersApi.Repo, {:shared, self()})
    end
    :ok
  end
end
