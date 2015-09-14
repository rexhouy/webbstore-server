(function(){
        var carts = function() {
                var self = {};
                self.updateCount = function(select, id, spec_id) {
                        $("#confirm_carts_btn").attr("disabled", "disabled");
                        if (select.value <= 0 || select.value > 1000) {
                                alert("购买数量不正确");
                                return;
                        }
                        spinner.show();
                        $.ajax("/carts.json", {
                                method : "post",
                                headers : {
                                        'X-CSRF-Token' : utility.getCSRFtoken()
                                },
                                data : {
                                        _method : "put",
                                        id : id,
                                        spec_id : spec_id,
                                        count : select.value
                                }
                        }).done(function(data){
                                if (data.succeed) {
                                        $("#confirm_carts_btn").removeAttr("disabled");
                                        $("#subtotal").html(data.subtotal);
                                } else {
                                        alert(data.message);
                                }
                                spinner.hide();
                        });
                };

                return self;
        };

        window.carts = carts();

})();
