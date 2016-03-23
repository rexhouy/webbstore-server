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

                self.checkUserLocation = function() {
                        if ($("#is_bulk_product").val() == "false") {
                                return;
                        }
                        if (new Date($("#start_date").val()) > new Date()) {
                                return;
                        }
                        if (!$("#user_location")[0]) {
                                return;
                        }
                        if ($("#user_location").val()) {
                                $("#buy_btn").removeAttr("disabled");
                                self.showSalesGraph();
                        } else {
                                $("#positionSelector").modal("show");
                        }
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
                                $("#positionSelector").modal("hide");
                                var price = selectedLocation.attr("data") == "北京市" ? $("#price_bj").val() : $("#price_km").val();
                                $("#buy_btn").html("￥" + price).removeAttr("disabled");
                                self.showSalesGraph();
                        });
                };

                self.showSalesGraph = function() {
                        if (!document.getElementById("price_hist_graph")) {
                                return;
                        }
                        var ctx = document.getElementById("price_hist_graph").getContext("2d");
                        $.get("/products/" + $("#id").val() + "/price_hist.json", function(data) {
                                if (data.labels.length == 0) {
                                        $("#price_hist").hide();
                                        return;
                                }
                                var width = $(".banner").width();
                                document.getElementById("price_hist_graph").style.width = width - 24 + "px";
                                document.getElementById("price_hist_graph").style.height = "180px";
                                new Chart(ctx).LineAlt(data);
                        });
                };

                return self;
        };
        window.product = product();

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


        $(function(){
                window.product.checkUserLocation();
                registLocationSelector();
                // Products infinit scroll
                var template = $("#product_template").html();
                if (!template) {
                        return;
                }
                var category = utility.getUrlParam("category") || "";
                var container = $(".products-list");
                infinitScroll("#infinit_scroll_indicator", // indicator selector
                              ".products-spinner", // spinner selector
                              "/products.json?category="+category, // url
                              function(products) {
                                      products.data.forEach(function(product) {
                                              $(Mustache.render(template, product)).appendTo(container);
                                      });
                              });
        });
})();
