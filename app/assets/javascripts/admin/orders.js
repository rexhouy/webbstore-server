(function(){
        var cards = function() {
                var self = {};

                self.print = function(id) {
                        $.getJSON("/admin/orders/cards/"+id+".json", function(data){
                                $("#print_name").html(data.name);
                                $("#print_contact_name").html(data.contact_name);
                                $("#print_contact_tel").html(data.contact_tel);
                                $("#print_contact_address").html(data.contact_address);
                                $("#print_next").html(data.next);
                                $("#print_remain").html(data.remain + " / " + data.count);
                                printer.print();
                        });
                        return false;
                };

                return self;
        };
        window.cards = cards();

        $(function () {
                $('[data-toggle="popover"]').popover();
        });

})();
