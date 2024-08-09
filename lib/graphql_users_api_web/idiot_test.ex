defmodule GraphqlUsersApiWeb.IdiotTest do
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

  def test_function(map) do
    return = Enum.filter(@users, fn x -> search_query_is_subset_of_map(map, x.preferences) end)
    case return do
      [] -> {:error, %{message: "not found", details: %{likes_emails: true}}}
      users -> {:ok, users}
    end
  end
  # field :users, list_of(:user) do
  #     arg :likes_emails, :boolean
  #     arg :likes_phone_calls, :boolean
  #     arg :likes_faxes, :boolean
  #     resolve fn
  #       %{likes_emails: likes_emails, likes_phone_calls: likes_phone_calls, likes_faxes: likes_faxes}, _->
  #         return = Enum.filter(@users, fn x -> search_query_is_subset_of_map(%{likes_emails: likes_emails, likes_phone_calls: likes_phone_calls, likes_faxes: likes_faxes}, x) end)
  #         IO.puts("#{return}")
  #         case return do
  #           [] -> {:error, %{message: "not found", details: %{likes_emails: true}}}
  #           users -> {:ok, users}
  #         end
  #       _, _ -> {:ok, @users}
  #     end
  #   IO.puts("does this run?")
  #   end

    # #returns a list by parameters
    # def filter_by_parameters(parameters, list) do
    #   Enum.map(parameters, fn {k, v} -> Enum.filter(list, fn x -> x.preferences[k] == v  end ) end)
    # end

    def filter_by_parameters(parameters, list) do
      Enum.filter(list, fn x -> search_query_is_subset_of_map(parameters, x) end)
    end


    def search_query_is_subset_of_map(search_query, map) do
      Enum.all?(search_query, fn {k, v} -> (is_map_key(map, k) and v == map[k]) end)
    end
end
