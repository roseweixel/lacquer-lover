$(function(){
  $('#new_review_link_wrapper').on('click', '#new-review-link', function(e){
    e.stopPropagation();
    e.preventDefault();

    $('#hidden-review-modal-link').click();
  });
})
