# Orderbook

{:ok, pid} = Wsclient.start_link
Wsclient.sub(pid, "order_book_btceur")
Wsclient.unsub(pid, "order_book_btceur")

{:ok, pid2} = Wsclient.start_link
Wsclient.sub(pid2, "order_book_btceur")
Wsclient.unsub(pid2, "order_book_btceur")