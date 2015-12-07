(function() {

        var channels = function() {
                var self = {};

                self.selectURL = function() {
                        var category_url = $("#category_url").val();
                        var article_url = $("#article_url").val();
                        if (category_url || article_url) {
                                $("#channel_url").val(category_url || article_url);
                        }
                        $("#selectModal").modal("hide");
                };

                self.categoryChange = function() {
                        var category = $("#category_url").val();
                        if (category) {
                                $("#article_url").attr("disabled", "disabled");
                        } else {
                                $("#article_url").removeAttr("disabled");
                        }
                };

                self.articleChange = function() {
                        var article = $("#article_url").val();
                        if (article) {
                                $("#category_url").attr("disabled", "disabled");
                        } else {
                                $("#category_url").removeAttr("disable");
                        }
                };

                return self;
        };

        window.channels = channels();

})();
