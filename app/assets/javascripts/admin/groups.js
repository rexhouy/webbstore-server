(function(){

        var group = function() {
                var self = {};

                var active;

                self.showQRcode = function(id, name) {
                        $("#qrcodeModalLabel").html(name);
                        $("#qrcodeBody").html("");
                        $("#qrcodeModal").modal("show");
                        $.ajax("/admin/groups/"+id+"/qrcode", {
                                method : "get"
                        }).done(function(data) {
                                $("#qrcodeBody").html(data);
                        });
                        active = id;
                };

                self.printQRcode = function() {
                        $.ajax("/admin/groups/"+active+"/print_qrcode", {
                                method : "get"
                        }).done(function(data) {
                                alert("已打印");
                        });
                };

                return self;
        };

        window.group = group();

})();
