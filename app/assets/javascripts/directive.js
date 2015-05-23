angular.module('webStore')
        .directive('focusMe', ['$timeout', function($timeout) { // Set focus on search
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
        }])
        .directive('saveMyContent', ['$templateCache', function($templateCache)
                           {
                                   return {
                                           restrict: 'A',
                                           compile:  function (element)
                                           {
                                                   $templateCache.put('tmp.html', element.html());
                                           }
                                   };
                           }]);
