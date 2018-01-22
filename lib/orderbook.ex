defmodule OrderbookResponse do
  defstruct [:event, :data]
end

defmodule OrderBookDataChannelResponse do
  defstruct [:channel, :data]
end

defmodule OrderBookDataResponse do
  defstruct [:bids, :asks]
end