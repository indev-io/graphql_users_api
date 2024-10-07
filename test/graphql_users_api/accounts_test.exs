defmodule GraphqlUsersApi.AccountsTest do

  alias GraphqlUsersApi.Accounts
  alias GraphqlUsersApi.Repo
  use GraphqlUsersApi.DataCase, async: true
  import GraphqlUsersApi.Support.SetupTasks, only: [setup_users: 1]

  describe "&create_user/1" do
    test "creates a record in db" do
      assert {:ok, created_user} = Accounts.create_user(%{name: "Zippy", email: "Zippy@gmail.com",
      preferences: %{likes_emails: true, likes_phone_calls: true, likes_faxes: true}})

      assert found_user = Repo.get_by(Accounts.User, id: created_user.id)
      assert found_user.name === created_user.name
    end
  end

  setup_all [:setup_users]

  describe "list_users/1" do
    test "returns a list of users based on their preferences", %{users: users} do
      first_user = List.first(users)
      cutoff_id = first_user.id - 1

      assert {:ok, returned_users} = Accounts.list_users(%{likes_emails: true, after: cutoff_id})
      assert length(returned_users) === true_preference_occurrence_by_type(users, :likes_emails)

      assert {:ok, returned_users} = Accounts.list_users(%{likes_phone_calls: true, after: cutoff_id})
      assert length(returned_users) === true_preference_occurrence_by_type(users, :likes_phone_calls)

      assert {:ok, returned_users} = Accounts.list_users(%{likes_faxes: true, after: cutoff_id})
      assert length(returned_users) === true_preference_occurrence_by_type(users, :likes_faxes)
    end
  end

  defp true_preference_occurrence_by_type(map_of_users, preference_type) do
    Enum.reduce(map_of_users, 0, fn (x, acc) ->
      if preference_true(x, preference_type) === true do
      acc + 1
      else
      acc
      end
    end)
  end

  defp preference_true(map_or_struct, preference_type) when is_struct(map_or_struct) do
    Map.get(map_or_struct.preferences, preference_type)
  end


  describe "&find_user/1" do
    test "finds a user by id", %{users: users} do
      user = List.first(users)
      assert {:ok, found_user} = Accounts.find_user(%{id: user.id})
      assert found_user.name === user.name
    end
  end

  describe "&update_user/2" do
    test "update user name and email by id", %{users: users} do
      user = List.first(users)
      updated_name = "Zorp"
      updated_email = "Zorp@testmail.com"
      assert {:ok, _updated_user} = Accounts.update_user(user.id, %{name: updated_name, email: updated_email})
      assert found_user = Repo.get_by(Accounts.User, id: user.id)
      assert found_user.name === updated_name
      assert found_user.email === updated_email
    end
  end

  describe "&update_user_preferences/2" do
    test "update user preferences by id", %{users: users} do
      user = List.first(users)
      updated_likes_emails_preference = false
      updated_likes_phone_calls_preference = false
      updated_likes_likes_faxes_preference = false
      assert {:ok, _preferences} =  Accounts.update_user_preferences(user.id,
      %{likes_emails: updated_likes_emails_preference,
      likes_phone_calls: updated_likes_phone_calls_preference,
      likes_faxes: updated_likes_likes_faxes_preference})
      assert found_user_preferences = Repo.get_by(Accounts.Preference, user_id: user.id)
      assert found_user_preferences.likes_emails === updated_likes_emails_preference
      assert found_user_preferences.likes_phone_calls === updated_likes_phone_calls_preference
      assert found_user_preferences.likes_faxes === updated_likes_likes_faxes_preference
    end
  end

end
