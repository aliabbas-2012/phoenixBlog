// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":


import {Socket,Presence} from "phoenix"
import LoginOperations from "./login_operations"
import NotificationOperations from "./notification_operations"
import ChatOperations from "./chat_operations"

// let first defined which is user is online

const auth_token = $('meta[name="auth_token"]').attr('content');
console.log("--auth_token--");
console.log(auth_token);

let socket = new Socket("/socket", {params: {token: auth_token}})



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

// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

socket.connect()

// Presence of user

const createLoginSocket = (authToken) => {
    let statusInput = $("div.btn-group-status.btn-group button")
    let channel = socket.channel(`login:room`, {auth_token: authToken})
    let login_op = new LoginOperations(channel);


    let presences = {}
    channel.join()
      .receive("ok", resp => { console.log("Joined Login successfully", resp) })
      .receive("error", resp => { console.log("Unable Login to join", resp); socket.disconnect(); })

    channel.on("leave_login_room", message => login_op.renderLeaveLoginRoom(message))
    channel.on("presence_state", state => {
      presences = Presence.syncState(presences, state)
      console.log("--in state--");
      console.log(presences);
      login_op.render_presence(presences)
    })

    channel.on("presence_diff", diff => {
      presences = Presence.syncDiff(presences, diff)
      console.log("--in diff--");
      login_op.render_presence(presences)
    })

    statusInput.on("click",(event)=> {
       //event.preventDefault();
       console.log("------pushing  status -----");
       $("div.current-login-status>a").html( `<i class="${user_status_class($(event.currentTarget).attr("title"))}"></i> ${$(event.currentTarget).attr("title").toCapitalize()}`)
       channel.push('new_status', { status: $(event.currentTarget).attr("title") });
    })

}
//notification channel
const createNotificationSocket = (authToken) => {
    let channel = socket.channel(`notification:room`, {auth_token: authToken})

    let notify_op = new NotificationOperations(channel);

    channel.join()
      .receive("ok", resp => { console.log("Joined Notification successfully", resp) })
      .receive("error", resp => { console.log("Unable Notification to join", resp); socket.disconnect(); })


    //render notification history
    channel.on("notification_history", message => notify_op.renderNotifications(message))

    // channel.on("leave_notification_room", message => notify_op.renderLeaveLoginRoom(message))

}
//only room specific chat
//room socket
const createSocket = (roomId,authToken) => {

  let channel = socket.channel(`rooms:${roomId}`, {auth_token: authToken});
  let chat_op = new ChatOperations(channel);
  console.log("------room--channel-------");

  //error call back
  //channel.onError(e =>    window.location.href = "/auth-token-verification/");

  channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp); socket.disconnect(); })


  let chatInput = $("#chat-input");
  let button_enter = $("#broad_cast_chat");
  let messagesContainer = $("#chat-box");

  chatInput.on("keypress", event => {

    if(event.keyCode === 13){
      chat_op.push_messages(channel,chatInput);
    }
    else {

      channel.push('user_typing', { status: chatInput.val().isNotEmpty() });
    }
  });
  // #send message
  button_enter.on("click", event => {
    chat_op.push_messages(channel,chatInput);
  });

  //render messages call
  channel.on("room_msg", message => chat_op.renderMessage(message,messagesContainer))
  channel.on("user_typing", message => chat_op.renderUserTyping(message))
  channel.on("leave_room", message => chat_op.renderLeaveRoom(message))

}
window.createLoginSocket = createLoginSocket;
window.createNotificationSocket = createNotificationSocket;
window.createSocket = createSocket;

export default socket
