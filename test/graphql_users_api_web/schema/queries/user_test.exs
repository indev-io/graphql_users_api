defmodule GraphqlUsersApiWeb.Schema.Queries.UserTest do
  use GraphqlUsersApiWeb.Datacase, async: true

  alias GraphqlUsersApiWeb.Schema
  alias GraphqlUsersApi.Accounts

  all_users_doc """
    query
  """

  describe @users do
    test "fetches users by preference"


  end
end
