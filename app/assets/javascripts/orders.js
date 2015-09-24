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
                var getSelectedDeliveryType = function() {
                        var selectedContent = $("div[name='delivery']").filter(".selected").html();
                        switch ($.trim(selectedContent)) {
                        case "宅配":
                                return "express";
                        case "自提":
                                return "self";
                        }
                        return null;
                };
                self.confirm = function() {
                        var address = getSelectedAddress();
                        var deliveryType = getSelectedDeliveryType();
                        var paymentType = getSelectedPaymentType();
                        if (deliveryType == null) {
                                alert("请选择配送方式");
                                return false;
                        } else {
                                if (paymentType == null) {
                                        alert("请选择支付方式");
                                        return false;
                                } else if (paymentType == "express" && address == null) {
                                        alert("请选择地址");
                                        return false;
                                }
                        }
                        $("#selected_address_id").val(address);
                        $("#payment_type").val(paymentType);
                        $("#delivery_type").val(deliveryType);
                        $("#orders_confirm_form").submit();
                        return true;
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

        var registerDeliverySelection = function() {
                var deliveries = $(".delivery-type");
                deliveries.each(function() {
                        $(this).click(function() {
                                deliveries.each(function() {
                                        $(this).removeClass("selected");
                                });
                                $(this).addClass("selected");
                                if ($.trim($(this).html()) == "自提") {
                                        $("#select_address").slideUp();
                                } else {
                                        $("#select_address").slideDown();
                                }
                        });
                });
        };


        $(function() {
                address.init(false, true);
                registerPaymentSelection();
                registerDeliverySelection();
        });

})();
