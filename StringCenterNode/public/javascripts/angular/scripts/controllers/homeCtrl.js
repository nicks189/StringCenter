angular.module('stringCenter').controller('homeCtrl', function($scope, signInService, newsfeedService, viewTabService){
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
