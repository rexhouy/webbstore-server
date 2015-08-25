(function(){
        var search = function() {
                var self = {};

                self.open = function() {
                        $("#search").css("width", "100%");
                        $("#menu_control_pannel").hide();
                        $("#search_input").focus();
                };

                self.close = function() {
                        $("#menu_control_pannel").show();
                        $("#search").css("width", 0);
                        return false;
                };

                return self;
        };
        window.search = search();
})();
