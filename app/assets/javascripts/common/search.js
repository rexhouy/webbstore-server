(function(){
        var search = function() {
                var self = {};

                self.open = function() {
                        $("#block-layer").show();
                        $("#search").show();
                        $("#search_input").focus();
                        $("#searchText").focus();
                };

                self.close = function() {
                        $("#search").hide();
                        $("#block-layer").hide();
                        return false;
                };

                return self;
        };
        window.search = search();
})();
