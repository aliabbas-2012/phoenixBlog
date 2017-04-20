export default class NotificationOperations{
  constructor(channel) {
    this._channel = channel;
  }

  // leaving room
  renderLeaveLoginRoom(message){
     console.log("-----leaving ----notification--")
     console.log(message)

  }
  renderNotifications(message){
    console.log("----notification---history------")
    console.log(message)
    $.each(message['notifications'], function( index, value ) {
        console.log(value);
        $.bootstrapPurr(value.content, {
                  offset: {
                      amount: $(window).height(), // (number)
                      from: 'top' // ('top', 'bottom')
                  },
                   type: 'info',
                   align: 'right',
                   delay: 0,
                   stackupSpacing: 30
        });
    });
  }

  renderNotificationAlert(message){
    console.log("----notification---alert------")
    console.log(message)
    //only the case when user is not in the room
    if($("div.room_container[data-room-id='" + message.room_id +"']").length==0 && !message.is_seen){
      $.bootstrapPurr(message.body, {
                offset: {
                    amount: 50, // (number)
                    from: 'bottom' // ('top', 'bottom')
                },
                 type: 'info',
                 align: 'right',
                 sender: message.sender,
                 sender_id: message.sender_id,
                //  delay: 0,
                 stackupSpacing: 30,
                 width: 300,
                 room_id: message.room_id,
      });
    }
  }
}
