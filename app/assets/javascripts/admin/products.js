(function($){

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
                        action: "/admin/product/preview",
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

        window.product = function(){
                var self = {};

                var template = $("#specification_template").html();
                var name = "product[specifications_attributes][:index][:name]";
                var getSpecCount = function() {
                        return $("#specification_tbody").children().size();
                };

                self.addSpec = function() {
                        $(template.replace(/:index/g, getSpecCount())).appendTo($("#specification_tbody"));
                };

                self.removeSpec = function(btn) {
                        $(btn).parent().parent().remove();
                };

                self.setFormParams = function() {
                        var container = $("#specifications");
                        var names = ["id", "name", "value", "price", "storage", "count"];
                        var storage = 0;
                        $("#specification_tbody").find("tr").each(function(spec_index) {
                                $(this).find("input").each(function(index, element) {
                                        var html_name = name.replace(/:index/, spec_index).replace(/:name/, names[index]);
                                        container.append($("<input type=hidden name="+html_name+" value='"+element.value+"'>"));
                                        if (names[index] == "storage" && element.value) {
                                                storage += Number(element.value);
                                        }
                                });
                        });
                        $("#product_storage").val(storage);
                        return false;
                };

                return self;
        }();


})(jQuery);
