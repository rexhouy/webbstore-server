(function(){
        /**
         * Extend jQuery
         */
        $.fn.serializeObject = function()
        {
                var o = {};
                var a = this.serializeArray();
                $.each(a, function() {
                        if (o[this.name] !== undefined) {
                                if (!o[this.name].push) {
                                        o[this.name] = [o[this.name]];
                                }
                                o[this.name].push(this.value || '');
                        } else {
                                o[this.name] = this.value || '';
                        }
                });
                return o;
        };

        window.utility = {
                getCSRFtoken : function() {
                        return $( 'meta[name="csrf-token"]' ).attr( 'content' );
                },
                getUrlParam: function(name) {
                        var urlParams= window.location.search.substring(1).split("&");
                        var params = {};
                        urlParams.forEach(function(param){
                                var kvPair = param.split("=");
                                params[kvPair[0]] = kvPair[1];
                        });
                        return params[name];
                }
        };
})();
