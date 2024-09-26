defmodule GraphqlUsersApiWeb.Plugs.ResolverHitTracker do
  @behaviour Plug

  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    if Map.has_key?(conn.body_params, "query") do
          conn
          |> extract_query_from_conn
          |> increment_resolver_hit_tracker_by_query

      conn
    else
      conn
    end
  end

  defp extract_query_from_conn(conn) do
     [_a , query | _c] =
      conn.body_params["query"]
      |> String.replace("\n", " ")
      |> String.replace("{", " ")
      |> String.replace("(", " ")
      |> String.split(" ", trim: true)

      query
  end

  defp increment_resolver_hit_tracker_by_query(query) do
    GraphqlUsersApi.Processes.ResolverHitTracker.increment(query)
  end

end
