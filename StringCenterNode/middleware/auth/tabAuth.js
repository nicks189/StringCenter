/*Tab object
{Tab} tab   tabObj = {"info":"This is a new tab","
*                                  measureCount":"1",
*                                  "measures":[{"info":"first measure",
*                                                 "tuning":"EADG",
*                                                 "stringCount":"4",
*                                                 "strings":[{"notes":["-","-","-","-"],"tuning":"E"},
*                                                            {"notes":["-","-","-","-"],"tuning":"A"},
*                                                            {"notes":["-","-","-","-"],"tuning":"D"},
*                                                            {"notes":["-","-","-","-"],"tuning":"G"}]
*                                              }]
*                               };
 */



/**
 * Validate that the tab object has the correct structure
 * @param  {Tab} tab   (see Tab object at top of file)
 * @return {boolean}   true if valid, false otherwise
 */
function validateTab(tab){
    if(tab && checkInfo(tab) && checkMeasureCount(tab) && tab.measures && tab.measures[0] && tab.measures[0].tuning){
        var tabTuning = tab.measures[0].tuning;
        for(var i = 0; i < tab.measureCount; i++){
            if(!validateMeasure(tab.measures[i], tabTuning)){
                return false;
            }
        }
        return true;
    } else{
        return false;
    }
}


/**
 * Checks if info field is present in object
 * @param  {TabOrMeasure} tabOrMeasure    A Tab or a Measure, to be checked for info field (see Tab object at top of file)
 * @return {boolean}                        true if tabOrMeasure contains an info, false otherwise
 */
function checkInfo(tabOrMeasure){
    if(tabOrMeasure && tabOrMeasure.info  != null && tabOrMeasure != undefined && tabOrMeasure.info.length < 1000){
        return true;
    } else{
        console.log("info is wrong");
        return false;
    }
}


/**
 * Checks that measure count matches actual measure count of tab
 * @param  {Tab} tab    (see Tab object at top of file)
 * @return {boolean}    true if tab contains a measure count, false otherwise
 */
function checkMeasureCount(tab){
    if(tab && tab.measureCount && tab.measureCount == tab.measures.length){
        return true;
    } else{
        console.log("tab measure count is wrong");
        return false;
    }
}


/**
 * Checks if measure is valid
 * @param  {Measure} measure           (see Tab object at top of file)
 * @param  {Array} tabTuning           array of characters repersenting the tuning of the instrument
 * @return {boolean}                   true if valid, false otherwise
 */
function validateMeasure(measure, tabTuning){
    if(checkInfo(measure) && checkStringCount(measure) && checkTuning(measure, tabTuning) && checkNoteCount(measure) && checkStringsTuning(measure, tabTuning)){
        return true;
    } else{
        console.log("invalid measure" + measure);
        return false;
    }
}


/**
 * Checks that stringCount matches the actual number of strings
 * @param  {Measure} measure    (see Tab object at top of file)
 * @return {boolean}            true if measure contains a stringCount, false otherwise
 */
function checkStringCount(measure){
    if(measure && measure.tuning && measure.stringCount && measure.strings && measure.tuning.length == measure.stringCount && measure.stringCount == measure.strings.length){
        return true;
    } else{
        console.log("invalid stringCount in " + measure);
        return false;
    }
}


/**
 * Checks that all measures have same tuning
 * @param  {Measure} measure          (see Tab object at top of file)
 * @param  {Array} tabTuning  array of characters repersenting the tuning of the instrument
 * @return {boolean}                  true if tuning is the same on every measure in the tab, false otherwise
 */
function checkTuning(measure, tabTuning){
    if(measure && measure.tuning && measure.tuning == tabTuning){
        return true;
    } else{
        console.log(measure.tuning, tabTuning);
        console.log("invalid tuning in measure " + measure);
        return false;
    }
}


/**
 * Checks that all strings have same amount of notes
 * @param  {Measure} measure (see Tab object at top of file)
 * @return {boolean}         if all strings in a measure have the same amount of notes, return true. Otherwise false.
 */
function checkNoteCount(measure){
    if(measure && measure.stringCount){
        for(var i = 0; i < measure.stringCount; i++){
            if(measure.strings && measure.strings[0] && measure.strings[i] && measure.strings[0].notes && measure.strings[i].notes && measure.strings[0].notes.length != measure.strings[i].notes.length){
              console.log("invalid note count in measure " + measure + " in string " + i);
              return false;
            }
        }
        return true;
    } else{
        return false;
    }
}


/**
 * Checks that the measure tuning matches the tab tuning
 * @param  {Measure} measure          (see Tab object at top of file)
 * @param  {Array} tabTuning  array of characters repersenting the tuning of the instrument
 * @return {boolean}                  true if measure tuning matches the tab tuning, otherwise false
 */
function checkStringsTuning(measure, tabTuning){
  var tuningCharArray = tabTuning.split("");
    if(measure && measure.stringCount && tuningCharArray.length == measure.stringCount){
        for(var i = 0; i < measure.stringCount; i++){
            if(measure.strings[i].tuning != tuningCharArray[i]){
                console.log("string " + i + " does not match tab tuning");
                return false;
            }
        }
        return true;
    }
}



module.exports = {valid : validateTab};
