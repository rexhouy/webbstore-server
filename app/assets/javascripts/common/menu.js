;(function(){
        var menu = function() {
                var self = {};
                var id = "#menu";

                self.open = function() {
                        $(".block-layer").show();
                        $(id).css("left", 0);
                };

                self.close = function() {
                        $(".block-layer").hide();
                        $(id).css("left", "-100%");
                };

                return self;
        };
        window.menu = menu();
})();
