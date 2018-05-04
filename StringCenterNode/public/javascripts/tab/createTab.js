var app = angular.module('createTab', ["ngRoute"]);

app.config(['$httpProvider', function($httpProvider) {
    delete $httpProvider.defaults.headers.common["X-Requested-With"]
}]);

app.config(function($routeProvider) {
    $routeProvider
    .when("/", {
        templateUrl : "/create-tab",
        controller : "createTabInfoCtrl"
    })
    .when('/create-measure',{
        templateUrl : "/create-measure",
        controller : "createMeasureCtrl"
    });
});

app.controller('createTabInfoCtrl', function($scope, $http){
    $scope.start = function(){
        console.log($scope.input.tabName);
    }
});

app.controller('createMeasureCtrl', function($scope){
//TODO
})
