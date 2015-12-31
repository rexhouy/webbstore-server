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
                var control_template = $("#product_control_template").html();
                var spec_control_template = $("#product_spec_control_template").html();
                if (!template) {
                        return;
                }
                var category = utility.getUrlParam("category") || "";
                var container = $(".products-list");
                infinitScroll("#infinit_scroll_indicator", // indicator selector
                              ".products-spinner", // spinner selector
                              "/products.json?category="+category, // url
                              function(result) {
                                      result.data.forEach(function(product) {
                                              var html = $(Mustache.render(template, product));
                                              if (product.specifications.length > 0) { // Has specifications
                                                      html.find(".control").html(Mustache.render(spec_control_template, product));
                                              } else { //
                                                      html.find(".control").html(Mustache.render(control_template, product));
                                              }
                                              html.appendTo(container);
                                      });
                              });
        });

})();
