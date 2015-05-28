/**
 * @ngdoc function
 * @name webStore.controller:CartConfirmCtrl
 * @description
 * # CartConfirmCtrl
 * Controller of the webStore
 */
angular.module('webStore')
        .controller('CartConfirmCtrl', ["$scope", "$rootScope", "$http", "$location", "$templateCache", "$route", "$compile", "addressService", function ($scope, $rootScope, $http, $location, $templateCache, $route, $compile, addressService) {

                (function init() {
                        // Payment
                        $scope.onlinePay = true;
                        // Address state list(select options)
                        $scope.states = addressService.getStates();
                        // Address city list by state(select options)
                        $scope.cities = [];
                        // User selected address
                        $scope.address = {
                                name : "",
                                tel : "",
                                state : "",
                                city : "",
                                street : ""
                        };
                        var firstAddress = document.getElementsByName("address_id")[0];
                        $scope.selectedAddress = firstAddress && firstAddress.value;
                })();

                $scope.stateChange = function() {
                        $scope.cities = addressService.findCitiesByState($scope.address.state);
                };

                $scope.closeModal = function() {
                        $("#new_address")[0].reset(); // Clear form
                        $("#address_modal").modal("hide");
                };

                $scope.saveAddress = function() {
                        addressService.save($("#new_address").serializeObject(), function(data) {
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

        }]);
