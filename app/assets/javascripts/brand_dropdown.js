var BRANDS = {
    "Essie": '#essie-dropdown',
    "OPI": '#opi-dropdown',
    "Butter London": '#butter-dropdown',
    "Deborah Lippmann": '#deborah-dropdown',
    "Zoya": '#zoya-dropdown',
    "China Glaze": '#china-dropdown',
    "I Love Nail Polish (ILNP)": '#i-dropdown',
    "Dior": '#dior-dropdown',
    "Chanel": '#chanel-dropdown',
    "Formula X by Sephora": '#formula-dropdown',
    "Sephora": '#sephora-dropdown',
    "Nails Inc.": '#nails-dropdown',
    "Lancome": '#lancome-dropdown',
    "Nars": '#nars-dropdown',
    "Mac": '#mac-dropdown',
    "Nicole by OPI": '#nicole-dropdown',
    "Sally Hansen": '#sally-dropdown',
    "Color Club": '#color-dropdown',
    "Orly": '#orly-dropdown',
    "CND": '#cnd-dropdown',
    "Maybelline": '#maybelline-dropdown',
    "L'Oreal Paris": "#l'oreal-dropdown",
    "Revlon": "#revlon-dropdown",
    "CoverGirl": "#covergirl-dropdown"
};

var BRANDS_SHORT = {
    "Essie": '.other-lacquer#essie',
    "OPI": '.other-lacquer#opi',
    "Butter London": '.other-lacquer#butter',
    "Deborah Lippmann": '.other-lacquer#deborah',
    "Zoya": '.other-lacquer#zoya',
    "China Glaze": '.other-lacquer#china',
    "I Love Nail Polish (ILNP)": '.other-lacquer#i',
    "Dior": '.other-lacquer#dior',
    "Chanel": '.other-lacquer#chanel',
    "Formula X by Sephora": '.other-lacquer#formula',
    "Sephora": '.other-lacquer#sephora',
    "Nails Inc.": '.other-lacquer#nails',
    "Lancome": '.other-lacquer#lancome',
    "Nars": '.other-lacquer#nars',
    "Mac": '.other-lacquer#mac',
    "Nicole by OPI": '.other-lacquer#nicole',
    "Sally Hansen": '.other-lacquer#sally',
    "Color Club": '.other-lacquer#color',
    "Orly": '.other-lacquer#orly',
    "CND": '.other-lacquer#cnd',
    "Maybelline": '.other-lacquer#maybelline',
    "L'Oreal Paris": ".other-lacquer#l'oreal",
    "Revlon": ".other-lacquer#revlon",
    "CoverGirl": ".other-lacquer#covergirl"
};

$(function(){
	$('.lacquer-dropdown').hide();
    $('.other-lacquer').hide();
    $('#brand-selection').change(function(event){
        event.stopPropagation();
        var brand = $(this).val();
        $('.lacquer-dropdown').hide();
        $('.other-lacquer').hide();
        $('.add-lacquer').addClass("disabled");
        $.each(BRANDS, function(key, value){
            if(brand == key){
                $(value).show();
            }
        });
    });

    $('.lacquer-dropdown').change(function(event){
        event.stopPropagation();
        $('.other-lacquer').hide();
        var brand = $('#brand-selection').val();
        var lacquerID = $(this).find("select").val();
        if(lacquerID == "") {
            $('.add-lacquer').addClass("disabled");
        } else if(lacquerID == "new") {
            $.each(BRANDS_SHORT, function(key, value){
                if(brand == key){
                    $(value).show();
                }
            });
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