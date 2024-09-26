defmodule GraphqlUsersApiWeb.Middlewares.ResolverHitTracker do
  alias GraphqlUsersApi.Processes.ResolverHitTracker
  @behaviour Absinthe.Middleware

  def call(resolution, _) do
    ResolverHitTracker.increment(resolution.definition.name)
    resolution
  end
end
