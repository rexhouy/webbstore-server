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
                return self;
        };
        window.product = product();


        $(function(){
                // Products infinit scroll
                var template = $("#product_template").html();
                if (!template) {
                        return;
                }
                var channel = utility.getUrlParam("channel") || "";
                var container = $(".products-list");
                infinitScroll("#infinit_scroll_indicator", // indicator selector
                              ".products-spinner", // spinner selector
                              "/products.json?channel="+channel, // url
                              function(products) {
                                      products.forEach(function(product) {
                                              $(Mustache.render(template, product)).appendTo(container);
                                      });
                              });
        });
})();
