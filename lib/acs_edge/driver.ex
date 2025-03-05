defmodule AcsEdge.Driver do
  use GenServer
  require Logger

  @type mqtt_client :: pid()

  @type t :: %__MODULE__{
          handler: module() when module() :: behaviour(AcsEdge.Driver.Handler),
          status: __MODULE__.Status.t(),
          addrs: map(),
          topics: map(),
          id: String.t(),
          mqtt_client: mqtt_client(),
          message_handlers: %{String.t() => (String.t() -> any())},
          reconnect: non_neg_integer(),
          reconnecting: boolean()
        }
  defstruct [
    :handler,
    :status,
    :addrs,
    :topics,
    :id,
    :mqtt_client,
    :message_handlers,
    reconnect: 5000,
    reconnecting: false
  ]

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def run(pid) do
    GenServer.cast(pid, :run)
  end

  @impl true
  def init(opts) do
    {:ok, %__MODULE__{}}
  end

  @impl true
  def handle_call(message, _from, state) do
    Logger.warning("Unexpected call message: #{inspect(message)}")
    {:reply, :error, state}
  end

  @impl true
  def handle_cast(:run, state) do
    {:noreply, state}
  end

  @impl true
  def handle_cast(message, state) do
    Logger.warning("Unexpected cast message: #{inspect(message)}")
    {:noreply, state}
  end

  @impl true
  def handle_info(message, state) do
    Logger.warning("Unexpected info message: #{inspect(message)}")
    {:noreply, state}
  end

  @impl true
  def terminate(reason, _state) do
    Logger.info("Terminating with reason: #{inspect(reason)}")
    :ok
  end
end
