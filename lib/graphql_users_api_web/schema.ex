defmodule GraphqlUsersApiWeb.Schema do
  use Absinthe.Schema
  import_types GraphqlUsersApiWeb.Types.User
  import_types GraphqlUsersApiWeb.Schema.Queries.User
  import_types GraphqlUsersApiWeb.Schema.Queries.Metrics
  import_types GraphqlUsersApiWeb.Schema.Mutations.User
  import_types GraphqlUsersApiWeb.Schema.Subscriptions.User

  query do
    import_fields :user_queries
    import_fields :metrics_queries
  end

  mutation do
    import_fields :user_mutations
  end

  subscription do
    import_fields :user_subscriptions
  end

  def context(ctx) do
    source = Dataloader.Ecto.new(GraphqlUsersApi.Repo)
    dataloader = Dataloader.add_source(Dataloader.new(), GraphqlUsersApi.Accounts, source)
    Map.put(ctx, :loader, dataloader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
