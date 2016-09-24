defmodule ApiServer.Repositories.Subscription do
  import Logger

  def list(%{user_id: user_id}) do
    Logger.info("Calling list subscription...")

    [
      %{
        name: "inactive subscription",
        id: 123123,
        user_id: 1,
        state: "inactive"
      },
      %{
        name: "Working subscription",
        id: 123135,
        user_id: 1,
        state: "active"
      },
      %{
        name: "cant make machines subscription",
        id: 32434,
        user_id: 2,
        state: "deactivated"
      }
    ]
      |> Enum.filter(fn %{user_id: sub_user_id} -> sub_user_id === user_id end)
  end
end

