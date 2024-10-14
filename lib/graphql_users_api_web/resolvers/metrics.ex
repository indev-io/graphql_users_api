defmodule GraphqlUsersApiWeb.Resolvers.Metrics do
  alias GraphqlUsersApi.ResolverHitTracker

  def get_resolver_hits(%{key: key}, _) do
    val = ResolverHitTracker.value(key)
    {:ok, val}
  end
end
