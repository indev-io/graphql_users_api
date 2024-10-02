defmodule GraphqlUsersApiWeb.Resolvers.Metrics do
alias GraphqlUsersApi.Processes

  def get_resolver_hits(%{key: key}, _) do
  val = Processes.get_value_from_resolver_hit_tracker(key)
  {:ok, val}
  end
end
