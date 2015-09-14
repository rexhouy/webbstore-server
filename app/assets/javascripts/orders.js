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
                        var contact_name = $("#contact_name").val();
                        var contact_tel = $("#contact_tel").val();
                        if ($("#contact_name")[0]) { // ordering
                                var validTel = contact_tel && !isNaN(contact_tel) && contact_tel.length == 11;
                                if (!validTel) {
                                        alert("请输入一个合法的手机号");
                                        return false;
                                }
                                if (!contact_name) {
                                        alert("请输入姓名");
                                        return false;
                                }
                        } else { // takeout
                                if (address == null || paymentType == null) {
                                        alert("请选择配送地址与支付方式!");
                                        return false;
                                }
                                $("#selected_address_id").val(address);
                        }
                        $("#payment_type").val(paymentType);
                        $("#carts_confirm_form").submit();
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

        $(function() {
                address.init(false, true);
                registerPaymentSelection();
        });


})();
