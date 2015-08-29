(function(){

        var addresses = function() {
                var self = {};

                self.edit = function(id) {
                        spinner.show();
                        $.getJSON("/addresses/"+id+".json", function(data){
                                address.setValue(data);
                                spinner.hide();
                                $("#address_modal").modal();
                        });
                };

                return self;
        };

        window.addresses = addresses();

        $(function() {
                address.init(true, false);
        });

})();
