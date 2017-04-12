// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":


import {Socket,Presence} from "phoenix"

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

// Presence of user


// Now that you are connected, you can join channels with a rooms:
//I defined harded coded room lobby

//only room specific chat

const createSocket = (roomId,authToken) => {

  let presences = {}

  let formatTimestamp = (timestamp) => {
    let date = new Date(timestamp)
    return date.toLocaleTimeString()
  }

  let listBy = (user, {metas: metas}) => {
    return {
      user: user,
      onlineAt: formatTimestamp(metas[0].online_at)
    }
  }

  let render_presence = (presences) => {
    console.log("------presence-------");

    let online_list = Presence.list(presences, listBy);
    console.log(presences);
    $("ul.friend-list li").each(function(){
       if(typeof(presences[$(this).find("a.clearfix").attr('data_user_id')])!="undefined"){
         $(this).addClass("active");
         $(this).find("i.text-login-status").removeClass("text-yellow").addClass("text-success");
         $(this).find("i.text-login-status").attr("title","Online");
       }
       else {
         $(this).removeClass("active");
         $(this).find("i.text-login-status").removeClass("text-success").addClass("text-yellow");
         $(this).find("i.text-login-status").attr("title","Offline");
       }
    })

    console.log("------end presence-------");
  }

  let channel = socket.channel(`rooms:${roomId}`, {auth_token: authToken})
  console.log("------channel-------");
  console.log(channel);

  channel.on("presence_state", state => {
    presences = Presence.syncState(presences, state)
    console.log("--in state--");
    console.log(presences);
    render_presence(presences)
  })

  channel.on("presence_diff", diff => {
    presences = Presence.syncDiff(presences, diff)
    console.log("--in diff--");
    render_presence(presences)
  })


  //error call back
  //channel.onError(e =>    window.location.href = "/auth-token-verification/");

  channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })


  let chatInput = $("#chat-input");
  let button_enter = $("#broad_cast_chat");
  let messagesContainer = $("#chat-box");



  const push_messages = (channel,chatInput) => {
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


  let renderMessage = (message) => {
    console.log(message);
    let msg_time = moment().format('hh:mm');
    let msg_html = `<div class="item">
              <img src="${message.sender_logo}" class="online" alt="User Image">

              <p class="message">
                <a href="javascript:void(0);" class="name">
                  <small class="text-muted pull-right"><i class="fa fa-clock-o"></i> ${msg_time}</small>
                  ${message.sender}
                </a>
                ${message.body}
              </p>
          </div>`
    // messagesContainer.append(`<br/>[${today}] ${message.body}`)
    messagesContainer.append(msg_html);
    //scroll to bottom
    // $("body, html").animate({
    //     scrollTop: $(document).height()
    // }, 400);

    //messagesContainer.scrollTop = messageList.scrollHeight;
  }
  //render messages call
  channel.on("room_msg", message => renderMessage(message))

}

window.createSocket = createSocket;

// export default socket
