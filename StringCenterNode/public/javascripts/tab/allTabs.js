var app = angular.module('StringCenter', ["ngRoute"]);

app.config(['$httpProvider', function($httpProvider) {
    delete $httpProvider.defaults.headers.common["X-Requested-With"]
}]);

app.config(function($routeProvider) {
    $routeProvider
    .when("/", {
        templateUrl : "/all-tabs",
        controller : "allTabsCtrl"
    })
    .when('/view-tab',{
        templateUrl : "/view-tab",
        controller : "viewTabCtrl"
    });
});

app.controller('allTabsCtrl', function($scope, $http){
    $scope.title = "Tabs";
    var signInReq = {
        method : 'POST',
        url : "http://localhost:3000/api/sign-in",
        data: JSON.stringify({username : "zoomba", password : "topsecret"})
    }

    $http(signInReq).then(function(res){
        var getTabsReq = {
            method : 'GET',
            headers : {
                authorization : "bearer " + res.data.token
            },
            url : 'http://localhost:3000/api/tab'
        }

        $http(getTabsReq).then(function(res){
            $scope.tabs = formatTabsForDisplay(res.data.tabs);
        });
    });

    $scope.view = function(index){
        localStorage.setItem('viewedTab', JSON.stringify($scope.tabs[index]));
    }
});

app.controller('viewTabCtrl', function($scope){
    $scope.tab = JSON.parse(localStorage.getItem('viewedTab'));
});

function formatTabsForDisplay(tabs){
    for(var i = 0; i < tabs.length; i++){
        tabs[i].formattedMeasures = getTabMeasures(tabs[i].tab);
    }
    return tabs;
}


function getTabMeasures(tab){
    var measures = [];
    for(var i = 0; i < tab.measureCount; i++){
        var measure = {info : "", strings : []};
        measure.info = "Measure " + (i+1) + ": " + tab.measures[i].info;
        for(var j = 0; j < tab.measures[0].stringCount; j++){
            var instStringToBePrinted = tab.measures[i].strings[j].tuning + " ";
            for(var k = 0; k < tab.measures[0].strings[0].notes.length; k++){
                instStringToBePrinted += tab.measures[i].strings[j].notes[k];
            }
            measure.strings.push(instStringToBePrinted);
        }
        measures.push(measure);
    }
    return measures;
}
