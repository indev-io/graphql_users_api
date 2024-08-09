defmodule GraphqlUsersApiWeb.UserChannel do
  use GraphqlUsersApiWeb, :channel

  def join("users", _payload, socket) do
    {:ok, socket}
  end

  def handle_in("new_user", %{"id" => id}, socket) do
    broadcast "new_user", socket, %{"id" => id}
    {:reply, %{"accepted" => true}, socket}
  end
end
