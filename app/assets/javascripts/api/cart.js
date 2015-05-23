'use strict';

/**
 * @ngdoc function
 * @name webStore.controller:CartCtrl
 * @description
 * # CartCtrl
 * Controller of the webStore
 */
angular.module('webStore')
        .controller('CartCtrl', function ($scope, $rootScope, $http, $location, $templateCache, $route) {
                $scope.remove = function(id) {
                        $.ajax('/api/carts', {
                                method : 'post',
                                headers : {
                                        'X-CSRF-Token' : utility.getCSRFtoken()
                                },
                                data : {
                                        _method : "delete",
                                        id : id
                                }
                        }).done(function(data){
                                $templateCache.remove('/api/carts');
                                $route.reload();
                        });

                };

                window.cart = {
                        updateCount: function(select, id) {
                                $.ajax('/api/carts', {
                                        method : 'post',
                                        headers : {
                                                'X-CSRF-Token' : utility.getCSRFtoken()
                                        },
                                        data : {
                                                _method : "put",
                                                id : id,
                                                count : select.value
                                        }
                                }).done(function(data){
                                        $templateCache.remove('/api/carts');
                                        $route.reload();
                                });
                        }
                };

        });
