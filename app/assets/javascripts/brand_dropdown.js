$(function(){
	$('.lacquer-dropdown').hide();
    $('.other-lacquer').hide();
    $('#brand-selection').change(function(event){
        event.stopPropagation();
        var brand = $(this).val();
        $('.lacquer-dropdown').hide();
        $('.other-lacquer').hide();
        $('.add-lacquer').addClass("disabled");
        if(brand == "OPI") {
            $('#opi-dropdown').show();
        } else if(brand == "Essie") {
            $('#essie-dropdown').show();
        } else if(brand == "Butter London") {
            $('#butter-dropdown').show();
        } else if(brand == "Deborah Lippmann") {
        	$('#deborah-dropdown').show();
        };
    });

    $('.lacquer-dropdown').change(function(event){
        event.stopPropagation();
        $('.other-lacquer').hide();
        var brand = $('#brand-selection').val();
        var lacquerID = $(this).find("select").val();
        if(lacquerID == "") {
            $('.add-lacquer').addClass("disabled");
        } else if(lacquerID == "new") {
            if(brand == "OPI") {
                $('.other-lacquer#opi').show();
            } else if(brand == "Essie") {
                $('.other-lacquer#essie').show();
            } else if(brand == "Butter London") {
                $('.other-lacquer#butter').show();
            } else if(brand == "Deborah Lippmann") {
                $('.other-lacquer#deborah').show();
            }
            $('.add-lacquer').addClass("disabled");
        } else {
            $('.add-lacquer').removeClass("disabled");
        }
    });
    


    // $('.finish-dropdown').click(function(event){

    //     $('#finish-dropdown').toggle();

    // });

    $('.page-header').on("click", '.dropdown-menu', function(event){
        event.stopPropagation();
        $('this').show();

    });


});