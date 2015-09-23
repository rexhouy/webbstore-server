window.address = (function() {
        var self = {};
        var editable = false;
        var selectable = false;
        var edit = false;

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

        self.saveOrCreate = function() {
                if (!check()) {
                        return false;
                }
                var url = "/addresses";
                var address = $("#new_address").serializeObject();
                var id = address["address[id]"];
                var isEdit = id;
                if (isEdit) {
                        address["_method"] = "put";
                        url += "/"+address["address[id]"];
                }
                $.ajax(url, {
                        method : "post",
                        headers : {
                                'X-CSRF-Token' : utility.getCSRFtoken()
                        },
                        data : address
                }).done(function(data) {
                        if (data.success) {
                                if (isEdit) { // edit
                                        var address = data.data;
                                        $("#address_"+id).find("[name=address_name]").html(address.name);
                                        $("#address_"+id).find("[name=address_tel]").html(address.tel);
                                        $("#address_"+id).find("[name=address_addr]").html(address.state.concat(address.city,address.street));
                                } else { // create
                                        var address = $(data.data);
                                        if (!editable) {
                                                address.find(".row").remove();
                                        }
                                        $("#addresses").append(address);
                                        if (selectable) {
                                                registerSelectable(address); // Register event
                                                address.click();// Set as selected.
                                        }
                                }
                                $("#address_modal").modal("hide"); // Close dialog
                                $("#new_address")[0].reset(); // Clear form
                        } else {
                                alert("保存地址失败");
                        }
                });
        };

        var addresses = [{
                name : "昆明",
                cities : ["五华区","盘龙区","官渡区","西山区","东川区","呈贡区"]
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
                $("#address_id").val(data.id);
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

        var setModalTitle = function(content) {
                $("#address_modal").find(".modal-title").html(content);
        };

        self.create = function() {
                setModalTitle("新建地址");
                $("#address_modal").modal();
        };

        self.edit = function(id) {
                $.getJSON("/addresses/"+id+".json", function(data){
                        setModalTitle("修改地址");
                        self.setValue(data);
                        $("#address_modal").modal();
                });
        };

        self.destroy = function(id) {
                $.ajax("/addresses/"+id, {
                        method : "post",
                        headers : {
                                'X-CSRF-Token' : utility.getCSRFtoken()
                        },
                        data : {
                                _method : "delete"
                        }
                }).done(function(data){
                        $("#address_"+id).slideUp(500, function() {
                                $("#address_"+id).remove();
                        });
                });
                return false;
        };


        return self;
})();
