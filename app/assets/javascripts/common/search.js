(function(){
        var search = function() {
                var self = {};

                self.open = function() {
                        $("#search").css("width", "100%");
                        $("#search_input").focus();
                };

                self.close = function() {
                        $("#search").css("width", 0);
                        return false;
                };

                return self;
        };
        window.search = search();
})();
