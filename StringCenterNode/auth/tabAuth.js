var tabObj = {"info":"This is a new tab","measureCount":"1","measures":[{"info":"first measure","tuning":"EADG","stringCount":"4","strings":[{"notes":["-","-","-","-"],"tuning":"E"},{"notes":["-","-","-","-"],"tuning":"A"},{"notes":["-","-","-","-"],"tuning":"D"},{"notes":["-","-","-","-"],"tuning":"G"}]}]};

//validate tab
function validateTab(tab){
    if(tab && checkInfo(tab) && checkMeasureCount(tab) && tab.measures && tab.measures[0] && tab.measures[0].tuning){
        var tabTuning = tab.measures[0].tuning;
        for(var i = 0; i < tab.measureCount; i++){
          if(!validateMeasure(tab.measures[i], tabTuning)){
            throw err;
            return false;
          }
        }
        return true;
    } else{
        return false;
    }
}

//check if field exists and is smaller than 1000 characters
function checkInfo(tabOrMeasure){
    if(tabOrMeasure && tabOrMeasure.info && tabOrMeasure.info.length < 1000){
        return true;
    } else{
        console.log(tabOrMeasure + "info is wrong");
        return false;
    }
}

//checks that measure count matches actual measure count of tab
function checkMeasureCount(tab){
    if(tab && tab.measureCount && tab.measureCount == tab.measures.length){
        return true;
    } else{
        console.log("tab measure count is wrong");
        return false;
    }
}

//validate measure
function validateMeasure(measure, tabTuning){
    if(checkInfo(measure) && checkStringCount(measure) && checkTuning(measure, tabTuning) && checkNoteCount(measure) && checkStringsTuning(measure, tabTuning)){
        return true;
    } else{
        console.log("invalid measure" + measure);
        return false;
    }
}

//checks that stringCount matches the actual number of strings
function checkStringCount(measure){
    if(measure && measure.tuning && measure.stringCount && measure.strings && measure.tuning.length == measure.stringCount && measure.stringCount == measure.strings.length){
        return true;
    } else{
        console.log("invalid stringCount in " + measure);
        return false;
    }
}

//checks that all measures have same tuning
function checkTuning(measure, tabTuning){
  if(measure && measure.tuning && measure.tuning == tabTuning){
    return true;
  } else{
    console.log(measure.tuning, tabTuning);
    console.log("invalid tuning in measure " + measure);
    return false;
  }
}

//chekcs that all strings have same amount of notes
function checkNoteCount(measure){
    if(measure && measure.stringCount){
        for(var i = 0; i < measure.stringCount; i++){
            if(measure.strings && measure.strings[0] && measure.strings[i] && measure.strings[0].notes && measure.strings[1].notes && measure.strings[0].notes.length != measure.strings[i].notes.length){
              console.log("invalid note count in measure " + measure + " in string " + i);
              return false;
            }
        }
        return true;
    } else{
        return false;
    }
}

//checks that strings in measure have same tuning as the tab
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


console.log("result of validation on tab: " + validateTab(tabObj));

module.exports = {valid : validateTab};
