(function() {
        var helper = function() {
                var self = {};
                var img_num = 1;
                var max = 3;

                var showControlBtn = function() {
                        if (img_num == 1) {
                                $(".btn-help-control-left").hide();
                                $(".btn-help-control-right").show();
                        } else if (img_num == max) {
                                $(".btn-help-control-left").show();
                                $(".btn-help-control-right").hide();
                        } else {
                                $(".btn-help-control-left").show();
                                $(".btn-help-control-right").show();
                        }
                };

                self.left = function() {
                        img_num = img_num - 1;
                        var pos = (img_num - 1) * 100;
                        $(".help-img").css("left", "-"+pos+"%");
                        showControlBtn();
                };

                self.right = function() {
                        var pos = img_num * 100;
                        $(".help-img").css("left", "-"+pos+"%");
                        img_num = img_num + 1;
                        showControlBtn();
                };

                return self;
        };

        window.helper = helper();
})();
