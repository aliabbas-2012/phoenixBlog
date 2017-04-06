defmodule BlogTest.UserSocket do
  use Phoenix.Socket
  alias BlogTest.Repo
  alias BlogTest.AuthorizeToken

  ## Channels (example)
  channel "rooms:*", BlogTest.RoomChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(%{"auth_token"=>auth_token} = params, socket) do
    IO.puts "----connection--------"

    #verifying token is correct and assigning to socket
    case Repo.get_by(AuthorizeToken, token:  auth_token)  do
      nil ->
         :error
      auth ->
        IO.puts "ali here"
        {:ok, assign(socket, :auth, auth)}
    end

  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "users_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     BlogTest.Endpoint.broadcast("users_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil

end
