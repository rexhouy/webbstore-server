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
                        return $("div[name='payment']").filter(".selected").attr("data");
                };
                var getOrderInfo = function() {
                        return $("#contact").val();
                };
                self.confirm = function() {
                        var address = getSelectedAddress();
                        var paymentType = getSelectedPaymentType();
                        var orderInfo = getOrderInfo();
                        var order_type = $("#order_type").val();
                        var isReserve = order_type == "reserve";
                        var isImmediate = order_type == "immediate";
                        var isTakeout = order_type == "takeout";
                        var hasTableNo = $("#tableNo")[0];
                        if (hasTableNo && !$("#tableNo").val()) {
                                alert("请输入桌号！");
                                return false;
                        }
                        if (paymentType == null) {
                                alert("请选择支付方式!");
                                return false;
                        }
                        if (isReserve && !orderInfo) {
                                alert("请填写联系人信息!");
                                return false;
                        }
                        if (isTakeout && address == null) {
                                alert("请选择配送地址!");
                                return false;
                        }
                        $("#selected_address_id").val(address);
                        $("#payment_type").val(paymentType);
                        $("#orders_confirm_form").submit();
                        return true;
                };

                var orderAmount = 0;
                var couponAmount = 0;
                var accountBalanceAmount = 0;

                var useBalance = false;
                self.useAccountBalance = function(element, amount) {
                        useBalance = !useBalance;
                        $("#use_account_balance").val(useBalance);
                        $(element).toggleClass("active");
                        var balance = useBalance ? "- ¥ " + format(amount) : "¥ 0.00";
                        $("#account_balance_amount").html(balance);
                        accountBalanceAmount = useBalance ? Number(amount) : 0;
                        resetTotalAmount();
                };

                var format = function(n) {
                        return n.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,');
                };

                var couponBar = $("#couponbar");
                var openCouponbar = function() {
                        couponBar.css("right", 0);
                };

                self.closeCouponbar = function() {
                        couponBar.css("right", "-100%");
                };

                self.selectCoupon = function(element) {
                        openCouponbar();
                };

                var selectedCoupon;
                self.couponSelected = function(element) {
                        var coupon = $(element);
                        if (selectedCoupon) {
                                selectedCoupon.removeClass("selected");
                        }
                        coupon.addClass("selected");
                        selectedCoupon = coupon;
                        $("#select_coupon_btn").removeAttr('disabled');
                };

                self.confirmCoupon = function() {
                        $("#use_coupon").val(selectedCoupon.attr("data"));
                        $("#selected_coupon").html(selectedCoupon.find(".header").html());
                        couponAmount = Number(selectedCoupon.attr("data-amount"));
                        $("#coupon_amount").html("- ¥ " + format(couponAmount));
                        resetTotalAmount();
                        self.closeCouponbar();
                };

                var resetTotalAmount = function() {
                        orderAmount = orderAmount || Number($("#order_total_amount").val());
                        var paymentAmount = orderAmount - couponAmount - accountBalanceAmount;
                        paymentAmount = paymentAmount > 0 ? paymentAmount : 0;
                        $("#total_amount").html("¥ " + format(paymentAmount));
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
