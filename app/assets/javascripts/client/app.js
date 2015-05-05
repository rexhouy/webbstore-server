'use strict';

/**
 * @ngdoc overview
 * @name webStore
 * @description
 * # webStore
 *
 * Main module of the application.
 */
angular
        .module('webStore', [
                'ngAnimate',
                'ngCookies',
                'ngMessages',
                'ngResource',
                'ngRoute',
                'ngSanitize',
                'ngTouch'
        ])
        .config(function ($routeProvider) {
                $routeProvider
                        .when('/', {
                                templateUrl: 'views/home.html',
                                controller: 'HomeCtrl'
                        })
                        .when('/detail', {
                                templateUrl: 'views/detail.html',
                                controller: 'DetailCtrl'
                        })
                        .when('/cart', {
                                templateUrl: 'views/cart.html',
                                controller: 'CartCtrl'
                        })
                        .when('/purchase', {
                                templateUrl: 'views/purchase.html',
                                controller: 'PurchaseCtrl'
                        })
                        .when('/address', {
                                templateUrl: 'views/address.html',
                                controller: 'AddressCtrl'
                        })
                        .when('/order', {
                                templateUrl: 'views/order.html',
                                controller: 'OrderCtrl'
                        })
                        .otherwise({
                                redirectTo: '/'
                        });
        })
        .directive('focusMe', function($timeout) { // Set focus on search
                return {
                        scope: { trigger: '=focusMe' },
                        link: function(scope, element) {
                                scope.$watch('trigger', function(value) {
                                        if(value === true) {
                                                $timeout(function() {
                                                        element[0].focus();
                                                        scope.trigger = false;
                                                });
                                        }
                                });
                        }
                };
        });
