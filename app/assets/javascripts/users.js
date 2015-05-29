// This is necessary just for Safari and other incompatible browsers
String.prototype.endsWith = function(suffix) {
    return this.indexOf(suffix, this.length - suffix.length) !== -1;
};

$(function() {
    var currentUrl = window.location.href;
    var userID = currentUrl.substr(currentUrl.lastIndexOf('/') + 1);
    if (userID.match("top") !== null) {
        userID = currentUrl.match(/\d*(?=#top)/)
    }

    if (currentUrl.endsWith('/users/' + window.currentUser.id)) {
        setInterval(function() {
            if (!$('#transaction_due_date').is(":focus")){
                $.ajax({
                type: "GET",
                url: "/users/"+userID+"/live_notifications"
                });
            }
        }, 5000); 
    }

    var userLacquerRows = $('.user-lacquer-partial')
    userLacquerRows.each(function() {
        var id = this.id;
        $.ajax({
          type: "GET",
          url: "/users/"+userID+"/user_lacquers/"+id,
          data: {user_id: userID},
        });
    });

    $("a[href='#top']").click(function(e) {
        e.preventDefault();
        $("html, body").animate({ scrollTop: 0 });
    });

    $('#show').hide();

    $('.well').on('click', '#hide', function() {
        $('.user-dashboard').slideUp();
        $('#show').show();
    });

    $('.well').on('click', '#show', function() {
        $('.user-dashboard').slideDown();
        $('#show').hide();
    });

    $('.fa-minus').hide();
    $('.list-group.toggleable').hide();
    $('span[category_count=0]').hide();
    $('.badge[value=0]').hide();
    $('legend').on('click', '.fa-minus', function() {
        $(this).siblings('.due-date-updated').addClass('hidden');
        $(this).parent().find('.tracker').removeClass("red-background");
        $(this).siblings('.fa-plus').show();
        $(this).siblings().children('.badge').show();
        $(this).hide();
        $(this).parent().next('ul').slideUp();
        $('.badge[value=0]').hide();
    });

    $('legend').on('click', '.fa-plus', function() {
        $(this).parent().find('.tracker').removeClass("red-background");
        $(this).siblings('.fa-minus').show();
        $(this).siblings().children('.badge').hide();
        $(this).siblings('.due-date-updated').addClass('hidden');
        $(this).hide();
        $(this).parent().next('ul').slideDown();
        $('.badge[value=0]').hide();
    });

    $(document).on('click', 'a.addswatch', function() {
        $(this).parents('form').children('.swatchfields').fadeToggle();
    });

});
