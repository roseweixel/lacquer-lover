$(function(){
  $('input.other-email').hide();
  $('form').on('change', '#email-options', function(){
    if ($(this).val() === "other email address") {
      $('input.other-email').show();
    } else {
      $('input.other-email').hide();
    }
  })
})
