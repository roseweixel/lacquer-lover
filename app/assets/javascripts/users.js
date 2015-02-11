$(document).ready(function() {
  var currentUrl = window.location.href;
  var userID = currentUrl.substr(currentUrl.lastIndexOf('/') + 1);
  setInterval(function(){
    $.ajax({
      type: "GET",
      url: "/users/"+userID+"/live_notifications"
    });
  }, 3000);
});
