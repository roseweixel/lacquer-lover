$(function(){
  $(document).on('mouseenter', '.highlight', function(){
    if ($(this).attr('id') === "see-brands") {
      $('#see-the-brands').addClass('highlighted');
    } else if ($(this).attr('id') === "find-lacquer") {
      $('#find-a-lacquer').addClass('highlighted');
    } else if ($(this).attr('id') === "brand-show-sign-in") {
      $('#sign_in').addClass('highlighted');
    } else if ($(this).attr('id') === "find-lacquer-lover") {
      if ($('#find-a-lacquer-lover').size() > 0) {
        $('#find-a-lacquer-lover').addClass('highlighted');
      } else {
        $('#find-a-lacquer').parent().after('<li class="dropdown"><a href="#" class="highlighted dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false", id="stubbed-find-a-lacquer-lover">Find a Lacquer Lover <span class="caret"></span></a><ul class="dropdown-menu"><li></li></ul></li>');
      }
    }
  });
  $(document).on('mouseout', '.highlight', function(){
    if ($(this).attr('id') === "see-brands") {
      $('#see-the-brands').removeClass('highlighted');
    } else if ($(this).attr('id') === "find-lacquer") {
      $('#find-a-lacquer').removeClass('highlighted');
    } else if ($(this).attr('id') === "brand-show-sign-in") {
      $('#sign_in').removeClass('highlighted');
    } else if ($(this).attr('id') === "find-lacquer-lover") {
      if ($('#find-a-lacquer-lover').size() > 0) {
        $('#find-a-lacquer-lover').removeClass('highlighted');
      } else {
        $('#stubbed-find-a-lacquer-lover').remove();
      }
    }
  });

  $('.contact-link').click(function(e){
    e.stopPropagation();
    e.preventDefault();

    $('#hidden-contact-modal-link').click();
  });

  $('#new-invite-link').click(function(e){
    e.stopPropagation();
    e.preventDefault();

    $('#hidden-invite-modal-link').click();
  });

  $(document).on('mouseenter mouseleave', '#add-lacquers', function(){
    $('img#profile').toggle();
    $('img#profile-add-lacquers').toggle();

  });

  $(document).on('mouseenter mouseleave', '#add-friends', function(){
    $('img#profile').toggle();
    $('img#profile-add-friends').toggle();

  });

  $(document).on('mouseenter mouseleave', '#make-loanable', function(){
    $('img#profile').toggle();
    $('img#profile-make-loanable').toggle();

  });

  $(document).on('mouseenter mouseleave', '#borrow-it', function(){
    $('img#profile').toggle();
    $('img#profile-borrow-it').toggle();

  });
});
