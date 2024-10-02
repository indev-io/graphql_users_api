defmodule GraphqlUsersApi.AccountsTest do

  alias GraphqlUsersApi.Accounts
  use GraphqlUsersApi.DataCase, async: true

  describe "&create_user/1" do
    test "creates a record in db" do
      assert {:ok, _} = Accounts.create_user(%{name: "Zippy", email: "Zippy@gmail.com",
      preferences: %{likes_emails: true, likes_phone_calls: true, likes_faxes: true}})

      assert user = GraphqlUsersApi.Repo.get_by(Accounts.User, name: "Zippy")
      assert user.name === "Zippy"
    end
  end

  describe "list_users/1" do
    test "returns a list of users based on their preferences" do
      Accounts.create_user(%{name: "Test1", email: "Test1@gmail.com",
      preferences: %{likes_emails: true, likes_phone_calls: true, likes_faxes: true}})
      Accounts.create_user(%{name: "Test1", email: "Test1@gmail.com",
      preferences: %{likes_emails: true, likes_phone_calls: true, likes_faxes: false}})
      Accounts.create_user(%{name: "Test1", email: "Test1@gmail.com",
      preferences: %{likes_emails: true, likes_phone_calls: false, likes_faxes: false}})
      assert {:ok, users} = Accounts.list_users(%{likes_emails: true, name: "Test1"})
      assert length(users) === 3
      assert {:ok, users} = Accounts.list_users(%{likes_phone_calls: true, name: "Test1"})
      assert length(users) === 2
      assert {:ok, users} = Accounts.list_users(%{likes_faxes: true, name: "Test1"})
      assert length(users) === 1
    end
  end


  describe "&find_user/1" do
    test "finds a user by id" do
      assert {:ok, user} = Accounts.create_user(%{name: "Blonk", email: "Blonk@gmail.com",
      preferences: %{likes_emails: true, likes_phone_calls: true, likes_faxes: true}})
      assert {:ok, found_user} = Accounts.find_user(%{id: user.id})
      assert found_user.name === "Blonk"
    end
  end

  describe "&update_user/2" do
    test "update user by id" do
      assert {:ok, user} = Accounts.create_user(%{name: "Zeep", email: "Zeep@gmail.com",
      preferences: %{likes_emails: true, likes_phone_calls: true, likes_faxes: true}})
      assert {:ok, updated_user} = Accounts.update_user(user.id, %{name: "Zorp"})
      assert updated_user.name === "Zorp"
    end
  end

  describe "&update_user_preferences/2" do
    test "update user preferences by id" do
      assert {:ok, user} = Accounts.create_user(%{name: "Zeep", email: "Zeep@gmail.com",
      preferences: %{likes_emails: true, likes_phone_calls: true, likes_faxes: true}})
      assert {:ok, preferences} =  Accounts.update_user_preferences(user.id, %{likes_emails: false, likes_phone_calls: false, likes_faxes: false})
      assert preferences.likes_emails === false
      assert preferences.likes_phone_calls === false
      assert preferences.likes_faxes === false
    end
  end

end
