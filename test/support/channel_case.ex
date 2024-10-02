defmodule GraphqlUsersApiWeb.ChannelCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Phoenix.ChannelTest

      @endpoint GraphqlUsersApiWeb.Endpoint
    end
  end
end
