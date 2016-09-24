defmodule ApiServer.UserSchema do
  alias GraphQL.Type.{ObjectType, List, NonNull, ID, String, Int, Boolean}
  alias ApiServer.{Repositories}

  defmodule ApiServer.Schema.Subscription do
    def type() do
      %ObjectType{
        name: "Subscription",
        description: "Subscription of users in the application",
        fields: %{
          id: %{type: %ID{}, description: "The unique identifier for the subscription"},
          name: %{type: %String{}, description: "The name of the subscription"},
          state: %{type: %String{}, description: "The state of the subscription"}
        }
      }
    end
  end


  defmodule ApiServer.Schema.User do
    def type() do
      %ObjectType{
        name: "User",
        description: "User of the application",
        fields: %{
          id: %{type: %ID{}, description: "The unique identifier for the user"},
          name: %{type: %String{}, description: "The name of the user"},
          subscriptions: %{
            type: %List{ofType: ApiServer.Schema.Subscription},
            resolve: &get_subscription_by_user/3
          }
        }
      }
    end

    def get_subscription_by_user(%{id: user_id}, _args, _info) do
      Repositories.Subscription.list(%{user_id: user_id})
    end

  end


  defmodule ApiServer.Schema.Query do
    def type() do
      %ObjectType{
        name: "Query",
        description: "Queries available to consumers",
        fields: %{
          user: %{
            type: ApiServer.Schema.User,
            args: %{id: %{type: %ID{}, description: "Unique user identifier"}},
            resolve: &get_user/3
          },
          update_user: %{
            type: ApiServer.Schema.User,
            args: %{
              id: %{
                type: %NonNull{ofType: %ID{}},
                description: "The id of the user to update"
              },
              name: %{type: %String{}, description: "The new username"}
            },
            resolve: &update_user/3
          }
        }
      }
    end

    def get_user(_source, %{id: id}, _info) do
      Repositories.User.find_by_id(id)
    end

    def update_user(_source, %{id: id} = user, _info) do
      payload = Map.drop(user, [:id])
      Repositories.User.update(id, payload)
    end
  end

  def schema() do
    %GraphQL.Schema{query: ApiServer.Schema.Query.type}
  end
end
