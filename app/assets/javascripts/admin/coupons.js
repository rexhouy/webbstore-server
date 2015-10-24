(function(){
        var coupon = function() {
                var self = {};
                var activeId;

                self.confirm = function(id, name) {
                        $("#dispenseModalLabel").html("发放"+name);
                        activeId = id;
                        $("#dispenseModal").modal({show: true});
                };

                self.dispense = function() {
                        $("#dispenseModalLabel").html("发放中，请稍后...");
                        $("#dispense_form").attr("action", "/admin/coupons/dispense/"+activeId).submit();
                        this.disabled = "disabled";
                        this.innerHTML = "发放中，请稍后...";
                };

                return self;
        };
        window.coupon = coupon();
})();
