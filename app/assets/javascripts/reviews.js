(function() {
        var review= function() {
                var self = {};

                var result = {};

                self.chooseStar = function(index, pid) {
                        var i = 0;
                        $("#stars_"+pid).find("i").each(function() {
                                if (i > index) {
                                        $(this).attr("class", "glyphicon glyphicon-star-empty");
                                } else {
                                        $(this).attr("class", "glyphicon glyphicon-star");
                                }
                                i += 1;
                        });
                        result[pid] = index + 1;
                };

                self.submit = function() {
                        if ($.isEmptyObject(result)) {
                                window.location.href = "/orders/"+$("#order_id").val();
                                return;
                        }
                        var review_result = [];
                        $.each(result, function(key, value) {
                                review_result.push({
                                        product_id: key,
                                        score: value
                                });
                        });
                        $("#review_result").val(JSON.stringify(review_result));
                        $("#confirm_form").submit();
                };

                return self;
        };
        window.review = review();
})();
