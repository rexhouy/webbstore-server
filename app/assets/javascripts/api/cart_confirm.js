/**
 * @ngdoc function
 * @name webStore.controller:CartConfirmCtrl
 * @description
 * # CartConfirmCtrl
 * Controller of the webStore
 */
angular.module('webStore')
        .controller('CartConfirmCtrl', function ($scope, $rootScope, $http, $location, $templateCache, $route, $compile) {


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
                };

                (function init() {
                        // Payment
                        $scope.onlinePay = true;
                        // Address state list(select options)
                        $scope.states = getStates();
                        // Address city list by state(select options)
                        $scope.cities = [];
                        // User selected address
                        $scope.address = {
                                state : "",
                                city : ""
                        };
                        var firstAddress = document.getElementsByName("address_id")[0];
                        $scope.selectedAddress = firstAddress && firstAddress.value;
                })();


                $scope.stateChange = function() {
                        $scope.cities = findCitiesByState($scope.address.state);
                };

                $scope.saveAddress = function() {
                        $.ajax('/api/addresses', {
                                method : 'post',
                                headers : {
                                        'X-CSRF-Token' : utility.getCSRFtoken()
                                },
                                data : $("#new_address").serializeObject()
                        }).done(function(data){
                                if (data.success) {
                                        $("#addresses").append($compile($(data.data))($scope));
                                        $("#address_modal").modal("hide"); // Close dialog
                                        $("#new_address")[0].reset(); // Clear form
                                        $scope.selectedAddress = data.id;// Set as selected.
                                        $scope.$apply(); // Refresh view
                                } else {
                                        alert("保存地址失败");
                                }
                        });
                };

                var check = function() {
                        if (!$scope.selectedAddress) {
                                alert("请新建一个配送地址");
                                return false;
                        }
                        return true;
                };

                $scope.confirm = function() {
                        if (!check()) {
                                return;
                        }
                        $rootScope.layout.loading = true;
                        $scope.showError = false;
                        $.ajax('/api/orders', {
                                method : 'post',
                                headers : {
                                        "X-CSRF-Token" : utility.getCSRFtoken()
                                },
                                data : {
                                        addressId : $scope.selectedAddress,
                                        paymentType : $scope.onlinePay ? "online_pay" : "offline_pay"
                                }
                        }).done(function(data) {
                                if (data.success) {
                                        if ($scope.onlinePay) {
                                                $location.path("/orders/"+data.id); // to payment page
                                        } else {
                                                $location.path("/orders/all"); // to order page
                                        }
                                } else {
                                        $rootScope.layout.loading = false;
                                        $scope.showError = true;
                                        $scope.info = data.info;
                                        $scope.errors = data.errors;
                                }
                                $scope.$apply();
                        });

                };

        });
