(function(){

        var group = function() {
                var self = {};

                self.showQRcode = function(id, name) {
                        $("#qrcodeModalLabel").html(name);
                        $("#qrcodeBody").html("");
                        $("#qrcodeModal").modal("show");
                        $.ajax("/admin/groups/"+id+"/qrcode", {
                                method : "get"
                        }).done(function(data) {
                                $("#qrcodeBody").html(data);
                        });
                };

                return self;
        };

        window.group = group();

})();
