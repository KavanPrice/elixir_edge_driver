defmodule AcsEdge.Driver.Status do
  @type t ::
          :down
          | :up
          | :conn
          | :auth
          | :ready
          | :conf
          | :addr
          | :other

  @spec to_string(t()) :: String.t()
  def to_string(status) do
    case status do
      :down -> "DOWN"
      :up -> "UP"
      :conn -> "CONN"
      :auth -> "AUTH"
      :ready -> "READY"
      :conf -> "CONF"
      :addr -> "ADDR"
      :other -> "OTHER"
    end
  end

  @spec from_string(String.t()) :: {:ok, t()} | {:error, String.t()}
  def from_string(str) do
    case str do
      "DOWN" -> {:ok, :down}
      "UP" -> {:ok, :up}
      "CONN" -> {:ok, :conn}
      "AUTH" -> {:ok, :auth}
      "READY" -> {:ok, :ready}
      "CONF" -> {:ok, :conf}
      "ADDR" -> {:ok, :addr}
      "OTHER" -> {:ok, :other}
      _ -> {:error, "Couldn't convert status #{inspect(str)} into valid atom."}
    end
  end
end
