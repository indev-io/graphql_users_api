defmodule GraphqlUsersApiWeb.Router do
  use GraphqlUsersApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug,
      schema: GraphqlUsersApiWeb.Schema

    if Mix.env() === :dev do
      forward "/graphiql", Absinthe.Plug.GraphiQL,
      interface: :playground,
      schema: GraphqlUsersApiWeb.Schema,
      socket: GraphqlUsersApiWeb.UserSocket
    end
  end

end
