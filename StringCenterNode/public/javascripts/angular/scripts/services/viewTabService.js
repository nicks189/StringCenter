angular.module('stringCenter').service('viewTabService', function(){
    var viewedTab;
    var setViewedTab = function(vt){
        viewedTab = vt;
    }

    var getViewedTab = function(){
        return viewedTab;
    }

    return {
        setViewedTab : setViewedTab,
        getViewedTab : getViewedTab
    };
});
