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

                var updateCount = function(id, count, change) {
                        var item = $("#control_"+id);
                        var totalCount = Number($("#cart_number").val());
                        totalCount += change;
                        $("#cart_number").val(totalCount);
                        if (count == 0) {
                                item.find(".glyphicon-minus").hide();
                                item.find(".count").empty().hide();
                        } else {
                                item.find(".glyphicon-minus").show();
                                item.find(".count").html(count).show();
                        }
                        if (totalCount > 0) {
                                $(".floating-action-btn").html("<i class=\"cart-number\">"+totalCount+"</i>");
                        } else {
                                $(".floating-action-btn").html("<i class=\"glyphicon glyphicon-shopping-cart\"></i>");
                        }
                };

                self.addToCart = function(id) {
                        $.ajax("/carts/plus/"+id, {
                                method : 'post',
                                headers : {
                                        'X-CSRF-Token' : utility.getCSRFtoken()
                                }
                        }).done(function(data){
                                if (data.succeed) {
                                        updateCount(id, data.count, 1);
                                }
                        });
                };

                self.removeFromCart = function(id) {
                        $.ajax("/carts/minus/"+id, {
                                method : 'post',
                                headers : {
                                        'X-CSRF-Token' : utility.getCSRFtoken()
                                }
                        }).done(function(data){
                                if (data.succeed) {
                                        updateCount(id, data.count, -1);
                                }
                        });
                };

                return self;
        };
        window.product = product();

})();
