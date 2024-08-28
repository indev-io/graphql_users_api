defmodule GraphqlUsersApiWeb.User do
  @users [%{
    id: 1,
    name: "Bill",
    email: "bill@gmail.com",
    preferences: %{
      likes_emails: false,
      likes_phone_calls: true,
      likes_faxes: true
    }
  }, %{
    id: 2,
    name: "Alice",
    email: "alice@gmail.com",
    preferences: %{
      likes_emails: true,
      likes_phone_calls: false,
      likes_faxes: true
    }
  }, %{
    id: 3,
    name: "Jill",
    email: "jill@hotmail.com",
    preferences: %{
      likes_emails: true,
      likes_phone_calls: true,
      likes_faxes: false
    }
  }, %{
    id: 4,
    name: "Tim",
    email: "tim@gmail.com",
    preferences: %{
      likes_emails: false,
      likes_phone_calls: false,
      likes_faxes: false
    }
  }]

  def find(%{id: id}) do
    case Enum.find(@users, &(&1.id === id)) do
      nil -> {:error, %{message: "not found", details: %{id: id}}}
      user -> {:ok, user}
    end
  end

  def get_users_by_preferences(params) do
    case Enum.filter(@users, &(search_query_is_subset_of_map(params ,&1.preferences))) do
      [] -> {:error, %{message: "not found"}}
      users -> {:ok, users}
    end
  end

  defp search_query_is_subset_of_map(search_query, map) do
    Enum.all?(search_query, fn {k, v} -> (is_map_key(map, k) and v === map[k]) end)
  end

  def create_user(id, params) do
    case Enum.find(@users, &(&1.id === id)) do
      nil -> {:ok, params}
      _ -> {:error, "A user with id of #{id} already exists"}
    end
  end

  def update(id, params) do
    with {:ok, user} <- find(%{id: id}) do
      {:ok, Map.merge(user, params)}
    end
  end

  def update_user_preferences(id, params) do
    with {:ok, user} <- find(%{id: id}) do
      #hypothetical push to database here ? (No user_id of course)
      Map.merge(user.preferences, Map.delete(params, :user_id))
      #push out map that includes userID to trigger subscriptions
      {:ok, Map.merge(user.preferences, params)}
    end
  end
end
