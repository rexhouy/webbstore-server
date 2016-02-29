(function() {

        var reservations = function() {
                var self = {};

                self.check = function() {
                        if($("#reservation_contact_name").val() && $("#reservation_contact_tel").val()) {
                                return true;
                        }
                        alert("请输入联系人和联系电话！");
                        return false;
                };

                return self;
        };

        window.reservations = reservations();
})();
