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
    }).when('/view-tab',{
        templateUrl : "/view-tab",
        controller : "viewTabCtrl"
    });;
});

app.service('viewTabService', function(){
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

app.service('signInService', function($http){
    //signIn will be removed once cookie with token is added
    var signIn = function(){
        var signInReq = {
            method : 'POST',
            url : "http://localhost:3000/api/sign-in",
            data: JSON.stringify({username : "zoomba", password : "topsecret"})
        }

        $http(signInReq).then(function(res){
            setCookie("token", res.data.token, .1);
        });
    }

    return {signIn : signIn};
});

app.service('newsfeedService', function($http){
    var posts = [];
    var formattedPosts = [];

    var getNewsfeed = function(callback){
        var token = getCookieData("token");

        var getNewsfeedReq = {
            method : 'GET',
            headers : {
                authorization : "bearer " + token
            },
            url : "http://localhost:3000/api/newsfeed"
        }

        $http(getNewsfeedReq)
        .then(function(res){
            setPosts(res.data.posts);
        }).then(callback);
    }

    function setPosts(p){
        posts = p;
        var fp = formatPosts(posts);
        setFormattedPosts(fp);
    }

    var getPosts = function(){
        return posts;
    }

    function setFormattedPosts(fp){
        formattedPosts = fp;
    }

    var getFormattedPosts = function(){
        return formattedPosts;
    }

    function formatPosts(p){
        var formattedPosts = [];
        for(var i = 0; i < p.length; i++){
            var formattedPost = {authorUsername : "", date : "", content : "", groupName : [], tab : []};

            var date = new Date(p[i].dateCreated);
            formattedPost.date = date.toLocaleDateString() + " "  + date.toLocaleTimeString();
            if(p[i].groupName){
                formattedPost.groupName.push(p[i].groupName);
            }
            if(p[i].tab){
                p[i].tab.formattedMeasures = getTabMeasures(p[i].tab.tab);
                formattedPost.tab.push(p[i].tab);
            }
            formattedPost.authorUsername = p[i].authorUsername;
            formattedPost.content = p[i].content;
            formattedPosts.push(formattedPost);
        }
        return formattedPosts;
    }

    return {
        getNewsfeed : getNewsfeed,
        getPosts : getPosts,
        getFormattedPosts : getFormattedPosts
    };
});

app.controller('homeCtrl', function($scope, signInService, newsfeedService, viewTabService){
    //will be removed once sign in is implemented
    signInService.signIn();

    newsfeedService.getNewsfeed(newsfeed);

    function newsfeed(){
        $scope.posts = newsfeedService.getPosts();
        $scope.formattedPosts = newsfeedService.getFormattedPosts();
    }

    $scope.viewTab = function(postIndex){
        viewTabService.setViewedTab(newsfeedService.getFormattedPosts()[postIndex].tab);
    }

});

app.controller('tabCtrl', function($scope){

});

app.controller('profileCtrl', function($scope){

});

app.controller('viewTabCtrl', function($scope, viewTabService){
    $scope.tab = viewTabService.getViewedTab()[0];
    console.log($scope.tab);
});

function getTabMeasures(tab){
    var measures = [];
    for(var i = 0; i < tab.measureCount; i++){
        var measure = {info : "", strings : []};
        measure.info = "Measure " + (i+1) + ": " + tab.measures[i].info;
        for(var j = tab.measures[0].stringCount - 1; j >= 0; j--){
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


function setCookie(cname, data, expireDays){
    var d = new Date();
   d.setTime(d.getTime() + (expireDays*24*60*60*1000));
   var expires = "expires="+ d.toUTCString();
   document.cookie = cname + "=" + JSON.stringify(data) + ";" + expires + ";path=/";
}

function getCookieData(dataName){
    var name = dataName + "=";
    var decodedCookie = decodeURIComponent(document.cookie);
    var ca = decodedCookie.split(";");
    for(var i = 0; i <ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            return c.substring(name.length + 1, c.length - 1);
        }
    }

    return null;
}
