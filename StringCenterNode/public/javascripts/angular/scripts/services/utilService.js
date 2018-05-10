angular.module('stringCenterApp').service('utilService', function($http){
    var getTabMeasures = function(tab){
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

    return {
        getTabMeasures : getTabMeasures
    };
});
