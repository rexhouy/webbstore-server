//= require jquery
(function(){

        window.openGift = function() {
                $(".seals").css("top", "-100px");
                $(".seals-strip").css("top", "-500px");
                setTimeout(function(){
                        $(".coupon").css("top", "-80px");
                        $("#succeed").css("visibility", "visible");
                        $(".btn").html("前往拾惠社购物");
                }, 300);
        };

})();
