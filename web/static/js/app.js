
// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
import "phoenix_ujs";

//other code
String.prototype.toCapitalize = function(){
   return this.toLowerCase().replace(/^.|\s\S/g, function(a) { return a.toUpperCase(); });
}

String.prototype.isEmpty = function(){
   return $.trim(this) =="" ? true : false
}
String.prototype.isNotEmpty = function(){
   return $.trim(this) =="" ? 0 : 1
}

var elements = document.querySelectorAll('[data-submit^=parent]')
var len = elements.length



for (var i=0; i<len; ++i) {
  elements[i].addEventListener('click', function(event){
    var message = this.getAttribute("data-confirm")
    if(message === null || confirm(message)){
      this.parentNode.submit()
    };
    event.preventDefault()
    return false
  }, false)
}
// ADD adresses
$(document).ready(function() {
  $(document).on("click","#add_address",function(e) {

      e.preventDefault();

    let time = new Date().getTime()
    let template = $(this).data('template');
    console.log(template);
    var uniq_template = template.replace(/\[0]/g, `[${time}]`)
    uniq_template = uniq_template.replace(/_0_/g, `_${time}_`)
    $("div.panel.panel-primary.addresses").append(uniq_template);

  })
  //Remove address
  $(document).on("click",".remove_address",function(e) {
      e.preventDefault();
      $(this).closest("div.panel-body").remove();
  })

  // change user room
  $(document).on("click","a.change_user_room", event => {
      console.log(event.currentTarget);
      const csrf = $('meta[name="csrf-token"]').attr('content');
      const link = $(event.currentTarget).attr('data_href');
      $.ajax(link, {
          headers: {
            "X-CSRF-TOKEN": csrf
          },
          data: {
              "_csrf_token": csrf,
          },
          type:"post",
          //dataType: "json",
          success: function(data) {
            $("#chat_room").html(data);
            window.createSocket($("input#room_id").val(),$("input#auth_token").val());
            let messagesContainer = $("#chat-box");
            $(messagesContainer).scrollTop(messagesContainer[0].scrollHeight)
          },
          error: function() {

          }
      });

  });


});

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

//only the case when user is login

import socket from "./socket"
