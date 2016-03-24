(function($) {

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

        var product = function(){
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

                self.setFormParams = function(e) {
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
                        if (storage > 0) {
                                $("#product_storage").val(storage);
                        }
                        return false;
                };

                self.supplement = function(id, element) {
                        $(".input-well").each(function() {
                                $(this).hide();
                        });
                        var pos = $(element).position();
                        pos.left -= 300;
                        pos.top -=15;
                        $("#supplement_"+id).css("top", pos.top).css("left", pos.left).show().find(".form-control").focus();
                };

                self.hideSupplement = function(id) {
                        $("#supplement_"+id).hide();
                };

                self.checkWholesale = function(checked) {
                        if (checked) {
                                $("#wholesaleProperties").show("slow");

                        } else {
                                $("#wholesaleProperties").hide("slow");
                        }
                };

                self.check = function(e) {
                        return true;
                };

                return self;
        };

        var bulkProduct = function() {
                var self = product();
                var template = $("#specification_template").html();
                var name = "product[specifications_attributes][:index][:name]";

                var hasSpec = false;
                self.setFormParams = function(e) {
                        var container = $("#specifications");
                        var names = ["id", "name", "value", "storage", "batch_size", "price_km", "price_bj"];
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
                        if (storage > 0) {
                                $("#product_storage").val(storage);
                        }
                        hasSpec = storage > 0;
                        return false;
                };

                self.check = function() {
                        if (!hasSpec) {
                                alert("请添加规格信息!");
                                return false;
                        }
                        return true;
                };

                return self;
        };

        window.product = product();
        window.bulkProduct = bulkProduct();

        $(function() {
                $.datetimepicker.setLocale("zh");
                $("#product_start_date").datetimepicker({
                        format:'YYYY-MM-DD HH:mm:ss',
                        formatTime:'HH',
                        formatDate:'YYYY-MM-DD',
                        lang:'zh'
                });
        });

})(jQuery);
