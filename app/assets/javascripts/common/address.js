window.address = (function() {
        var self = {};
        var editable = false;
        var selectable = false;

        self.closeModal = function() {
                $("#new_address")[0].reset(); // Clear form
                $("#address_modal").modal("hide");
        };
        var registerSelectable = function(obj) {
                obj.click(function(){
                        $("address").each(function() {
                                $(this).removeClass("selected");
                        });
                        obj.addClass("selected");
                });
        };

        var check = function() {
                try {
                        ["#address_name", "#address_tel", "#address_state", "#address_city", "#address_street"].forEach(function(id) {
                                if (!$(id).val()) {
                                        throw "请填写完地址信息再提交!";
                                }
                        });
                } catch(e) {
                        alert(e);
                        return false;
                }
                return true;
        };

        self.saveAddress = function() {
                if (!check()) {
                        return false;
                }
                var url = "/addresses";
                var address = $("#new_address").serializeObject();
                if (address["address[id]"]) {
                        address["_method"] = "put";
                        url += "/"+address["address[id]"];
                }
                $.ajax(url, {
                        method : 'post',
                        headers : {
                                'X-CSRF-Token' : utility.getCSRFtoken()
                        },
                        data : address
                }).done(function(data) {
                        if (data.success) {
                                var address = $(data.data);
                                if (!editable) {
                                        address.find(".row").remove();
                                }
                                $("#addresses").append(address);
                                $("#address_modal").modal("hide"); // Close dialog
                                $("#new_address")[0].reset(); // Clear form
                                if (selectable) {
                                        registerSelectable(address); // Register event
                                        address.click();// Set as selected.
                                }
                        } else {
                                alert("保存地址失败");
                        }
                });
        };

        var addresses = [{
                name : "云南",
                cities : ["昆明","曲靖","保山"]
        }, {
                name : "贵州",
                cities : ["贵阳","六盘水"]
        }];
        var getStates = function() {
                return addresses.map(function(address) {
                        return address.name;
                });
        };
        var findCitiesByState = function(state) {
                for (var i = 0; i < addresses.length; i++) {
                        if (addresses[i].name === state) {
                                return addresses[i].cities;
                        }
                }
                return [];
        };
        self.setValue = function(data) {
                $("#address_name").val(data.name);
                $("#address_tel").val(data.tel);
                $("#address_street").val(data.street);
                $("#address_state").val(data.state);
                self.stateChange();
                $("#address_city").val(data.city);
        };
        self.stateChange = function() {
                var selectedState = $("#address_state").val();
                var citySelector = $("#address_city");
                citySelector.empty();
                if (selectedState) {
                        citySelector.append("<option value=\"\"></option>");
                        findCitiesByState(selectedState).forEach(function(city) {
                                citySelector.append("<option value="+city+">"+city+"</option>");
                        });
                }
        };

        var initStateSelector = function() {
                var stateSelector = $("#address_state");
                stateSelector.empty();
                stateSelector.append($("<option value=\"\"></option>"));
                getStates().forEach(function(state) {
                        stateSelector.append($("<option value="+state+">"+state+"</option>"));
                });
        };

        self.init = function(isEditable, isSelectable) {
                initStateSelector();
                editable = isEditable ? true : false;
                selectable = isSelectable ? true : false;
                if (selectable) {
                        $("address").each(function() {
                                registerSelectable($(this));
                        });
                }
        };

        return self;
})();
