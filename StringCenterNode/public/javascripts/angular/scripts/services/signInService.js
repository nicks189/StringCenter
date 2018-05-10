angular.module('stringCenterApp').service('signInService', function($http, cookieService){
    //signIn will be removed once cookie with token is added
    var signIn = function(){
        var signInReq = {
            method : 'POST',
            url : "http://localhost:3000/api/sign-in",
            data: JSON.stringify({username : "zoomba", password : "topsecret"})
        }

        $http(signInReq).then(function(res){
            cookieService.setCookie("token", res.data.token, .1);
        });
    }

    return {signIn : signIn};
});
