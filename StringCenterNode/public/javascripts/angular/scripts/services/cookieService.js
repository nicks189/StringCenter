angular.module('stringCenterApp').service('cookieService', function(){
    var setCookie = function(cname, data, expireDays){
        var d = new Date();
       d.setTime(d.getTime() + (expireDays*24*60*60*1000));
       var expires = "expires="+ d.toUTCString();
       document.cookie = cname + "=" + JSON.stringify(data) + ";" + expires + ";path=/";
    }

    var getCookieData = function(dataName){
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

    return {
        setCookie : setCookie,
        getCookie : getCookie
    };
});
