defmodule ApiServer.Repositories.User do
  import Logger

  def find_by_id(id) do
    Logger.info("Calling find user by id: #{id}...")

    [
      %{
        name: "foo",
        id: 1
      },
      %{
        name: "bar",
        id: 2
      }
    ]
      |> Enum.find(fn %{id: user_id} -> id === user_id end)
  end
end

