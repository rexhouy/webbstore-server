'use strict';

/**
 * @ngdoc function
 * @name webStore.controller:DetailCtrl
 * @description
 * # DetailCtrl
 * Controller of the webStore
 */
angular.module('webStore')
  .controller('DetailCtrl', ["$scope", "$location", function ($scope, $location) {

          (function init() {
                  $('.carousel').carousel({
                          interval: 4000
                  });
          })();

          $scope.buy = function() {
                  $location.path("/cart");
          };

  }]);
