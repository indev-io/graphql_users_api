defmodule GraphqlUsersApi.Processes.ResolverHitTracker do
  alias GraphqlUsersApi.Processes.ResolverHitTracker
  use Agent

  @default_name ResolverHitTracker

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @default_name)
    {initial_value, opts} = Keyword.pop(opts, :initial_value, %{})
    Agent.start_link(fn -> initial_value end, opts)
  end

  def value(key) do
    Agent.get(ResolverHitTracker, fn state ->
      if Map.has_key?(state, key) do
        state[key]
      else
        0
      end
    end)
  end

  def increment(key) do
    Agent.update(ResolverHitTracker, fn state ->
      IO.inspect(state, message: "this is state")
      if Map.has_key?(state, key) do
        Map.put(state, key, state[key] + 1)
      else
        Map.put(state, key, 1)
      end
    end)
  end

end
