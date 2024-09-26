defmodule GraphqlUsersApiWeb.Schema.Queries.Metrics do
  use Absinthe.Schema.Notation
  alias GraphqlUsersApiWeb.Resolvers

object :metrics_queries do
  field :resolver_hits, :integer do
    arg :key, non_null(:string)
    resolve &Resolvers.Metrics.get_resolver_hits/2
  end

end
end
