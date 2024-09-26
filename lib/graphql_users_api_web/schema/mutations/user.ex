defmodule GraphqlUsersApiWeb.Schema.Mutations.User do
  use Absinthe.Schema.Notation
  alias GraphqlUsersApiWeb.Resolvers

  object :user_mutations do
    @desc "Create a user"
    field :create_user, :user do
      arg :name, non_null(:string)
      arg :email, non_null(:string)
      arg :preferences, non_null(:preferences_filter)
      resolve &Resolvers.User.create/2
    end

    @desc "Update a user"
    field :update_user, :user do
      arg :id, non_null(:id)
      arg :name, :string
      arg :email, :string
      resolve &Resolvers.User.update/2
    end

    @desc "Update user preferences"
    field :update_user_preferences, :preferences do
      arg :id, non_null(:id)
      arg :likes_emails, :boolean
      arg :likes_phone_calls, :boolean
      arg :likes_faxes, :boolean
      resolve &Resolvers.User.update_preferences/2
    end

  end
end
