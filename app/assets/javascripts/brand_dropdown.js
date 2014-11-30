$(function(){
	$('.lacquer-dropdown').hide();
    $('.other-lacquer').hide();
    $('#brand-selection').change(function(event){
        var brand = $(this).val();
        $('.lacquer-dropdown').hide();
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
        $('.other-lacquer').hide();
        var lacquerID = $(this).find("select").val();
        if(lacquerID == "") {
            $('.add-lacquer').addClass("disabled");
        } else if(lacquerID == "new") {
            $('.other-lacquer').show();
            $('.add-lacquer').removeClass("disabled");
        } else {
            $('.add-lacquer').removeClass("disabled");
        }
    });
    
    $('#finish-dropdown').hide();
    $('#color-dropdown').hide();
    
    $('.color-dropdown').click(function(event){
        $('#color-dropdown').toggle();
    });

    $('.finish-dropdown').click(function(event){
        $('#finish-dropdown').toggle();
    });

});