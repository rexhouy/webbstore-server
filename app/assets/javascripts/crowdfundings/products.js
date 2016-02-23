(function(){

        var product = function() {
                var self = {};
                var specbar = $("#specbar");
                var selectedSpec = null;

                var specExist = function() {
                        return specbar[0];
                };

                var openSpecbar = function() {
                        specbar.css("right", 0);
                };

                self.closeSpecbar = function() {
                        specbar.css("right", "-100%");
                };

                self.chooseSpec = function(specId) {
                        if (selectedSpec == specId) {
                                return;
                        }
                        if (selectedSpec) {
                                $("#spec_selector_"+selectedSpec).removeClass("selected");
                        }
                        $("#spec_selector_"+specId).addClass("selected");
                        $("#spec_price_"+selectedSpec).hide();
                        $("#spec_price_"+specId).show();
                        selectedSpec = specId;
                        $("#spec_add_to_cart_btn").removeAttr("disabled");

                };

                self.addToCart = function() {
                        if (specExist()) {
                                $("#spec_id").val(selectedSpec);
                        }
                        $("#add_to_cart_form").submit();
                };

                self.selectSpec = function() {
                        if (specExist()) {
                                openSpecbar();
                        } else {
                                self.addToCart();
                        }
                        return false;
                };

                self.locationSelected = function() {
                        var selectedLocation = $(".selected");
                        if (!selectedLocation[0]) {
                                alert("请选择一个地址！");
                                return;
                        }
                        $.ajax("/crowdfundings/user/setLocation.json", {
                                method : "post",
                                headers : {
                                        'X-CSRF-Token' : $( 'meta[name="csrf-token"]' ).attr( 'content' )
                                },
                                data : {
                                        location: selectedLocation.attr("data")
                                }
                        }).done(function(data) {
                                $("#userLocation").html(data.location);
                                $("#positionSelector").modal("hide");
                        });
                };

                var getPrice = function(callback) {
                        var price = $("#price").val();
                        if (price.endsWith("起")) {
                                $.ajax("/crowdfundings/products/"+$("#productId").val()+".json", {
                                        method : "get",
                                        headers : {
                                                'X-CSRF-Token' : $( 'meta[name="csrf-token"]' ).attr( 'content' )
                                        }
                                }).done(function(data) {
                                        callback(data.price);
                                });
                        } else {
                                callback(price);
                        }
                };

                self.showPaymentInfo = function(count) {
                        if (!count) {
                                $("#paymentInfo").html("");
                                return;
                        }
                        getPrice(function(price) {
                                var prepayment = $("#prepayment").val();
                                $("#paymentInfo").html("总价：￥"+count * price+"，需预支付：￥"+ Math.round(prepayment * count * price) / 100);
                        });
                };

                return self;
        };
        window.product = product();

        function selectUserLocation() {
                var location = $("#userLocation");
                if (location[0] && !location.html()) {
                        // select user location
                        $("#positionSelector").modal("show");
                }
        }

        function registLocationSelector() {
                function clearSelect() {
                        $(".selectable").each(function() {
                                $(this).removeClass("selected");
                        });
                }
                $(".selectable").each(function() {
                        $(this).click(function() {
                                clearSelect();
                                $(this).addClass("selected");
                        });
                });
        }

        function setPaymentType() {
                $("#paymentType").val(utility.isWechat() ? "wechat" : "alipay");
        }

        $(function(){
                selectUserLocation();
                registLocationSelector();
                setPaymentType();

                // Products infinit scroll
                var template = $("#product_template").html();
                if (!template) {
                        return;
                }
                var category = utility.getUrlParam("category") || "";
                var container = $(".products-list");
                infinitScroll("#infinit_scroll_indicator", // indicator selector
                              ".products-spinner", // spinner selector
                              "/crowdfundings/products.json?category="+category, // url
                              function(products) {
                                      products.forEach(function(product) {
                                              $(Mustache.render(template, product)).appendTo(container);
                                      });
                              });
        });

})();
