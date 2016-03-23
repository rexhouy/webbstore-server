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

                self.checkBulk = function(checked) {
                        if (checked) {
                                $("#bulkProperties").show("slow");
                        } else {
                                $("#bulkProperties").hide("slow");
                        }
                };

                self.storageChange = function() {
                        var batchSize = $("#product_batch_size").val();
                        var storage = $("#product_storage").val();
                        var sales = $("#productSales").val();
                        $("#storage").html(storage - sales);
                        if (batchSize && batchSize > 0) {
                                $("#avaiableCount").html(Math.floor((storage - sales) / batchSize));
                        }
                };

                self.check = function(e) {
                        if ($("#product_is_bulk")[0].checked) {
                                var batchSize = $("#product_batch_size").val();
                                var priceKM = $("#product_price_km").val();
                                var priceBJ = $("#product_price_bj").val();
                                var startDate = $("#product_start_date").val();
                                var minPrice = $("#product_min_price").val();
                                var maxPrice = $("#product_max_price").val();
                                if (batchSize && priceKM && priceBJ && startDate, minPrice, maxPrice) {
                                } else {
                                        alert("请将大宗商品信息填写完整！");
                                        return false;
                                }
                        }
                        return true;
                };

                return self;
        }();

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
