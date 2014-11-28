$(function(){
	$('.lacquer-dropdown').hide();
    $('#brand-selection').change(function(event){
        var brand = $(this).val();
        // $('.lacquer-dropdown').hide();
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
        var lacquerID = $(this).find("select").val();
        if(lacquerID == "") {
            $('.add-lacquer').addClass("disabled");
        } else {
            $('.add-lacquer').removeClass("disabled");
        }
    });

});