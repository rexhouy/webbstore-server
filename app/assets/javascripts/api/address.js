'use strict';

/**
 * @ngdoc function
 * @name webStore.controller:AddressCtrl
 * @description
 * # AddressCtrl
 * Controller of the webStoreApp
 */
angular.module('webStore')
        .controller('AddressCtrl', ["$scope", "$compile", "$templateCache", "$location", "$route", "addressService", function ($scope, $compile, $templateCache, $location, $route, addressService) {

                (function init(){
                        $scope.states = addressService.getStates();
                        // Address city list by state(select options)
                        $scope.cities = [];
                        $scope.address = {
                                id : "",
                                name : "",
                                tel : "",
                                state : "",
                                city : "",
                                street : ""
                        };
                        $scope.activeId = null;
                })();

                var clearForm = function() {
                        ["id", "name", "tel", "state", "city", "street"].forEach(function(attr) {
                                $scope.address[attr] = "";
                        });
                };

                $scope.stateChange = function() {
                        $scope.cities = addressService.findCitiesByState($scope.address.state);
                };

                $scope.saveAddress = function() {
                        var data = $("#new_address").serializeObject();
                        data["address[id]"] = $scope.activeId;
                        addressService.save(data, function(data) {
                                if (data.success) {
                                        $("#address_modal").modal("hide");
                                        clearForm();
                                        var html = $compile($(data.data))($scope).hide();
                                        $("#addresses").prepend(html);
                                        html.show("slow");
                                } else {
                                        alert("保存地址失败");
                                }
                        });
                };

                $scope.closeModal = function() {
                        clearForm();
                        $scope.activeId = null;
                        $("#address_modal").modal("hide");
                };

                $scope.edit = function(id) {
                        addressService.find(id, function(data) {
                                if (data) {
                                        $scope.address = data;
                                        $scope.stateChange();
                                        $scope.activeId = data.id;
                                        $scope.$apply();
                                        $("#address_modal").modal("show");
                                }
                        });
                };

                $scope.delete = function(id) {
                        addressService.delete(id, function(data) {
                                if (data.success) {
                                        var address = $("#address_"+data.id);
                                        address.hide("slow", function(){
                                                address.remove();
                                        });
                                }
                        });
                };

        }]);

angular.module('webStore')
        .factory("addressService", function () {
                var addresses = [{
                        name : "云南",
                        cities : ["昆明","曲靖","保山"]
                }, {
                        name : "贵州",
                        cities : ["贵阳","六盘水"]
                }];
                return {
                        getStates : function() {
                                return addresses.map(function(address) {
                                        return address.name;
                                });
                        },
                        findCitiesByState : function(state) {
                                for (var i = 0; i < addresses.length; i++) {
                                        if (addresses[i].name === state) {
                                                return addresses[i].cities;
                                        }
                                }
                                return [];
                        },
                        save : function(address, func) {
                                var url = "/api/addresses";
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
                                        func(data);
                                });
                        },
                        find : function(id, func) {
                                $.ajax('/api/addresses/'+id, {
                                        method : 'get'
                                }).done(function(data) {
                                        func(data);
                                });
                        },
                        update : function(address, func) {
                                address["_method"] = "put";
                                $.ajax('/api/addresses/'+address.id, {
                                        method : 'post',
                                        headers : {
                                                'X-CSRF-Token' : utility.getCSRFtoken()
                                        },
                                        data : address
                                }).done(function(data) {
                                        func(data);
                                });
                        },
                        delete : function(id, func) {
                                $.ajax('/api/addresses/'+id, {
                                        method : 'post',
                                        headers : {
                                                'X-CSRF-Token' : utility.getCSRFtoken()
                                        },
                                        data : { "_method" :  "delete"}
                                }).done(function(data) {
                                        func(data);
                                });
                        }
                };
        });
