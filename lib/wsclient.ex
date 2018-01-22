defmodule Wsclient do
  use WebSockex
  require Logger
  require IEx

  def start_link(opts \\ []) do
    WebSockex.start_link("ws://ws.pusherapp.com/app/de504dc5763aeef9ff52?protocol=7", __MODULE__, :fake_state, opts)
  end

  def handle_connect(_conn, state) do
   Logger.info("Connected")
   {:ok, state}
  end

  def handle_frame({_type, msg}, state) do
    # IO.puts "Raw: Received Message - Type: #{inspect type} -- Message: #{inspect msg}"

    data = Poison.decode!(msg)
    Logger.info("Pid: #{inspect self()}: Event triggered: #{inspect data["event"]}")
    case data["event"] do
      "data" ->
        channel_name = data["channel"]
        order_book_response = Poison.decode!(data["data"], as: %OrderBookDataResponse{})

        Logger.info("Channel #{inspect channel_name}")
        Logger.info("Bids: #{order_book_response.bids}")
        Logger.info("Asks: #{order_book_response.asks}")
        
      _ ->
        Logger.info("Unhanndeled event #{inspect data["event"]}")
    end

    {:ok, state}
  end

  def handle_disconnect(%{reason: {:local, reason}}, state) do
    Logger.info("Local close with reason: #{inspect reason}")
    {:ok, state}
  end

  def handle_disconnect(disconnect_map, state) do
    super(disconnect_map, state)
  end

  def sub(client_pid, channel) do
    data = %{
      "event" => "pusher:subscribe",
      "data" => %{
        "channel" => channel
      }
    }
    send_event(client_pid, data)
  end

  def unsub(client_pid, channel) do
    data = %{
      "event" => "pusher:unsubscribe",
      "data" => %{
        "channel" => channel
      }
    }
    send_event(client_pid, data)
  end
  
  def send_event(client_pid, data) do
    json = Poison.encode!(data)
    Logger.info("Sending to pid: #{inspect client_pid} with data #{inspect data}")
    WebSockex.send_frame(client_pid, {:text, json})
  end
end
