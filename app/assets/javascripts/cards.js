(function(){
        var cards = function() {
                var self = {};

                self.closeModal = function(id) {
                        $(id).modal("hide");
                };

                self.gift = function(id) {
                        $("#gift_form").attr("action", "/cards/gift/"+id)[0].reset();
                        $("#cards_modal").modal("show");
                        return false;
                };

                self.open = function(id) {
                        $("#open_form").attr("action", "/cards/open/"+id)[0].reset();
                        $("#cards_open_modal").modal("show");
                        return false;
                };

                return self;
        };
        window.cards = cards();

        $(function() {
                address.init(false, false);
        });

})();
