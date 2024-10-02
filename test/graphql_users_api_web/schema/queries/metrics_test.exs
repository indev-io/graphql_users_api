defmodule GraphqlUsersApiWeb.Schema.Queries.MetricsTest do
use GraphqlUsersApi.DataCase, async: true
alias GraphqlUsersApiWeb.Schema
alias GraphqlUsersApi.Processes

@resolver_hits_doc """
query resolverHits($key: String!){
resolverHits(key: $key)
}
"""

describe "@resolverQuery" do
  test "gets the current state of the resolver hits" do
    Processes.increment_resolver_hit_tracker("testParams")

  assert {:ok,  %{data: data}} = Absinthe.run(@resolver_hits_doc, Schema,
        variables: %{
        "key" => "testParams"
        }
      )

  assert data["resolverHits"] === 1
  end

end
end
