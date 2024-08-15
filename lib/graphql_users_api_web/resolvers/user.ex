defmodule GraphqlUsersApiWeb.Resolvers.User do
  alias GraphqlUsersApiWeb.User
  def find(%{id: id},_ ) do
    id = String.to_integer(id)
    User.find(%{id: id})
  end

  def get_users(params, _) do
      User.get_users_by_preferences(params)
  end

  def create(%{id: id} = params, _) do
    id = String.to_integer(id)
     User.create_user(id, params)
  end

  def update(%{id: id} = params, _) do
      id = String.to_integer(id)
      User.update(id, Map.delete(params, :id))
  end


  def update_preferences(%{user_id: id} = params, _) do
    id = String.to_integer(id)
    User.update_user_preferences(id, params)
  end

end
