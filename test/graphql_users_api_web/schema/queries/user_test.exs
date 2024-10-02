defmodule GraphqlUsersApiWeb.Schema.Queries.UserTest do
  use GraphqlUsersApi.DataCase, async: true

  alias GraphqlUsersApiWeb.Schema
  alias GraphqlUsersApi.Accounts

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
  }
  }
  """

  describe "@users" do
    test "fetches users by name" do
      assert {:ok, user} = Accounts.create_user(%{name: "Test7", email: "Test7@gmail.com",
      preferences: %{likes_emails: true, likes_phone_calls: true, likes_faxes: true}})

      assert {:ok, %{data: data}} = Absinthe.run(@all_users_doc, Schema,
        variables: %{
        "name" => "Test7"
        }
      )
      assert List.first(data["users"])["id"] === to_string(user.id)
    end

    test "fetches users by email" do
      assert {:ok, user} = Accounts.create_user(%{name: "Test7", email: "Test7@gmail.com",
      preferences: %{likes_emails: true, likes_phone_calls: true, likes_faxes: true}})

      assert {:ok, %{data: data}} = Absinthe.run(@all_users_doc, Schema,
        variables: %{
        "email" => "Test7@gmail.com"
        }
      )
      assert List.first(data["users"])["id"] === to_string(user.id)
    end

    test "fetches users by preferences" do
      assert {:ok, _user} = Accounts.create_user(%{name: "Test8", email: "Test1@gmail.com",
      preferences: %{likes_emails: true, likes_phone_calls: true, likes_faxes: true}})
      assert {:ok, _user} = Accounts.create_user(%{name: "Test8", email: "Test1@gmail.com",
      preferences: %{likes_emails: true, likes_phone_calls: true, likes_faxes: false}})
      assert {:ok, _user} = Accounts.create_user(%{name: "Test8", email: "Test1@gmail.com",
      preferences: %{likes_emails: true, likes_phone_calls: false, likes_faxes: false}})

      assert {:ok, %{data: data}} = Absinthe.run(@all_users_doc, Schema,
        variables: %{
        "name" => "Test8",
        "likesEmails" => true
        }
      )
      assert length(data["users"]) === 3

      assert {:ok, %{data: data}} = Absinthe.run(@all_users_doc, Schema,
        variables: %{
        "name" => "Test8",
        "likesPhoneCalls" => true
        }
      )
      assert length(data["users"]) === 2

      assert {:ok, %{data: data}} = Absinthe.run(@all_users_doc, Schema,
        variables: %{
        "name" => "Test8",
        "likesFaxes" => true
        }
      )
      assert length(data["users"]) === 1
    end
  end

  @user_doc """
    query user($id: ID! ){
    user(id: $id){
    id
    }
  }
  """
  describe "@user" do
      test "get user by id" do
        assert {:ok, user} = Accounts.create_user(%{name: "Test1", email: "Test1@gmail.com",
        preferences: %{likes_emails: true, likes_phone_calls: true, likes_faxes: true}})

        assert {:ok, %{data: data}} = Absinthe.run(@user_doc, Schema,
        variables: %{
        "id" => user.id
        }
      )
      assert data["user"]["id"] === to_string(user.id)
      end
    end


end
