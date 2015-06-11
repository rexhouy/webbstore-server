'use strict';

/**
 * @ngdoc function
 * @name webStore.controller:ProductsCtrl
 * @description
 * # ProductsCtrl
 * Controller of the webStoreApp
 */
angular.module('webStore')
        .controller('ProductsCtrl', ["$scope", "$rootScope", "$http", "$location", "$templateCache", "$route", function ($scope, $rootScope, $http, $location, $templateCache, $route) {
                $scope.chooseSpecs = function() {
                        var hasSpecs = $("#specbar")[0];
                        if (hasSpecs) {
                                $scope.showSpecs = true;
                        } else {
                                $scope.addToCart();
                        }
                };

                $scope.addToCart = function() {
                        $rootScope.layout.loading = true;
                        var formData = $('#add_to_cart_form').serializeObject();
                        formData["spec_id"] = $scope.selectedSpec;
                        $.ajax('/api/carts/', {
                                method : 'post',
                                headers : {
                                        'X-CSRF-Token' : utility.getCSRFtoken()
                                },
                                data : formData
                        }).done(function(data){
                                $templateCache.remove('/api/carts');
                                $location.path('/carts');
                                $scope.$apply();
                        });
                };

                var page = 1;
                var hasProduct = true;
                $scope.products = [];
                $scope.loadProducts = function() {
                        if ($scope.loading || !hasProduct) {
                                return; // Wait loading finish
                        }
                        $scope.loading = true;
                        // Load new products
                        $http.get('/api/products/all?page='+page)
                                .success(function(data, status, headers, config) {
                                        if (!data) {
                                                alert("加载商品出错");
                                                return;
                                        }
                                        if (data.length == 0) {
                                                hasProduct = false;
                                        }
                                        data.forEach(function(product){
                                                $scope.products.push(product);
                                        });
                                        page++;
                                        $scope.loading = false;
                                })
                                .error(function(data, status, headers, config) {
                                        $scope.loading = false;
                                });
                };
        }]);
