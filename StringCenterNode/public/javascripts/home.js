$(document).ready(function () {

    $('#sidebarCollapse').on('click', function () {
        $('#sidebar').toggleClass('active');
    });

});

var app = angular.module('home', ["ngRoute"]);

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
    })
});

app.controller('homeCtrl', function($scope){

});

app.controller('tabCtrl', function($scope){

});

app.controller('profileCtrl', function($scope){

});
