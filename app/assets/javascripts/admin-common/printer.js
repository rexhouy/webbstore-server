(function(){
        var printer = function() {
                var self = {};

                self.print = function() {
                        window.print();
                };

                return self;
        };

        window.printer = printer();
})();
