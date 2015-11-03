//= require jquery
(function(){

        var opend = false;

        var setCoupon = function(data) {
                if (!data.coupon) {
                        $("#succeed").html("您已经抽过红包了");
                        $("#coupon_amount").html("0");
                        $("#coupon_limit").html("每个人只能抽一次，不可以贪心哦！");
                } else {
                        $("#coupon_amount").html(data.coupon.amount);
                        $("#coupon_limit").html(data.coupon.limit);
                        $("#coupon_date").html(data.coupon.date);
                }
        };

        var hideSeals = function() {
                $(".seals").css("top", "-100px");
                $(".seals-strip").css("top", "-500px");
        };

        var showCoupon = function() {
                $(".coupon").css("top", "-80px");
                $("#succeed").css("visibility", "visible");
        };

        var getCoupon = function() {
                $(".btn").attr("disabled", "disabled");
                hideSeals();
                $.ajax("/gift/lottery.json", {
                        method : "post",
                        headers : {
                                'X-CSRF-Token' : $( 'meta[name="csrf-token"]' ).attr( 'content' )
                        }
                }).done(function(data) {
                        setCoupon(data);
                        showCoupon();
                        $(".btn").html("前往拾惠社购物").removeAttr("disabled");
                        opend = true;
                });
        };

        window.openGift = function(btn) {
                if ($("#current_user").val() != "true") {
                        window.location.href = "/users/sign_in";
                        return;
                }
                if (opend) {
                        window.location.href="/";
                } else {
                        getCoupon();
                }
        };

})();
