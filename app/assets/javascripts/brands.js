$(document).ready(function(){

  $('.fa').hide();
  var currentUrl = window.location.href;
  var lacquerCards = $('.col-md-3.lacquer');
  var brandID = currentUrl.substr(currentUrl.lastIndexOf('/') + 1);
  lacquerCards.each(function(){
    var id = this.id;
    $.ajax({
      type: "GET",
      url: "/brands/"+brandID+"/lacquers/"+id
    }).done(function(){
      $('.fa').hide();
    });
  });

  if ($('.col-md-3.lacquer').children().length !== $('.col-md-3.lacquer').length) {
    setInterval(function(){
      if ($('.col-md-3.lacquer').children().length === $('.col-md-3.lacquer').length) {
        $('.fa').show();
      }
    }, 3000); 
  }
  checkboxListener();
  signinListener();
});

function checkboxListener() {
  $(document).on("click", "label", function() {
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

function signinListener() {
  $(document).on("click", "#brand-show-sign-in", function(e){
    e.stopPropagation();
    e.preventDefault();
    $('#sign_in').click();
  })
}
