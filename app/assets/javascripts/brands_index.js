$(function(){
  $('.toggle-users').click(function(){
    if ($(this).parent('.selected').length > 0) {
      $(this).parent().removeClass('selected');
      $(this).parent().parent().siblings('.brand-lacquer-lovers').slideUp();
    } else {
      $(this).parent().addClass('selected');
      $(this).parent().siblings().removeClass('selected');
      var self = this;
      if ($(this).parent().parent().siblings('.brand-favorites').length > 0) {
        $(this).parent().parent().siblings('.brand-favorites').slideUp(function(){
          $(self).parent().parent().siblings('.brand-lacquer-lovers').slideDown();
        });
      } else {
        $(self).parent().parent().siblings('.brand-lacquer-lovers').slideDown();
      }
    }
  })

  $('.toggle-favorites').click(function(){
    if ($(this).parent('.selected').length > 0) {
      $(this).parent().removeClass('selected');
      $(this).parent().parent().siblings('.brand-favorites').slideUp();
    } else {
      $(this).parent().addClass('selected');
      $(this).parent().siblings().removeClass('selected');
      var self = this;
      if ($(this).parent().parent().siblings('.brand-lacquer-lovers').length > 0){
        $(this).parent().parent().siblings('.brand-lacquer-lovers').slideUp(function(){
          $(self).parent().parent().siblings('.brand-favorites').slideDown();
        })
      } else {
          $(self).parent().parent().siblings('.brand-favorites').slideDown();
      }
    }
  })
})
