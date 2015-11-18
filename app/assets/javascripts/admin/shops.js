(function() {
        var previewFrame = $("#preview");
        var spinner = $("#spinner");

        previewFrame.load(function() {
                spinner.hide();
                previewFrame.show("slow", function(){
                        previewFrame.height(previewFrame.contents().height());
                });
        });
        var preview = function() {
                var formData = $('.form-horizontal').serializeArray();
                var form = $("<form>").attr({
                        action: "/admin/shops/preview",
                        method: "post",
                        target: "preview"
                });
                formData.forEach(function(data) {
                        if (data.name == "_method") {
                                return;
                        }
                        $("<input>").attr({
                                type: "hidden",
                                name: data.name,
                                value: data.value
                        }).appendTo(form);
                });
                form.appendTo($(document.body)).submit().remove();
        };

        $('#previewModal').on('show.bs.modal', function(e) {
                preview();
        });

        $('#previewModal').on('hide.bs.modal', function(e) {
                previewFrame.hide();
                spinner.show();
        });

})();
