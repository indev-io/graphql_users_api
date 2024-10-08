defmodule GraphqlUsersApiWeb.Resolvers.User do

  alias GraphqlUsersApi.Accounts
  def find(%{id: id},_ ) do
    id = String.to_integer(id)
    Accounts.find_user(%{id: id})
  end

  def get_users(params, _) do
      Accounts.list_users(params)
  end

  def create(params, _) do
      Accounts.create_user(params)
  end

  def update(%{id: id} = params, _) do
      id = String.to_integer(id)
      Accounts.update_user(id, Map.delete(params, :id))
  end

  def update_preferences(%{user_id: id} = params, _) do
    id = String.to_integer(id)
    Accounts.update_user_preferences(id, params)
  end


end
