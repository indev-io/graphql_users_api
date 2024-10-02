defmodule GraphqlUsersApi.Processes do
  alias GraphqlUsersApi.Processes.ResolverHitTracker

  def increment_resolver_hit_tracker(key) do
    ResolverHitTracker.increment(key)
  end

  def get_value_from_resolver_hit_tracker(key) do
    ResolverHitTracker.value(key)
  end
end
