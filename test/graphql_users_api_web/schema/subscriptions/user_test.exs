defmodule GraphqlUsersApiWeb.Schema.Subscriptions.UserTest do
  use GraphqlUsersApiWeb.SubscriptionCase

  alias GraphqlUsersApi.Accounts



@created_user_doc """
subscription createdUser{
  createdUser{
    id
    name
  }
}
"""

@create_user_doc """
mutation createUser($name: String!, $email: String!, $preferences: PreferencesFilter!)
{
  createUser(name: $name , email: $email, preferences: $preferences)
  {
    id
    name
  }
}

"""


describe "@createdUser" do
  test "sends user when createUser mutation is triggered", %{socket: socket} do
    ref = push_doc socket, @created_user_doc
    assert_reply ref, :ok, %{subscriptionId: subscription_id}

    ref = push_doc socket, @create_user_doc, variables: %{
      "name" => "test12",
      "email" => "test12@gmail.com",
      "preferences" => %{
        "likesEmails" => true,
        "likesFaxes" => false,
        "likesPhoneCalls" => true
      }
    }

    assert_reply ref, :ok, reply
    created_user_id = reply.data["createUser"]["id"]
    created_user_name = reply.data["createUser"]["name"]

    assert_push "subscription:data", data

    assert %{
      subscriptionId: ^subscription_id,
      result: %{
        data: %{
          "createdUser" => %{
            "id" => ^created_user_id,
            "name" => ^created_user_name,
          }
        }
      }
    } = data


  end
end


@update_user_doc_preferences_doc """
mutation updateUserPreferences($id: ID!, $likesEmails: Boolean, $likesFaxes: Boolean, $likesPhoneCalls: Boolean)
{
updateUserPreferences(id: $id, likesEmails: $likesEmails, likesFaxes: $likesFaxes, likesPhoneCalls: $likesPhoneCalls){
id
likesEmails
likesFaxes
likesPhoneCalls
}
}
"""

@updated_user_preferences_doc """
subscription updatedUserPreferences($id: ID!){
updatedUserPreferences(id: $id){
id
likesEmails
likesFaxes
likesPhoneCalls
}
}
"""

describe "@userPreferencesUpdated" do
  test "sends preferences when updatedPreferences mutation is triggered", %{socket: socket} do
    assert {:ok, user} = Accounts.create_user(%{name: "Test2", email: "Test2@gmail.com",
    preferences: %{likes_emails: true, likes_phone_calls: true, likes_faxes: true}})

    updated_likes_phone_calls_preference = false
    updated_likes_faxes_preference = false
    updated_likes_emails_preference = false
    user_id = to_string(user.id)

    ref = push_doc socket, @updated_user_preferences_doc, variables: %{id: user.id}

    assert_reply ref, :ok, %{subscriptionId: subscription_id}

    ref = push_doc socket, @update_user_doc_preferences_doc, variables: %{
      "id" => user.id,
      "likesPhoneCalls" => updated_likes_phone_calls_preference,
      "likesFaxes" => updated_likes_faxes_preference,
      "likesEmails" => updated_likes_emails_preference
    }

    assert_reply ref, :ok, reply


    assert %{
      data: %{"updateUserPreferences" => %{
        "id" => ^user_id,
        "likesPhoneCalls" => ^updated_likes_phone_calls_preference,
        "likesFaxes" => ^updated_likes_faxes_preference,
        "likesEmails" => ^updated_likes_emails_preference
      }}
    } = reply

    assert_push "subscription:data", data

    assert %{
      subscriptionId: ^subscription_id,
      result: %{
        data: %{
          "updatedUserPreferences" => %{
            "id" => ^user_id,
            "likesPhoneCalls" => ^updated_likes_phone_calls_preference,
            "likesFaxes" => ^updated_likes_faxes_preference,
            "likesEmails" => ^updated_likes_emails_preference
          }
        }
      }
    } = data

  end
end



end
