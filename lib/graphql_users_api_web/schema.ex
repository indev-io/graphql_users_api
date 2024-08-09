defmodule GraphqlUsersApiWeb.Schema do
  use Absinthe.Schema



  @desc "A user that has a name, email, and preferences"
  object :user do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :email, non_null(:string)
    field :preferences, non_null(:preferences)
  end

  @desc "Prefences about how the user likes to be contacted"
  object :preferences do
    field :likes_emails, :boolean
    field :likes_phone_calls, :boolean
    field :likes_faxes, :boolean
  end

  input_object :preferences_filter do
    field :likes_emails, non_null(:boolean)
    field :likes_phone_calls, non_null(:boolean)
    field :likes_faxes, non_null(:boolean)
  end

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

  query do
    field :user, :user do
      arg :id, non_null(:id)

      resolve fn %{id: id}, _ ->
        id = String.to_integer(id)
        case Enum.find(@users, &(&1.id == id)) do
          nil -> {"error", %{message: "not found", details: %{id: id}}}
          user -> {:ok, user}
        end
      end
    end

    field :users, list_of(:user) do
      arg :likes_emails, :boolean
      arg :likes_phone_calls, :boolean
      arg :likes_faxes, :boolean
      resolve fn params, _->
          case Enum.filter(@users, &(search_query_is_subset_of_map(params ,&1.preferences))) do
            [] -> {:error, %{message: "not found"}}
            users -> {:ok, users}
          end
        _, _ -> {:ok, @users}
      end
    end

    defp search_query_is_subset_of_map(search_query, map) do
      Enum.all?(search_query, fn {k, v} -> (is_map_key(map, k) and v == map[k]) end)
    end
  end

  mutation do
    @desc "Create a user"
    field :create_user, :user do
      arg :id, non_null(:id)
      arg :name, non_null(:string)
      arg :email, non_null(:string)
      arg :preferences, non_null(:preferences_filter)

      resolve fn params, _ ->
        case Enum.concat(@users, [params]) do
         _ -> {:ok, params}
        end
      end
    end

    @desc "Update a user"
    field :update_user, :user do
      arg :id, non_null(:id)
      arg :name, :string
      arg :email, :string
      resolve &GraphqlUsersApiWeb.Schema.update/2
    end

    @desc "Update user preferences"
    field :update_user_preferences, :user do
      arg :id, non_null(:id)
      arg :likes_emails, :boolean
      arg :likes_phone_calls, :boolean
      arg :likes_faxes, :boolean
      # arg :preferences, :preferences
      resolve &GraphqlUsersApiWeb.Schema.update_user_preferences/2
    end

  end

  defp find(%{id: id}) do
    id = String.to_integer(id)
    case Enum.find(@users, &(&1.id == id)) do
      nil -> {:error, %{message: "not found"}}
      user -> {:ok, user}
    end
  end

  def update(%{id: id} = params, _) do
    with {:ok, user} <- find(%{id: id}) do
      {:ok, Map.merge(user, params)}
    end
  end

  def update_user_preferences(%{id: id} = params, _) do
    with {:ok, user} <- find(%{id: id}) do
      params = Map.delete(params, :id)
      new_preferences = Map.merge(user.preferences, params)
      user = Map.put(user, :preferences, new_preferences)
      {:ok, user}
    end
  end

  subscription do
    field :created_user, :user do
      trigger :create_user, topic: fn _ ->
        "new_user"
      end
      config fn _, _ ->
        {:ok, topic: "new_user"}
      end
    end
  end
end
