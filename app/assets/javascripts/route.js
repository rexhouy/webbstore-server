angular
        .module('webStore').config(["$routeProvider", "$locationProvider", function($routeProvider, $locationProvider) {
                $routeProvider
                        .when('/', {
                                templateUrl: '/api/products',
                                controller: 'ProductsCtrl'
                        })
                        .when('/products/:id', {
                                templateUrl: function(attr){
                                        return '/api/products/' + attr.id;
                                },
                                controller: 'ProductsCtrl'
                        })
                        .when('/carts', {
                                templateUrl: '/api/carts',
                                controller: 'CartCtrl'
                        })
                        .when('/carts/confirm', {
                                templateUrl: '/api/carts/confirm',
                                controller: 'CartConfirmCtrl'
                        })
                        .when('/orders/:type/:page?', {
                                templateUrl: function(attr) {
                                        if ($.inArray(attr.type, ["all", "unfinished", "canceled"]) < 0) { // Detail page
                                                return '/api/orders/' + attr.type;
                                        } else { // List page
                                                attr.page = attr.page || 1;
                                                return '/api/orders?type='+attr.type+'&page=' + attr.page;
                                        }
                                },
                                controller: 'OrderCtrl'
                        })
                        .when('/me', {
                                templateUrl: '/api/me',
                                controller: 'MeCtrl'
                        })
                        .when('/address', {
                                templateUrl: '/api/addresses',
                                controller: 'AddressCtrl'
                        })
                        .when('/address/:id/edit', {
                                templateUrl: function(attr) {
                                        return "/api/addresses/"+attr.id+"/edit";
                                },
                                controller: 'AddressCtrl'
                        })
                        .when('/admin/product/preview', {
                                templateUrl: 'tmp.html'
                        });
                $locationProvider.html5Mode(true);
        }]);
