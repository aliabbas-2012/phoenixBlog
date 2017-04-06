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

const token = $('meta[name="auth_token"]').attr('content');
let socket = new Socket("/socket", {params: {token: token,calling_name: calling_name}})

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

//only room specific chat

const createSocket = (roomId,authToken) => {
  let channel = socket.channel(`rooms:${roomId}`, {auth_token: authToken})
  console.log(channel)
  channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })


  let chatInput = $("#chat-input");
  let button_enter = $("#broad_cast_chat");
  let messagesContainer = $("#chat-box");
  function push_messages(channel,chatInput){
    // UI Stuff
    channel.push("room_msg", {body:chatInput.val()});
    chatInput.val("");
  }


  chatInput.on("keypress", event => {

    if(event.keyCode === 13){
      push_messages(channel,chatInput);
    }
  });

  button_enter.on("click", event => {
    push_messages(channel,chatInput);
  });


  channel.on("room_msg", message => {
    console.log(message);
    // let today = moment().format('MM/DD/YYYY hh:mm:ss');
    let msg_time = moment().format('hh:mm');
    let msg_html = `<div class="item">
              <img src="/images/admin_lte/user3-128x128.jpg" class="offline" alt="User Image">

              <p class="message">
                <a href="javascript:void(0);" class="name">
                  <small class="text-muted pull-right"><i class="fa fa-clock-o"></i> ${msg_time}</small>
                  ${message.calling_name}
                </a>
                ${message.body}
              </p>
          </div>`
    // messagesContainer.append(`<br/>[${today}] ${message.body}`)
    messagesContainer.append(msg_html);
  })
}

window.createSocket = createSocket;

export default socket
