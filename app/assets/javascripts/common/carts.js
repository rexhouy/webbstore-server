(function(){
        var carts = function() {
                var self = {};

                var update = function(count, id, spec_id, minValue) {
                        $("#confirm_carts_btn").attr("disabled", "disabled");
                        if (count < minValue || count > 1000) {
                                // alert("购买数量不正确");
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
                                        count : count
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

                var updateTimer = {};
                var UPDATE_DELAY = 500;
                self.add = function(id, spec_id, minValue) {
                        var key = id+"_"+spec_id;
                        clearTimeout(updateTimer[key]);
                        var count = updateView(id, spec_id, 1, minValue);
                        updateTimer[key] = setTimeout(function() {
                                update(count, id, spec_id, minValue);
                        }, UPDATE_DELAY);
                };

                self.remove = function(id, spec_id, minValue) {
                        var key = id+"_"+spec_id;
                        clearTimeout(updateTimer[key]);
                        var count = updateView(id, spec_id, -1, minValue);
                        updateTimer[key] = setTimeout(function() {
                                update(count, id, spec_id, minValue);
                        }, UPDATE_DELAY);
                };


                var updateView = function(id, spec_id, change, minValue) {
                        var input = $("#count_"+id+"_"+spec_id);
                        var count = Number(input.val()) + change;
                        if (count < minValue || count > 1000) {
                                return input.val();
                        }
                        input.val(count);
	                if (count > 0) {
		                $("#count_"+id + "_"+spec_id).css("visibility","visible");
		                $("#btn_"+id + "_"+spec_id).css("visibility","visible");
	                } else {
		                $("#count_"+id + "_"+spec_id).css("visibility","hidden");
		                $("#btn_"+id + "_"+spec_id).css("visibility","hidden");
	                }
	                updateTotalCount(change);
	                return count;
                };
	        var totalCount = null;
	        var updateTotalCount = function(change) {
		        var initCount = $("#total_count");
		        if (initCount[0] == null) {
			        return;
		        }
		        if (totalCount == null) {// init total count
			        totalCount = Number(initCount.val());
		        }
		        totalCount += Number(change);
		        $("#cart_icon").hide();
		        $("#cart_count").html(totalCount).show();
	        };

                self.updateCount = function(select, id, spec_id, minValue) {
                        update(select.value, id, spec_id, minValue);
                };

                return self;
        };

        window.carts = carts();

})();
