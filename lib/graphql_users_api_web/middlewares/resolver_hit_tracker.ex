defmodule GraphqlUsersApiWeb.Middlewares.ResolverHitTracker do
  alias GraphqlUsersApi.Processes
  @behaviour Absinthe.Middleware

  def call(resolution, _) do
    Processes.increment_resolver_hit_tracker(resolution.definition.name)
    resolution
  end
end
