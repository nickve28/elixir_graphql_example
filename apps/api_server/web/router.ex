defmodule ApiServer.Router do
  use ApiServer.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api" do
    pipe_through :api

    forward "/", GraphQL.Plug, schema: {ApiServer.UserSchema, :schema}
  end
end
