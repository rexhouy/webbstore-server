(function(){

        var specbar = function() {
                var self = {};
                var id = "#specbar";

                self.open = function() {
                        $(".block-layer").show();
                        $(id).css("left", 0);
                };

                self.close = function() {
                        var spec = $(id);
                        if (spec[0]) {
                                $(".block-layer").hide();
                                $(id).css("left", "-100%");
                        }
                };

                return self;
        };
        window.specbar = specbar();
})();
