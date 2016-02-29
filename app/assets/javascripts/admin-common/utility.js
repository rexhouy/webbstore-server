(function() {
        window.utility = {
                resetForm: function(btn) {
                        $(btn).closest("form").find("input[type=text], input[type=date], input[type=tel], textarea").val("");
                }
        };
})();
