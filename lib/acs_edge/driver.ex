defmodule AcsEdge.Driver do
  use GenServer
  require Logger

  @typedoc """
  Internal representation of a driver.
  """
  @type t :: %__MODULE__{
          handler: module(),
          status: __MODULE__.Status.t(),
          addrs: map(),
          topics: map(),
          id: String.t(),
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
    :message_handlers,
    reconnect: 5000,
    reconnecting: false
  ]

  defmodule __MODULE__.Options do
    @typedoc """
    Options passed to a driver.
    """
    @type t :: %__MODULE__{
            edge_username: String.t(),
            edge_password: String.t(),
            edge_mqtt: String.t(),
            handler: module(),
            reconnect: non_neg_integer()
          }
    defstruct [
      :edge_username,
      :edge_password,
      :edge_mqtt,
      :handler,
      :reconnect
    ]
  end

  @spec start_link(__MODULE__.Options.t()) :: GenServer.on_start()
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  @impl true
  def init(opts) do
    driver = %{
      handler: opts.handler,
      status: :down,
      addrs: %{},
      topics: %{},
      id: opts.edge_username,
      message_handlers: %{},
      reconnect: opts.reconnect,
      reconnecting: false
    }

    case Tortoise311.Connection.start_link(
           client_id: driver.id,
           server: {Tortoise311.Transport.Tcp, host: opts.edge_mqtt, port: 1883},
           handler: {Tortoise311.Handler.Logger, []},
           will: %Tortoise311.Package.Publish{
             topic: topic(driver, "status"),
             payload: AcsEdge.Driver.Status.to_string(:down)
           },
           user_name: driver.id,
           password: opts.edge_password
         ) do
      {:ok, _} ->
        Logger.info("Driver connected to northbound broker.")
        {:ok, driver}

      :ignore ->
        :ignore

      {:error, reason} ->
        Logger.error("Driver couldn't connect to northbound broker: #{inspect(reason)}")
        {:stop, reason}
    end
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

  @spec topic(term(), String.t(), String.t()) :: String.t()
  def topic(state, msg, data) do
    "#{topic(state, msg)}/#{data}"
  end

  @spec topic(term(), String.t()) :: String.t()
  def topic(state, msg) do
    "fpEdge1/#{state.id}/#{msg}"
  end
end
