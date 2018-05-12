var app = angular.module('StringCenter', ["ngRoute"]);

app.config(['$httpProvider', function($httpProvider) {
    delete $httpProvider.defaults.headers.common["X-Requested-With"]
}]);

app.config(function($routeProvider) {
    $routeProvider
    .when("/", {
        templateUrl : "/create-tab",
        controller : "createTabInfoCtrl"
    })
    .when('/view-tab',{
        templateUrl : "/view-tab",
        controller : "viewTabCtrl"
    })
    .when('/create-measure',{
        templateUrl : "/create-measures",
        controller : "createMeasuresCtrl"
    });
});

/**
 * Util service for createTab allowing data sharing between controllers, returning various util functions.
 * @return {function} {getTabInfo, setTabInfo}
 */
app.service('tabService', function(){
    var info = {name : "", tuning : "", noteCount : 0, valid : false};
    var tab = null;
    var viewedTab = null;

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
        return (i.name && i.name.length < 100 && i.tuning && i.tuning.length >= 4 && i.noteCount && parseInt(i.noteCount) <= 32);
    }

    var setTab = function(t){
        tab = t;
    }

    var getTab = function(){
        return tab;
    }

    var setViewedTab = function(vt){
        viewedTab = vt;
    }

    var getViewedTab = function(){
        return viewedTab;
    }

    return {
        getTabInfo : getTabInfo,
        setTabInfo : setTabInfo,
        setTab : setTab,
        getTab : getTab,
        setViewedTab : setViewedTab,
        getViewedTab : getViewedTab
    };
});

app.controller('createTabInfoCtrl', function($scope, $location, tabService){
    /**
     * Starts the tab creation, changes page to createMeasure
     * @return {[type]} [description]
     */
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

app.controller('createMeasuresCtrl', function($scope, $http, tabService){
    $scope.tabInfo = tabService.getTabInfo();
    var tab = tabService.getTab();
    if(tab){
        $scope.tab = tab;
    } else{
        $scope.tab = new Tab($scope.tabInfo);
        tabService.setTab($scope.tab);
    }

    /**
     * update measure with index ameasureNum with the given measure
     * @param  {Measure} measure    new Measure object to replace measure at measureNum
     * @param  {int} measureNum index of measure
     * @return {}
     */
    $scope.updateMeasure = function(measure, measureNum){
        $scope.tab = tabService.getTab();
        if($scope.tab.measures[measureNum] && checkMeasure(measure) && $scope.tab.measures[measureNum].tuning === measure.tuning && $scope.tab.measures[measureNum].stringCount == measure.stringCount){
            $scope.tab.measures[measureNum] = measure;
        }
    }

    $scope.updateTab = function(){
        $scope.tab = tabService.getTab();
        for(var i = 0; i < $scope.tab.measures.length; i++){
            var measureInput = $scope.getMeasureInput(i);
            $scope.updateMeasure(measureInput, i);
        }
    }

    /**
     * Pull input from form for the current measure
     * @return {Measure} returns measure object filled with the information from the form for the current measure
     */
    $scope.getMeasureInput = function(measureNum){
        var infoID = "#measureInfo" + measureNum + "";
        var measureInfoInput = angular.element(infoID).val();
        if(!measureInfoInput){
            measureInfoInput = new String();
        }

        var measureInput = new Measure(measureInfoInput, $scope.tab.measures[measureNum].stringCount, $scope.tab.measures[measureNum].tuning);
        measureInput.initMeasure($scope.tab.measures[measureNum].strings[0].noteCount);

        for(var s = 0; s < $scope.tab.measures[measureNum].stringCount; s++){
            for(var n = 0; n < $scope.tab.measures[measureNum].strings[s].noteCount; n++){
                var noteInputID = "#measure" + measureNum + "string" + s + "note" + n;
                measureInput.strings[s].notes[n] = angular.element(noteInputID).val();
            }
        }
        return measureInput;
    }

    /**
     * fill current measure with input from the form via getMeasureInput
     * and updateMeasure. Increment the curMeasureNum and add a new measure to the tab.
     * Update tabService's version of the tab.
     * @return {}
     */
    $scope.addMeasure = function(){
        $scope.updateTab();
        var measure = new Measure(new String(), $scope.tab.measures[$scope.tab.measures.length - 1].stringCount, $scope.tab.measures[$scope.tab.measures.length - 1].tuning);
        measure.initMeasure($scope.tab.measures[0].strings[0].noteCount);
        $scope.tab.addMeasure(measure);
        tabService.setTab($scope.tab);
        console.log($scope.tab);
    }

    /**
     * preview tab, sets info for viewTabCtrl to use
     * @return {}
     */
    $scope.view = function(){
        $scope.updateTab();
        tabService.setTab($scope.tab);
        $scope.tabInfo = tabService.getTabInfo();

        var viewedTab = $scope.tab;
        viewedTab.formattedMeasures = getTabMeasures(viewedTab);
        tabService.setViewedTab(viewedTab);
    }

    $scope.finish = function(){
        //signIn will be removed once cookie with token is added
        var signInReq = {
            method : 'POST',
            url : "http://localhost:3000/api/sign-in",
            data: JSON.stringify({username : "zoomba", password : "topsecret"})
        }

        $http(signInReq).then(function(res){
            $scope.updateTab();
            tabService.setTab($scope.tab);
            $scope.tabInfo = tabService.getTabInfo();

            var createdTab = {tab_name : tabService.getTabInfo().name, tab : tabService.getTab()};
            var createTabReq = {
                method : 'POST',
                headers : {
                    authorization : "bearer " + res.data.token
                },
                url : 'http://localhost:3000/api/tab/createTab',
                data : createdTab
            }

            $http(createTabReq).then(function(r){
                console.log(r);
            });
        });
    }
});

app.controller('viewTabCtrl', function($scope, tabService){
    $scope.viewedTab = tabService.getViewedTab();
});

/**
 * returns a formatted version of all the measures in the given tab
 * @param  {Tab} tab tab to be formatted
 * @return {formattedMeasures} returns an array of formatted measures (info, strings);
 */
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
