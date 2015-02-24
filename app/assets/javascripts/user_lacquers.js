$(function(){

  $('.brands').click(function(e){
    e.preventDefault();
    e.stopPropagation();

    var brand = this.id
    $(this).toggleClass("selected");

    $("tr[brand='"+ brand +"']").toggleClass("selected");

    $("tr.selected").show();
    $('tr').not('.selected').hide();
    if ($('tr.selected').length === 0){
      $('tr').show();
    }

  });

  $('.colors').click(function(e){
    e.preventDefault();
    e.stopPropagation();

    var color = this.id
    $(this).toggleClass("selected");

    var selectedColors = []
    var unselectedColors = []
    $('.btn.colors.selected').each(function(){
      selectedColors.push(this.text);
    });

    $('.btn.colors').not('.selected').each(function(){
      unselectedColors.push(this.text);
    });

    $.each(unselectedColors, function(index, color){
      $("tr."+color).removeClass("selected");
    })

    $.each(selectedColors, function(index, color){
      //debugger;
      $("tr."+color).addClass("selected");
    })

    //debugger;
    //$("tr."+color).toggleClass("selected");
    $("tr.selected").show();
    $('tr').not('.selected').hide();
    if ($('tr.selected').length === 0){
      $('tr').show();
    }

  });

  $('#user-lacquers-by-brand').hide();
  $('#user-lacquers-by-name').hide();
  $('#user-lacquers-by-brand-reverse').hide();
  $('#user-lacquers-by-name-reverse').hide();
  var brandSorter = $('.sort#brand');
  var nameSorter = $('.sort#name');
  var brandSorterReverse = $('.sort#brand-reverse');
  var nameSorterReverse = $('.sort#name-reverse');
  //debugger;
  brandSorter.click(function(e){
    $('#user-lacquers-by-default').hide();
    $('#user-lacquers-by-name').hide();
    $('#user-lacquers-by-brand-reverse').hide();
    $('#user-lacquers-by-name-reverse').hide();
    $('#user-lacquers-by-brand').show();
  });
  nameSorter.click(function(e){
    e.stopPropagation();
    $('#user-lacquers-by-default').hide();
    $('#user-lacquers-by-brand').hide();
    $('#user-lacquers-by-brand-reverse').hide();
    $('#user-lacquers-by-name-reverse').hide();
    $('#user-lacquers-by-name').show();
  });
  brandSorterReverse.click(function(e){
    $('#user-lacquers-by-default').hide();
    $('#user-lacquers-by-brand').hide();
    $('#user-lacquers-by-name').hide();
    $('#user-lacquers-by-name-reverse').hide();
    $('#user-lacquers-by-brand-reverse').show();
  });
  nameSorterReverse.click(function(e){
    $('#user-lacquers-by-default').hide();
    $('#user-lacquers-by-brand').hide();
    $('#user-lacquers-by-name').hide();
    $('#user-lacquers-by-brand-reverse').hide();
    $('#user-lacquers-by-name-reverse').show();
  });
});


