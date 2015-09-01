(function(){

        var orders = function() {
                var self = {};

                self.toDetail = function(id) {
                        window.location.href = "/orders/"+id;
                };

                var getSelectedAddress = function() {
                        var selected;
                        $("address").each(function() {
                                if ($(this).hasClass("selected")) {
                                        selected = $(this).find("input[name='address_id']").val();
                                }
                        });
                        return selected;
                };
                var getSelectedPaymentType = function() {
                        var selectedContent = $("div[name='payment']").filter(".selected").html();
                        switch ($.trim(selectedContent)) {
                        case "支付宝":
                                return "alipay";
                        case "微信支付":
                                return "wechat";
                        case "货到付款":
                                return "offline_pay";
                        }
                        return null;
                };
                self.confirm = function() {
                        var address = getSelectedAddress();
                        var paymentType = getSelectedPaymentType();
                        if (address != null && paymentType != null) {
                                $("#selected_address_id").val(address);
                                $("#payment_type").val(paymentType);
                                $("#orders_confirm_form").submit();
                                return true;
                        } else {
                                alert("请选择配送地址与支付方式!");
                                return false;
                        }
                };

                return self;
        };

        window.orders = orders();

        var registerPaymentSelection = function() {
                var payments = $(".payment-type");
                payments.each(function() {
                        $(this).click(function() {
                                payments.each(function() {
                                        $(this).removeClass("selected");
                                });
                                $(this).addClass("selected");
                        });
                });
        };

        $(function() {
                address.init(false, true);
                registerPaymentSelection();
        });

})();
