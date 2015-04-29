$(function(){
  // $('#other_reply_address').hide();
  $('form').on('change', '#email-options', function(){
    if ($(this).val() === "other email address") {
      $('input#other_reply_address').show();
    } else {
      $('input#other_reply_address').hide();
    }
  })
})
