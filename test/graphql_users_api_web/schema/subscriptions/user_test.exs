defmodule GraphqlUsersApiWeb.Schema.Subscriptions.UserTest do
  use GraphqlUsersApiWeb.SubscriptionCase

  import GraphqlUsersApi.Support.SetupTasks, only: [setup_user: 1]


setup [:setup_user]

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
mutation updateUserPreferences($userId: ID!, $likesEmails: Boolean, $likesFaxes: Boolean, $likesPhoneCalls: Boolean)
{
updateUserPreferences(userId: $userId, likesEmails: $likesEmails, likesFaxes: $likesFaxes, likesPhoneCalls: $likesPhoneCalls){
userId
likesEmails
likesFaxes
likesPhoneCalls
}
}
"""

@updated_user_preferences_doc """
subscription updatedUserPreferences($userId: ID!){
updatedUserPreferences(userId: $userId){
userId
likesEmails
likesFaxes
likesPhoneCalls
}
}
"""

describe "@userPreferencesUpdated" do
  test "sends preferences when updatedPreferences mutation is triggered", %{socket: socket, user: user} do

    updated_likes_phone_calls_preference = false
    updated_likes_faxes_preference = false
    updated_likes_emails_preference = false
    user_id = to_string(user.id)

    ref = push_doc socket, @updated_user_preferences_doc, variables: %{userId: user.id}

    assert_reply ref, :ok, %{subscriptionId: subscription_id}

    ref = push_doc socket, @update_user_doc_preferences_doc, variables: %{
      "userId" => user_id,
      "likesPhoneCalls" => updated_likes_phone_calls_preference,
      "likesFaxes" => updated_likes_faxes_preference,
      "likesEmails" => updated_likes_emails_preference
    }

    assert_reply ref, :ok, reply

    assert %{
      data: %{"updateUserPreferences" => %{
        "userId" => ^user_id,
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
            "userId" => ^user_id,
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
