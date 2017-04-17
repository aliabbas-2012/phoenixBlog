export default class ChatOperations{
  constructor(channel) {
    this._channel = channel;
  }

  push_messages(channel,chatInput){
    this._channel.push("room_msg", {body:chatInput.val()});
    chatInput.val("");
  }

 renderMessage(message,messagesContainer){
  
    let msg_time = moment().format('hh:mm');
    let element_id = `typing-by-${message.sender_id}`
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
    messagesContainer.append(msg_html);
    //remove typing indication from sender
    $("#"+element_id).remove();
    //scroll to down
    $(messagesContainer).scrollTop(messagesContainer[0].scrollHeight)
  }

  renderUserTyping(message){
    console.log("---in user typing---");

    let element_id = `typing-by-${message.typing_by}`
    if($("#"+element_id).length==0){
      let msg_typing_html = `<small class="text-muted" id="${element_id}">${message.helping_text}</small>`
      if(message.status == 0){
        msg_typing_html = "";
      }
      $("#user_typing_status").append(msg_typing_html);
    }
  }

  // leaving room
  renderLeaveRoom(message){
     console.log("-----leaving ----room--")
     console.log(message)
     /*
     let msg_html =`<div class="item text-center">
       <div class="chat-box-left-room-line">
         <abbr class="left_room">
           <span class="fa fa-exclamation-triangle"></span>
           ${message.leaving_by} ${message.body}
         </abbr>

       </div>
     </div>`
     messagesContainer.append(msg_html);
     $(messagesContainer).scrollTop(messagesContainer[0].scrollHeight);
     */
  }
}
