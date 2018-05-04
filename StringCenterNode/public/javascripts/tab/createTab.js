var app = angular.module('createTab', []);

app.config(['$httpProvider', function($httpProvider) {
    delete $httpProvider.defaults.headers.common["X-Requested-With"]
}]);

app.controller('createTabCtrl', function($scope, $http){
    
});
