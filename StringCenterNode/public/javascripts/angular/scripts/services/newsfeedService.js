angular.module('stringCenter').service('newsfeedService', function($http){
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
