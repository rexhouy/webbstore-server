(function(){

        var dinningTable = function() {
                var self = {};

                self.showQRcode = function(id, name) {
                        $("#qrcodeModalLabel").html(name);
                        $("#qrcodeBody").html("");
                        $("#qrcodeModal").modal("show");
                        $.ajax("/admin/dinning_tables/"+id+"/qrcode", {
                                method : "get"
                        }).done(function(data) {
                                $("#qrcodeBody").html(data);
                        });
                };

                return self;
        };

        window.dinningTable = dinningTable();

})();
