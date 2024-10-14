defmodule GraphqlUsersApi.ResolverHitTracker do
  use Agent

  @default_name __MODULE__

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @default_name)
    {initial_value, opts} = Keyword.pop(opts, :state, %{})

    Agent.start_link(fn -> initial_value end, opts)
  end

  def value(name \\ @default_name, key) do
    Agent.get(name, fn state ->
      if Map.has_key?(state, key) do
        state[key]
      else
        0
      end
    end)
  end

  def increment(name \\ @default_name, key) do
    Agent.update(name, fn state ->
      if Map.has_key?(state, key) do
        Map.put(state, key, state[key] + 1)
      else
        Map.put(state, key, 1)
      end
    end)
  end
end
