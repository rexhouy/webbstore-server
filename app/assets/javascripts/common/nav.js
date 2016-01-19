(function() {
        var navbarExists = function() {
                return !!$(".scroll-container")[0];
        };
        var nav = function() {
                var self = {};
                var show = false;
                var windowWidth, scrollWidth;
                var showIndicatorThreshold = 10;

                var init = function() {
                        if (navbarExists()) {
                                windowWidth = window.screen.width - 40; // indicator uses 40px space.
                                scrollWidth = $(".scroll-container")[0].scrollWidth;
                        }
                };
                init();

                self.toggleSettings = function() {
                        if (show) {
                                $(".settings").hide();
                        } else {
                                $(".settings").show();
                        }
                        show = !show;
                };

                self.scrollRight = function() {
                        var scrollLeft = $(".scroll-container")[0].scrollLeft;
                        scroll(scrollLeft + windowWidth);
                };

                self.scrollLeft = function() {
                        var scrollLeft = $(".scroll-container")[0].scrollLeft;
                        scroll(scrollLeft - windowWidth);
                };

                var canScrollLeft = function(scrollLeft) {
                        return scrollLeft > showIndicatorThreshold;
                };

                var canScrollRight = function(scrollLeft) {
                        return scrollLeft + windowWidth < scrollWidth - showIndicatorThreshold;
                };

                self.setScrollIndicator = function() {
                        var scrollLeft = $(".scroll-container")[0].scrollLeft;
                        $(".scroll-indicator.left").css("visibility", canScrollLeft(scrollLeft) ? "visible" : "hidden");
                        $(".scroll-indicator.right").css("visibility", canScrollRight(scrollLeft) ? "visible" : "hidden");
                };

                self.scrollToActive = function() {
                        var activeScrollLeft = $(".scroll-container li.active").position().left;
                        scroll(activeScrollLeft);
                };

                var scroll = function(scrollLeft) {
                        $(".scroll-container").animate({scrollLeft: scrollLeft}, "slow");
                };

                return self;
        };

        window.nav = nav();
        $(function() {
                if (navbarExists()) {
                        window.nav.scrollToActive();
                        window.nav.setScrollIndicator();
                }
        });

})();
