$(function(){
  $('form').on('change', '#email-options', function(){
    if ($(this).val() === "other email address") {
      $('input#other_reply_address').show();
    } else {
      $('input#other_reply_address').hide();
    }
  });

  $('form').on('change', '#subject-options', function(){
    if ($(this).val() === "other") {
      $('input#other_subject').show();
      $("input#other_subject").prop('required',true);
    } else {
      $('input#other_subject').hide();
      $("input#other_subject").prop('required',false);
    }
  });
})
