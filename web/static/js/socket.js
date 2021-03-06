// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":


import {Socket} from "phoenix"

// let first defined name of person who wants to chat
let calling_name = localStorage.getItem("call_name");
if (!calling_name){
  calling_name = prompt("What is name you are going to use for chat ?")
  localStorage.setItem("call_name",calling_name)
}

let socket = new Socket("/socket", {params: {token: window.userToken,calling_name: calling_name}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

socket.connect()

// Now that you are connected, you can join channels with a rooms:
//I defined harded coded room lobby
let channel = socket.channel("rooms:lobby", {})
console.log(channel)
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })




// UI Stuff
let chatInput = $("#chat-input");
let messagesContainer = $("#chat-box");
let button_enter = $("#broad_cast_chat")

chatInput.on("keypress", event => {

  if(event.keyCode === 13){
    channel.push("room_msg", {body:chatInput.val()});
    chatInput.val("");
  }
});

button_enter.on("click", event => {
    channel.push("room_msg", {body:chatInput.val()});
    chatInput.val("");
});


channel.on("room_msg", payload => {

  let today = moment().format('MM/DD/YYYY hh:mm:ss');
  messagesContainer.append(`<br/>[${today}] ${payload.body}`)
})


export default socket
