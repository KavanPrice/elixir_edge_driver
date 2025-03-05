defmodule AcsEdge.Driver.Handler do
  @moduledoc """
  This module defines the behaviour required for a handler module with
  callbacks used by the parent driver.
  """

  @doc """
  Used to validate the the passed configuration `config`.

  Returns `{:ok, {driver, config}}` if `config` was successfully validated or
  `{:error, reason}` otherwise.
  """
  @callback create(driver :: pid(), config :: map()) ::
              {:ok, {pid(), map()}} | {:error, String.t()}

  @doc """
  Used to initiate connection to the southbound device.

  Returns `{:ok, ConnectionStatus.t()}` if successful. Otherwise returns
  `{:error, reason}`.
  """
  @callback connect(state :: term()) :: {:ok, String.t()} | {:error, String.t()}

  @doc """
  Used to obtain a set of valid addresses as strings.

  Returns `{:ok, addresses}` if successful. Otherwise returns
  `{:error, reason}`.
  """
  @callback valid_addrs() :: {:ok, MapSet.t(String.t())} | {:error, String.t()}

  @doc """
  Used to parse an address string and return a data structrue suitable for the
  `Handler`. This can be called before `Handler.connect()`.
  """
  @callback parse_addr(addr :: String.t()) :: {:ok, term()} | :error

  @doc """
  Called whenever the northbound edge agent has changed the list of addresses
  it is interested in.

  The passed `specs` is a list of terms as returned from
  `Handler.parse_addr()`.

  Returns a map of `:ok` or `:error` for each term.
  """
  @callback subscribe(specs :: [term()], state :: term()) ::
              %{term() => :ok | {:error, String.t()}}

  @doc """
  Called when a new configuration is received. This should perform any cleanup needed before reconnecting.
  """
  @callback close(state :: term()) :: :ok

  @optional_callbacks [
    valid_addrs: 0,
    parse_addr: 1,
    subscribe: 2,
    close: 1
  ]
end

defmodule AcsEdge.Driver.Handler.ConnectionStatus do
  @moduledoc """
  This module defines the status for the connection between the `Handler` and
  the southbound device.
  """

  @type t() ::
          :up
          | :conn
          | :auth

  @doc """
  Convert a connection status to a string.
  """
  @spec to_string(t()) :: String.t()
  def to_string(status) do
    case status do
      :up -> "UP"
      :conn -> "CONN"
      :auth -> "AUTH"
    end
  end

  @doc """
  Attempt to convert a string to a valid connection status.

  Return `{:ok, status}` on success or `{:error, reason}` on failure.
  """
  @spec from_string(String.t()) :: {:ok, t()} | {:error, String.t()}
  def from_string(str) do
    case str do
      "UP" -> {:ok, :up}
      "CONN" -> {:ok, :conn}
      "AUTH" -> {:ok, :auth}
      _ -> {:error, "Couldn't convert status #{inspect(str)} into valid atom."}
    end
  end
end
