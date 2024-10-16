defmodule GraphqlUsersApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  @spec start(any(), any()) :: {:error, any()} | {:ok, pid()}
  def start(_type, _args) do
    children = [
      GraphqlUsersApi.Repo,
      GraphqlUsersApiWeb.Telemetry,
      GraphqlUsersApi.ResolverHitTracker,
      {DNSCluster, query: Application.get_env(:graphql_users_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: GraphqlUsersApi.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: GraphqlUsersApi.Finch},
      # Start a worker by calling: GraphqlUsersApi.Worker.start_link(arg)
      # {GraphqlUsersApi.Worker, arg},
      # Start to serve requests, typically the last entry
      GraphqlUsersApiWeb.Endpoint,
      {Absinthe.Subscription, GraphqlUsersApiWeb.Endpoint}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GraphqlUsersApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GraphqlUsersApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
