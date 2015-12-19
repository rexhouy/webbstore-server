(function() {
        var carts = function() {
                var self = {};

                var isWeiXin = function(){
                        var ua = window.navigator.userAgent.toLowerCase();
                        if(ua.match(/MicroMessenger/i) == 'micromessenger'){
                                return true;
                        }else{
                                return false;
                        }
                };

                self.submit = function() {
                        $("#payment_type").val(isWeiXin() ? "wechat" : "alipay");
                        $("#confirm_form").submit();
                };

                return self;
        };

        window.carts = carts();
})();
