defmodule GraphqlUsersApiWeb.Schema.Queries.User do
  use Absinthe.Schema.Notation
  alias GraphqlUsersApiWeb.Resolvers

object :user_queries do
  field :user, :user do
    arg :id, non_null(:id)
    resolve &Resolvers.User.find/2
  end

  field :users, list_of(:user) do
    arg :likes_emails, :boolean
    arg :likes_phone_calls, :boolean
    arg :likes_faxes, :boolean
    arg :name, :string
    arg :email, :string
    arg :first, :integer
    arg :after, :integer
    arg :before, :integer
    resolve &Resolvers.User.get_users/2
  end
end

end
