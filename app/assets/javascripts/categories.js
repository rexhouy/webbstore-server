(function() {
        $(function() {
                $("#categories button").each(function() {
                        $(this).click(function(){
                                var btn = $(this);
                                var id = btn.attr("data-id");
                                var hasChildren = btn.attr("data-has-children");
                                if (hasChildren && hasChildren != "false") {
                                        if (btn.attr("data-slidedown")) {
                                                // slide up
                                                btn.removeAttr("data-slidedown");
                                                $("#sub_category_"+id).slideUp();
                                                $("#category_btn_icon_"+id).removeClass("glyphicon-menu-up").addClass("glyphicon-menu-down");
                                        } else {
                                                // slide down
                                                btn.attr("data-slidedown", true);
                                                $("#sub_category_"+id).slideDown();
                                                $("#category_btn_icon_"+id).removeClass("glyphicon-menu-down").addClass("glyphicon-menu-up");
                                        }
                                } else {
                                        // goto category
                                        window.location.href="/products?category="+id;
                                }
                        });
                });
        });

})();
