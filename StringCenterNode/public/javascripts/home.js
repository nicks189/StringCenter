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
    })
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
    }

    var getPosts = function(){
        return posts;
    }


    return {
        getNewsfeed : getNewsfeed,
        getPosts : getPosts
    };
});

app.controller('homeCtrl', function($scope, signInService, newsfeedService){
    //will be removed once sign in is implemented
    signInService.signIn();

    newsfeedService.getNewsfeed(newsfeed);

    function newsfeed(){
        $scope.posts = newsfeedService.getPosts();
        console.log($scope.posts);
        for(var i = 0; i < $scope.posts.length; i++){
            var date = new Date($scope.posts[i].dateCreated);
            $scope.posts[i].date = date.toLocaleDateString() + " "  + date.toLocaleTimeString();
        }
    }

});

app.controller('tabCtrl', function($scope){

});

app.controller('profileCtrl', function($scope){

});

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
