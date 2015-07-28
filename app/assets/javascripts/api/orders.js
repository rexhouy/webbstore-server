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
	                $scope.$apply();
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
			        $route.reload();
		        });
	        };
	        $scope.wechatPay = function() {
		        var appId = $("#appId").val();
		        var redirectURI = encodeURIComponent("http://www.tenhs.com/api/orders/payment/wechat_redirect");
		        var orderId = $("#orderId").val();
		        var auth_url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid="+appId+"&redirect_uri="+redirectURI+"&response_type=code&scope=snsapi_base&state="+orderId+"#wechat_redirect";
		        window.location = auth_url;
	        };
        }]);
