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

app.service('tabService', function(){
    var info = {name : "", tuning : "", noteCount : 0, valid : false};
    var curMeasureNum = 0;

    var setTabInfo = function(i){
        if(validTabInfo(i)){
            info = i;
            info.valid = true;
        } else {
            alert("Invalid info");
            info.valid = false;
        }
    }

    var getTabInfo = function(){
        return info;
    }

    function validTabInfo(i){
        return (i.name && i.name.length < 100 && i.tuning && i.tuning.length >= 4 && i.noteCount && parseInt(i.noteCount) < 32);
    }

    function setCurMeasureNum(num){
        curMeasureNum = num;
    }

    function getCurMeasureNum(){
        return curMeasureNum;
    }

    return {
        getTabInfo : getTabInfo,
        setTabInfo : setTabInfo,
        setCurMeasureNum : setCurMeasureNum,
        getCurMeasureNum : getCurMeasureNum
    };
});

app.controller('createTabInfoCtrl', function($scope, $location, tabService){
    $scope.start = function(){
        var tabInfo = {
            name : $scope.input.tabName,
            tuning : $scope.input.tuning,
            noteCount : $scope.input.noteCount
        };

        $scope.updateTabInfo(tabInfo);
    }

    $scope.updateTabInfo = function(tabInfo){
        tabService.setTabInfo(tabInfo);
        if(tabService.getTabInfo().valid){
            $location.url('/create-measure');
        }
    };
});

app.controller('createMeasureCtrl', function($scope, tabService){
    //TODO
    $scope.tabInfo = tabService.getTabInfo();
    $scope.tab = new Tab($scope.tabInfo);
    console.log(new Tab($scope.tabInfo) ,$scope.tabInfo);
    $scope.curMeasureNum = 0;
    tabService.setCurMeasureNum($scope.curMeasureNum);




    $scope.updateMeasure = function(measure, measureNum){
        if($scope.tab.measures[measureNum] && checkMeasure(measure) && $scope.tab.measures[measureNum].tuning === measure.tuning && $scope.tab.measures[measureNum].stringCount == measure.stringCount){
            $scope.tab.measures[measureNum] = measure;
        }
    }

    $scope.getMeasureInput = function(){
        var infoID = "#measureInfo" + tabService.getCurMeasureNum();
        var measureInfoInput = angular.element(infoID).val();
        var measureInput = new Measure(measureInfoInput, $scope.tab.measures[tabService.getCurMeasureNum()].stringCount, $scope.tab.measures[tabService.getCurMeasureNum()].tuning);
        measureInput.initMeasure($scope.tab.measures[tabService.getCurMeasureNum()].strings[0].noteCount);

        for(var s = 0; s < $scope.tab.measures[tabService.getCurMeasureNum()].stringCount; s++){
            for(var n = 0; n < $scope.tab.measures[tabService.getCurMeasureNum()].strings[s].noteCount; n++){
                var inputID = "#measure" + tabService.getCurMeasureNum() + "string" + s + "note" + n;
                measureInput.strings[s].notes[n] = angular.element(inputID).val();
            }
        }
        console.log()
        return measureInput;
    }

    //TODO
    $scope.addMeasure = function(){
        var measureInput = $scope.getMeasureInput();
        var curMeasureNum = tabService.getCurMeasureNum();
        $scope.updateMeasure(measureInput, curMeasureNum);
        curMeasureNum++;
        $scope.curMeasureNum = curMeasureNum;
        tabService.setCurMeasureNum($scope.curMeasureNum);
        var measure = new Measure("", $scope.tab.measures[curMeasureNum - 1].stringCount, $scope.tab.measures[curMeasureNum - 1].tuning);
        measure.initMeasure($scope.tab.measures[0].strings[0].noteCount);
        $scope.tab.addMeasure(measure);

        console.log($scope.tab);
    }
})
