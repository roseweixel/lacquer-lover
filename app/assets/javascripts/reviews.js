$(function(){
  $('#new-review-link').click(function(e){
    e.stopPropagation();
    e.preventDefault();

    $('#hidden-review-modal-link').click();
  });
})
