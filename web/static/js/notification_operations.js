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
                      amount: 500, // (number)
                      from: 'top' // ('top', 'bottom')
                  },
                   type: 'info',
                   align: 'right',
                   delay: 0,
                   stackupSpacing: 30
        });
    });
  }
}
