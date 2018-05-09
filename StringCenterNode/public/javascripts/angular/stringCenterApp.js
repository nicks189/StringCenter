var app = angular.module('stringCenterApp', ["ngRoute", "stringCenter"]);
angular.module('stringCenter');

app.config(['$httpProvider', function($httpProvider) {
    delete $httpProvider.defaults.headers.common["X-Requested-With"]
}]);


app.config(function($routeProvider) {
    $routeProvider
    .when("/", {
        templateUrl : "/home",
        controller : "homeCtrl"
    })
    .when("/tabs", {
        templateUrl : "/tabs",
        controller : "tabCtrl"
    })
    .when("/profile", {
        templateUrl : "/profile",
        controller : "profileCtrl"
    }).when('/view-tab',{
        templateUrl : "/view-tab",
        controller : "viewTabCtrl"
    });;
});
