import Config

config :elixir_edge_driver,
  edge_username: System.get_env("EDGE_USERNAME"),
  edge_password: System.get_env("EDGE_PASSWORD"),
  edge_mqtt: System.get_env("EDGE_MQTT", "localhost"),
  reconnect_interval: 5000
