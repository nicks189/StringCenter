angular.module('stringCenter').service('signInService', function($http){
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
