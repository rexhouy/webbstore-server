(function(){
        var users = function() {
                var self = {};

                var hideSupplier = function() {
                        $("#supplier").hide();
                        $("#user_supplier_id").val("");
                };

                var hideGroup = function() {
                        $("#group").hide();
                        $("#user_group_id").val("");
                };

                var showSupplier = function() {
                        $("#supplier").show();
                };

                var showGroup = function() {
                        $("#group").show();
                };

                self.changeRole = function() {
                        var role = $("#user_role").val();
                        if (role == "customer") { // No group, supplier
                                hideSupplier();
                                hideGroup();
                        } else if (role == "supplier") { // Need group, supplier
                                showGroup();
                                showSupplier();
                        } else if(role == "seller" || role == "admin") { // Need group, No supplier
                                showGroup();
                                hideSupplier();
                        }
                };

                self.check = function() {
                        var role = $("#user_role").val();
                        if (role == "customer") {// No group, supplier
                                return true;
                        } else if (role == "supplier") {// Need group, supplier
                                if (!$("#user_group_id").val()) {
                                        alert("必须选择所属店铺");
                                        return false;
                                }
                                if (!$("#user_supplier_id").val()) {
                                        alert("必须选择所属供应商");
                                        return false;
                                }
                        } else if (role == "seller" || role == "admin") {// Need group, No supplier
                                if (!$("#user_group_id").val()) {
                                        alert("必须选择所属店铺");
                                        return false;
                                }
                        }
                        return true;
                };

                return self;
        };

        window.users = users();

        $(function(){
                window.users.changeRole();
        });

})();
