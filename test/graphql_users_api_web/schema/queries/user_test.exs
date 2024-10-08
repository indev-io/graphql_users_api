defmodule GraphqlUsersApiWeb.Schema.Queries.UserTest do
  use GraphqlUsersApi.DataCase, async: true

  alias GraphqlUsersApiWeb.Schema
  import GraphqlUsersApi.Support.SetupTasks, only: [setup_users: 1]

    @user_doc """
    query user($id: ID! ){
    user(id: $id){
    id
    }
  }
  """

  setup [:setup_users]

  describe "@user" do
      test "get user by id", %{users: users}  do
        user = List.first(users)
        assert {:ok, %{data: data}} = Absinthe.run(@user_doc, Schema,
        variables: %{
          "id" => user.id
          })
      assert data["user"]["id"] === to_string(user.id)
      end
    end

  @all_users_doc """
    query users($name: String, $email: String,
    $likesEmails: Boolean, $likesPhoneCalls: Boolean, $likesFaxes: Boolean
    $before: Int, $after: Int, $first: Int
    ){
  users(name: $name, email: $email,
  likesEmails: $likesEmails, likesPhoneCalls: $likesPhoneCalls, likesFaxes: $likesFaxes,
  before: $before, after: $after, first: $first
  ) {
    id
    name
    email
    preferences {
    likesEmails
    likesFaxes
    likesPhoneCalls
    }
  }
  }
  """

  describe "@users" do
    test "fetches users by name", %{users: users} do
      user = List.first(users)
      assert {:ok, %{data: data}} = absinthe_run_users(user, "name")
      assert List.first(data["users"])["id"] === to_string(user.id)
    end

    test "fetches users by email", %{users: users}  do
      user = List.first(users)
      assert {:ok, %{data: data}} = absinthe_run_users(user, "email")
      assert List.first(data["users"])["id"] === to_string(user.id)
    end

    def absinthe_run_users(user, field) do
      Absinthe.run(@all_users_doc, Schema,
        variables: %{
        field => Map.get(user, camel_case_string_to_snake_case_atom(field))
        }
      )
    end

    test "fetches users by preferences", %{users: users}  do
      first_user = List.first(users)
      cutoff_id = first_user.id - 1
      assert expected_users_returned_from_query(users, cutoff_id, "likesEmails")
      assert expected_users_returned_from_query(users, cutoff_id, "likesFaxes")
      assert expected_users_returned_from_query(users, cutoff_id, "likesPhoneCalls")

    end
  end


  defp expected_users_returned_from_query(users, cutoff_id, preference) do
    {:ok, %{data: data}} = absinthe_run_preferences(preference, cutoff_id)
    ids_of_matching_occurrence_by_type_from_users(users, camel_case_string_to_snake_case_atom(preference)) --
    ids_of_matching_occurrence_by_type_from_query( data["users"], preference) === []
  end

  defp absinthe_run_preferences(preference, cutoff_id) do
    users = Absinthe.run(@all_users_doc, Schema,
        variables: %{
        "after" => cutoff_id,
        preference => true
        }
      )
    users
  end

  defp camel_case_string_to_snake_case_atom(str) do
    str
    |> Macro.underscore
    |> String.to_atom
  end

  defp ids_of_matching_occurrence_by_type_from_users(map_of_users, preference_type) do
    Enum.reduce(map_of_users, [], fn (x, acc) ->
      if Map.get(x.preferences, preference_type) do
      [to_string(x.id) | acc]
      else
      acc
      end
    end)
  end

  defp ids_of_matching_occurrence_by_type_from_query(map_of_users, preference_type) do
    Enum.reduce(map_of_users, [], fn (x, acc) ->
      if Map.get(x["preferences"], preference_type) do
        [x["id"] | acc]
      else
      acc
      end
    end)
  end

end
