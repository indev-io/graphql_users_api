defmodule GraphqlUsersApiWeb.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: GraphqlUsersApiWeb.Schema

  # channel "users", GraphqlUsersApiWeb
  channel "users", GraphqlUsersApiWeb.UserChannel
  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end


  def id(_socket) do
    nil
  end
end
