defmodule GraphqlUsersApiWeb.SubscriptionCase do

  use ExUnit.CaseTemplate

  using do
    quote do
      use GraphqlUsersApiWeb.ChannelCase

      use Absinthe.Phoenix.SubscriptionTest,
      schema: GraphqlUsersApiWeb.Schema

      setup do
        {:ok, socket } = Phoenix.ChannelTest.connect(GraphqlUsersApiWeb.UserSocket, %{})
        {:ok, socket } = Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)

        {:ok, %{socket: socket}}
      end
    end
  end
end
