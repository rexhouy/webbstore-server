// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require bootstrap-sprockets
//= require turbolinks
//= require bootstrap-wysihtml5
//= require ng-infinite-scroll.min.js
//= require_self
//= require route
//= require directive
//= require_tree ./api

'use strict';

/**
 * @ngdoc overview
 * @name webStore
 * @description
 * # webStore
 *
 * Main module of the application.
 */

var app = angular
        .module('webStore', [
                'ngAnimate',
                'ngRoute',
                'infinite-scroll'
        ])
        .run(['$rootScope', '$location', '$route', '$timeout', '$templateCache', function ($rootScope, $location,$route, $timeout, $templateCache) {
                /**
                 * Route change animation
                 */
                $rootScope.layout = {loading: false};
                $rootScope.$on('$routeChangeStart', function () {
                        //show loading gif
                        $timeout(function(){
                                $rootScope.layout.loading = true;
                        });
                });
                $rootScope.$on('$routeChangeSuccess', function () {
                        //hide loading gif
                        $timeout(function(){
                                $rootScope.layout.loading = false;
                        }, 200);
                });
                $rootScope.$on('$routeChangeError', function () {
                        //hide loading gif
                        $rootScope.layout.loading = false;
                });

                /**
                 * Disable cache
                 */
                $rootScope.$on('$routeChangeStart', function(event, next, current) {
                        if (typeof(current) !== 'undefined'){
                                $templateCache.remove(current.templateUrl);
                        }
                });

                /**
                 * Search
                 */
                $rootScope.searchText = "";
                $rootScope.search = function() {
                        if ($rootScope.searchText) {
                                $location.path("/search").search("text", $rootScope.searchText);
                        }
                };
        }]);

/**
 * Extend jQuery
 */
$.fn.serializeObject = function()
{
        var o = {};
        var a = this.serializeArray();
        $.each(a, function() {
                if (o[this.name] !== undefined) {
                        if (!o[this.name].push) {
                                o[this.name] = [o[this.name]];
                        }
                        o[this.name].push(this.value || '');
                } else {
                        o[this.name] = this.value || '';
                }
        });
        return o;
};

window.utility = {
        getCSRFtoken : function() {
                return $( 'meta[name="csrf-token"]' ).attr( 'content' );
        }
};
