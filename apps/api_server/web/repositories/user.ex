defmodule ApiServer.Repositories.User do
  import Logger

  def start_link do
    data = [
      %{
        name: "foo",
        id: 1
      },
      %{
        name: "bar",
        id: 2
      }
    ]
    Agent.start_link(fn -> data end, name: __MODULE__)
  end

  def find_by_id(id) do
    Logger.info("Calling find user by id: #{id}...")

    Agent.get(__MODULE__, fn x ->
      Enum.find(x, fn %{id: user_id} -> id === user_id end)
    end)
  end

  def update(id, payload) do
    Agent.get_and_update(__MODULE__, fn x ->
      Enum.reduce(x, {%{}, []}, fn %{id: user_id} = user, {updated_user, user_set} ->
        case user_id === id do
          true ->
            user_with_updated_data = Map.merge(user, payload)
            {user_with_updated_data, [user_with_updated_data | user_set]}
          _ -> {updated_user, [user | user_set]}
        end
      end)
    end)
  end
end

