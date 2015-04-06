$(function(){
  $('.toggle-users').click(function(){
    if ($(this).parent('.selected').length > 0) {
      //debugger;
      $(this).parent().removeClass('selected');
      $(this).parent().parent().siblings('.brand-lacquer-lovers').slideUp();
    } else {
      //debugger;
      $(this).parent().addClass('selected');
      $(this).parent().siblings().removeClass('selected');
      var self = this;
      $(this).parent().parent().siblings('.brand-favorites').slideUp(function(){
        $(self).parent().parent().siblings('.brand-lacquer-lovers').slideDown();
      });


    }

  })

  $('.toggle-favorites').click(function(){
    if ($(this).parent('.selected').length > 0) {
      //debugger;
      $(this).parent().removeClass('selected');
      $(this).parent().parent().siblings('.brand-favorites').slideUp();
    } else {
      //debugger;
      $(this).parent().addClass('selected');
      $(this).parent().siblings().removeClass('selected');
      var self = this;
      $(this).parent().parent().siblings('.brand-lacquer-lovers').slideUp(function(){
        $(self).parent().parent().siblings('.brand-favorites').slideDown();
      })
    }
    
  })
})
