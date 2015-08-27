(function(){

        var infinitScroll = function(indicatorId, spinnerId, url, callback) {
                var self = {};
                var page = 1;
                var SCROLL_PREPARE = 1000;
                var processing = false;

                var init = function() {
                        $(window).off("scroll");
                        $(window).on("scroll", scrollListener);
                        load(); // load at startup
                };

                var scrollListener = function() {
                        if (!processing && shouldLoad()) {
                                load();
                        }
                };

                var shouldLoad = function() {
                        var indicatorTop = $(indicatorId).offset().top;
                        var scrollTop = $(window).scrollTop();
                        return scrollTop > (indicatorTop - SCROLL_PREPARE);
                };

                var load = function() {
                        processing = true;
                        $(spinnerId).show();
                        $.getJSON(addPageParam(url), function(data) {
                                if (data.length == 0) {
                                        $(spinnerId).hide();
                                        $(window).off("scroll");
                                        return false;
                                }
                                callback(data);
                                $(spinnerId).hide();
                                processing = false;
                        });
                };

                var addPageParam = function(url) {
                        if (url.indexOf("?") != -1) {
                                url += ("&page=" + page);
                        } else {
                                url += ("?page=" + page);
                        }
                        page++;
                        return url;
                };

                init();
                return self;
        };

        window.infinitScroll = infinitScroll;

})();
