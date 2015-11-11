(function() {

        var showHeader = false;
        var fixed = false;
        var top = 0;
        var HEADER_HEIGHT = 50;
        var setHeaderVisible = function() {
                if (showHeader) {
                        if (window.scrollY <= top) {
                                $("#applicationHeader").css("position", "fixed").css("top", 0);
                                showHeader = false;
                                fixed = true;
                        }
                } else {
                        if (fixed) {
                                return;
                        }
                        top = window.scrollY - HEADER_HEIGHT;
                        $("#applicationHeader").css("top", top);
                        showHeader = true;
                }
        };

        var hideHeader = function() {
                if (fixed) {
                        $("#applicationHeader").css("position", "absolute").css("top", window.scrollY);
                        fixed = false;
                }
        };

        $(function() {
                var lastScrollTop = 0;
                $(document).scroll(function(e) {
                        if (window.scrollY < lastScrollTop) { // scroll up
                                setHeaderVisible();
                        } else { // scroll down
                                hideHeader();
                        };
                        lastScrollTop = window.scrollY;
                });
        });

})();
