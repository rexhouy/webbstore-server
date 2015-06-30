(function($){
        // $('#product_article').wysihtml5().css("height", "600px");

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
                        var names = ["id", "name", "value", "price", "storage"];
                        $("#specification_tbody").find("tr").each(function(spec_index) {
                                $(this).find("input").each(function(index, element) {
                                        var html_name = name.replace(/:index/, spec_index).replace(/:name/, names[index]);
                                        container.append($("<input type=hidden name="+html_name+" value='"+element.value+"'>"));
                                });
                        });
                        return false;
                };

                return self;
        }();

        window.uploader = function(){
                var self = {};

                self.open = function() {
                        $("#cover_image_upload").click();
                };

                self.upload = function(event) {
                        var files = event.target.files;
                        var data = new FormData();
                        $.each(files, function(index, file) {
                                data.append("file", file, file.name);
                        });
                        $.ajax({
                                url: '/admin/image',
                                type: 'POST',
                                data: data,
                                cache: false,
                                dataType: 'json',
                                processData: false, // Don't process the files
                                contentType: false, // Set content type to false as jQuery will tell the server its a query string request
                                success: function(data, textStatus, jqXHR) {
                                        $("#product_cover_image").val(data.filelink);
                                        $("#cover_image").attr("src", data.filelink);
                                }
                        });
                };

                return self;
        }();

})(jQuery);
