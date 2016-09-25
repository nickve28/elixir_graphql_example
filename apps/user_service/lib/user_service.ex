defmodule UserService do
  import Supervisor.Spec, warn: false

  def start(_type, _args) do
    children = [
      worker(UserService.Repositories.User, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UserService.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
