$(document).ready(function(){
  //debugger;
  var currentUrl = window.location.href;
  var lacquerCards = $('.col-md-3.lacquer')
  var brandID = currentUrl.substr(currentUrl.lastIndexOf('/') + 1);
  lacquerCards.each(function(){
    var id = this.id;
    $.ajax({
      type: "GET",
      url: "/brands/"+brandID+"/lacquers/"+id
    });
  });
  checkboxListener();
});

function checkboxListener() {
  $(document).on("click", "label", function() {
    console.log("clicked");
    var $checkBox = $(this).prevAll(":checkbox")
    var $lacquerBox = $checkBox.parents(".col-md-3.lacquer");
    var $panel = $lacquerBox.find(".panel-body");
    if(!$checkBox[0].checked) {
        $panel.css("background-color", "#ede0f3");
    }
    else {
      $panel.css("background-color", "");
    }
  });
}