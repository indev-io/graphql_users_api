defmodule GraphqlUsersApiWeb.ConnCase do
  use ExUnit.CaseTemplate
  using do
    quote do

      use GraphqlUsersApiWeb, :verified_routes
      @endpoint GraphqlUsersApiWeb.Endpoint

      import Phoenix.ConnTest
      import GraphqlUsersApiWeb.ConnCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(GraphqlUsersApi.Repo)
    unless tags[:async] do
    Ecto.Adapters.SQL.Sandbox.mode(GraphqlUsersApi.Repo, {:shared, self()})
    end
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
