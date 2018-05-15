# StringCenter

* StringCenter is a social media application that is centered around 
music, specifically guitars. StringCenter also allows users to do 
all of the expected social media activities, post to their page, 
create a public page or group, post to a group, follow others, 
look at other’s posts, get their news feed, etc. The difference 
with StringCenter, is that we created an in app ability to create 
guitar tabs on the fly, giving users a space to document the music 
they’ve learned and created. On the flipside, the user can search 
through all of the tabs ever created by the community, by name, 
allowing users to search up a song they want to learn and have the 
tab for it at their fingertips. 


* The community aspect of StringCenter is a huge focus, hoping to 
give users a chance to follow topics they are interested in. Right 
when the user logs in they will see their newsfeed, with the latest 
posts from both the users and the groups that they follow. In turn, 
they can also direct posts to a group, spreading their post, and 
potentially their tab, to everyone in the group.
    
* StringCenter features a mobile app using Dart and the Flutter 
framework, providing us with the ability to run the same code on 
both Android and IOS devices. On the backend, we used Node.js with 
it’s Express framework as the server, utilizing JSONWebTokens for 
the authentication. For the database that is accessed by the server, 
MongoDB with the Mongoose ORM was used, providing a fairly simple 
NOSQL way to query the needed data. A web based client is currently 
being developed with the AngularJS framework.
