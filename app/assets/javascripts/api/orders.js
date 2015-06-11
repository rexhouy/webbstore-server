'use strict';

/**
 * @ngdoc function
 * @name webStore.controller:OrderCtrl
 * @description
 * # OrderCtrl
 * Controller of the webStoreApp
 */
angular.module('webStore')
        .controller('OrderCtrl', ["$scope", "$location", "$templateCache", "$route", function ($scope, $location, $templateCache, $route) {
                $scope.toDetail = function(id) {
                        $location.path("/orders/"+id);
                };
	        $scope.cancel = function(id) {
		        $.ajax('/api/orders/'+id, {
			        method : 'post',
			        headers : {
				        'X-CSRF-Token' : utility.getCSRFtoken()
			        },
			        data : { _method : "put" }
		        }).done(function(data){
			        $templateCache.remove('/api/orders/'+id);
			        $scope.$apply();
		        });
	        };
        }]);
