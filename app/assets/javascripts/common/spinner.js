(function(){
        var spinner = function() {
                var self = {};

                self.show = function() {
                        $(".block-layer").show();
                        $(".spinner").show();
                };

                self.hide = function() {
                        $(".block-layer").hide();
                        $(".spinner").hide();
                };

                return self;
        };
        window.spinner = spinner();
})();
