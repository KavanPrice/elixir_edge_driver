defmodule ElixirEdgeDriver.Application do
  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    driver_opts = %{
      edge_username: Application.get_env(:elixir_edge_driver, :edge_username),
      edge_password: Application.get_env(:elixir_edge_driver, :edge_password),
      edge_mqtt: Application.get_env(:elixir_edge_driver, :edge_mqtt),
      reconnect: Application.get_env(:elixir_edge_driver, :reconnect)
    }

    children = [
      {Tortoise311.Supervisor, []},
      {AcsEdge.Driver, driver_opts}
    ]

    opts = [
      strategy: :one_for_one,
      name: ElixirEdgeDriver.Supervisor
    ]

    Logger.info("Starting ElixirEdgeDriver application")
    Supervisor.start_link(children, opts)
  end
end
