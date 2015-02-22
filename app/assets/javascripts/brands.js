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
  })
});