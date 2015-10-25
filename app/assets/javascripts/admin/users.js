(function(){

        var user = function() {
                var self = {};

                self.checkDispense = function() {
                        var selected = false;
                        $("input[name='coupon_ids[]']").each(function(){
                                if (this.checked) {
                                        selected = true;
                                }
                        });
                        if (!selected) {
                                alert("请选择需要发放的优惠券");
                        }
                        return selected;
                };

                return self;
        };

        window.user = user();

        $(function(){
                var loaded = false;
                $('#couponModal').on("show.bs.modal", function (e) {
                        $.get("/admin/coupons/list_available").done(function(data){
                                $("#couponModalBody").html(data);
                        });
                });
        });

})();
