var app = angular.module('tab', []);

app.config(['$httpProvider', function($httpProvider) {
    delete $httpProvider.defaults.headers.common["X-Requested-With"]
}]);

app.controller('tabCtrl', function($scope, $http){
    $scope.title = "Tabs";
    var signInReq = {
        method : 'POST',
        url : "http://localhost:3000/api/sign-in",
        data: JSON.stringify({username : "zoomba", password : "topsecret"})
    }

    $http(signInReq).then(function(res){
        console.log(res.data);
        var getTabsReq = {
            method : 'GET',
            headers : {
                authorization : "bearer " + res.data.token
            },
            url : 'http://localhost:3000/api/tab'
        }
        $scope.strings = [];

        $http(getTabsReq).then(function(res){
            $scope.tabs = formatTabsForDisplay(res);
        });
    });
});


function formatTabsForDisplay(res){
    for(var i = 0; i < res.data.tabs.length; i++){
        res.data.tabs[i].measures = getTabMeasures(res.data.tabs[i].tab);
    }
    return res.data.tabs;
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
