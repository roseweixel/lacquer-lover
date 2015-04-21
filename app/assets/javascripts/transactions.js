$(function(){
  $('.toggle-form input').hide();
  $(document).on('click', '.toggle-form-label', function(){
    $(this).siblings('input').slideToggle();
  });
});

