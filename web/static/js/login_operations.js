import {Presence} from "phoenix"
export default class LoginOperations{

   constructor(channel) {
     this._channel = channel;
   }


   renderLeaveLoginRoom(message) {
      console.log("-----leaving ----login room--")
      console.log(message)

   }

   static formatTimestamp(timestamp) {
     let date = new Date(timestamp)
     return date.toLocaleTimeString()
   }

    static listBy(user, {metas: metas}) {
     return {
       user: user,
       onlineAt: this._formatTimestamp(metas[0].status_at)
     }
   }

   static user_status_class(status)  {
       switch(status.toLowerCase()) {
          case "online": {
            return "fa fa-circle text-success"
          }
          case "busy": {
             return "fa fa-circle text-red"
             break;
          }
          default: {
             return "fa fa-circle text-yellow"
             break;
          }
       }
   }

   render_presence(presences){
     console.log("========presence==========");

     let online_list = Presence.list(presences, this._listBy);
    //  debugger;
     let that = this;
    //  console.log(that.constructor.user_status_class(presence.metas[0].status));

     $("ul.friend-list li").each(function(){
        if(typeof(presences[$(this).find("a.clearfix").attr('data_user_id')])!="undefined"){

         let presence = presences[$(this).find("a.clearfix").attr('data_user_id')];

          //for case only message
          $(this).find("small.chat-alert-status").find("i").attr("class",that.constructor.user_status_class(presence.metas[0].status));
          $(this).find("small.chat-alert-status").find("i").attr("title",presence.metas[0].status.toCapitalize() );

        }
        else {
          $(this).removeClass("active");

          $(this).find("small.chat-alert-status").find("i").attr("class","fa fa-circle text-yellow");
          $(this).find("small.chat-alert-status").find("i").attr("title","Offline");
        }
     })

     console.log("=======end presence=======");
   }

} // no semicolon!
