'use strict';

/**
 * @ngdoc function
 * @name webStore.controller:CartCtrl
 * @description
 * # CartCtrl
 * Controller of the webStore
 */
angular.module('webStore')
        .controller('CartCtrl', ["$scope", "$rootScope", "$http", "$location", "$templateCache", "$route",
                                 function ($scope, $rootScope, $http, $location, $templateCache, $route) {
                                         $scope.remove = function(id, spec_id) {
                                                 $.ajax('/api/carts', {
                                                         method : 'post',
                                                         headers : {
                                                                 'X-CSRF-Token' : utility.getCSRFtoken()
                                                         },
                                                         data : {
                                                                 _method : "delete",
                                                                 id : id,
                                                                 spec_id : spec_id
                                                         }
                                                 }).done(function(data){
                                                         $templateCache.remove('/api/carts');
                                                         $route.reload();
                                                 });

                                         };

                                         window.cart = {
                                                 updateCount: function(select, id, spec_id) {
                                                         $.ajax('/api/carts', {
                                                                 method : 'post',
                                                                 headers : {
                                                                         'X-CSRF-Token' : utility.getCSRFtoken()
                                                                 },
                                                                 data : {
                                                                         _method : "put",
                                                                         id : id,
                                                                         spec_id : spec_id,
                                                                         count : select.value
                                                                 }
                                                         }).done(function(data){
                                                                 $templateCache.remove('/api/carts');
                                                                 $route.reload();
                                                         });
                                                 }
                                         };

                                 }]);
