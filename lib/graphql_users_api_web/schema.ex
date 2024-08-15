defmodule GraphqlUsersApiWeb.Schema do
  use Absinthe.Schema
  import_types GraphqlUsersApiWeb.Types.User
  import_types GraphqlUsersApiWeb.Schema.Queries.User
  import_types GraphqlUsersApiWeb.Schema.Mutations.User
  import_types GraphqlUsersApiWeb.Schema.Subscriptions.User

  query do
    import_fields :user_queries
  end

  mutation do
    import_fields :user_mutations
  end

  subscription do
    import_fields :user_subscriptions
  end


end
