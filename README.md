Original App Design Project - README
===

# App Name TBD

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
2. [Technical Ambiguities](#Technical-Ambiguities)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)

## Overview
### Description
App Name TBD is a music focused social media app where users can share about their favorite artists, songs, playlists, review albums, and read posts from other users. Users can curate their own profile page to display their favorite artists and songs. 

### App Evaluation

- **Category:**
    - Social
- **Mobile:**
    - Camera implemented for profile photo
    - (optional/strech goals) push notifications for when others interact with posts, use microphone to identify songs
- **Story:**
    - Share your thoughts on artists, songs, albums, and playlists as well as read about what other people think about your musical favorites
- **Market:**
    - For those who love to talk about music and want a dedicated space just to discuss music
    - Quite a niche market, but provides quite a bit of value for people who don't want to go searching around all different kinds of social media spaces to see what people have to say about music
    - Also quite valuable for those who take pride in their music taste to show off
- **Habit:**
    - user can both create posts and consume/read other people's posts
    - could be used several times a day 
- **Scope:**
    - the description outlined above is a description of just the core features, the bare skeleton is quite limited, focused just on posting about music and user profiles (which is quite a basic social media app but to me is pretty interesting to develop)
        - core features that would be in skeleton version would be the ability to create an account, log in/log out, post about music, customize profile, follow other users, see other users posts, see other user's profiles, like other people's posts
    - lots of extra features could be added to make the app more complex and interesting (but are totally not necessary to the core function of the app)
        - be able to follow artists/albums/songs/playlists to automatically put posts about those artists from other users (even other users you don't follow) in main feed
        - linking app profile to spotify or last.fm profile to see info about how that user listens on those platforms
            - using spotify profile can also create custom curated playlists based on other user's playlists or other factors
        - implmenting a music recognition api (audd.io) to make a "to listen to" list

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can login and logout
* User can create an account 
* User can link their Spotify account to their account
* User can customize their profiles with a profile picture, their favorite artists and songs (use spotify api for artists and songs)
* User can post about music (use spotify api to help user choose the album/artist/song/playlist they want to talk about)
* User can follow other users
* User can search for other users
* User can see other user's profile pages
* User can see posts from other users in a feed
* User can like other user's posts

**Optional Nice-to-have Stories**

* User can comment on other user's posts
* User can reply to other user's comments on posts
* User can see details view of post including comments and replies
* User can see listening habits from Spotify account
* User can see push notifications when other users interact with their posts
* User can search for artist/songs/albums/playlists to see discussions about those items
* User can follow artists/songs/albums/playlists to get posts from even users they do not follow about those followed items
* User can see list of users they follow
* User can see list of users that follow them
* User can see who other users are following and who follow other users
* Users can link last.fm to see more detailed listening activity based on time periods
* Users can have a to listen to list
* User can add to to listen to list by identifying music from a microphone recording (sort of like Shazam)
* user can see friend recommendations based on music tastes

### 2. Screen Archetypes

* Log in screen
   * User can log in
* Registration screen
    * User can create a new account
    * user can connect spotify account to account
* Home feed screen
    * User can logout
    * User can see posts from other users in a feed
    * User can like other user's posts (double tap)
* Create Post screen
    * User can post about music 
* Search screen
    * user can search for other users
    * user can follow other users
* Profile (details) screen
    * user can see other user's profiles (and their own)
    * user can follow other users
* Spotify search screen
    * user searches through spotify api search feature to select music to post about

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home screen
* Search screen
* Profile screen (own user's profile details)

**Flow Navigation** (Screen to Screen)

* Log in screen
   * Home screen
   * Registration screen (if user doesn't already have an account)
* Registration screen
   * Home screen
* Home feed screen
    * Create post screen
    * Log in screen (if user logs out)
    * Profile screen (for other users)
    * (future version may have details view for posts)
* Search screen
    * profile screen (for other users)
* Profile (details screen)
    * N/A for now, may add a profile settings screen on own user's profile
* Create post screen
    * Spotify search screen
* Spotify search screen
    * Create post screen


## Technical Ambiguities
Ranked from most interesting (to me) to least interesting
1. Matching algorithim that matches users based on their music tastes (uses Spotify API to get information about users listening habits and somehow use that to match users to each other)
2. Add an audio recognition API and connect that to Spotify API to make a "to listen" to list based on clips of audio the user records or to give the user more information about a song they record a clip of (info of course from Spotify API)
3. Encrypt authorization token in Parse database to make each user's session more secure

## Wireframes

![](https://i.imgur.com/x0m0BlL.png)

## Schema 

### Models

#### Post

| Property | Type | Description |
| -------- | -------- | -------- |
| objectId | String | unique id for the user post (default field) |
| author | Pointer to User | the post's author|
| text | String | the post's text |
| spotifyID | String | the spotify ID for the music the post is talking about|
| type | String | type of music the post is talking about (artist/album/track) |
| likeCount | Number | the number of likes this post has |
| likedBy | Array | an array of user ids that have liked this post |
| createdAt | DateTime | the time the post was created at (default field) |
| updatedAt | DateTime | the time the post was updated at (default field) |

#### User

| Property       | Type   | Description                                                                                                   |
| -------------- | ------ | ------------------------------------------------------------------------------------------------------------- |
| objectId       | String | unique id for the user (default field)                                                                        |
| username       | String | user's username (default field)                                                                               |
| password       | String | user's password (default field)                                                                               |
| spotifyToken   | String | the authorization token from the user's spotify account                                                       |
|                |        |                                                                                                               |
| refreshToken   | String | the refresh token from the user's spotify account that allows us to extend validity of the authorzation token |
| favArtists     | Array  | array of JSON objects that have info on each top artist of the user (probably 5 artists only)                 |
| favSongs       | Array  | array of JSON objects that have info on each top song of the user (probably 5 songs only)                     |
| profilePicture | File   | the user's profile picture                                                                                    |
| following      | Array  | array of user ids that this user follows |

### Networking
- List of Parse network requests by screen (code snippets/examples for some still need to be worked out)
    - Log in screen
        - (GET) login user
        ```objective-c
        [PFUser logInWithUsernameInBackground:@"myname" password:@"mypass" block:^(PFUser *user, NSError *error) { 
            if (user) {
                  // Do stuff after successful login. 
            } else {
                  // The login failed. Check error to see why. 
            }
        }];
         ```
    - Registration screen
        - (POST) sign up new user
        ```objective-c
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
          if (!error) {   
              // Hooray! Let them use the app now.
          } else {   
              NSString *errorString = [error userInfo][@"error"];  
              // Show the errorString somewhere and let the user try again.
          }
      }];

        ```
    - Home feed screen
        - (GET) Query Posts from users that the current user follows
        - (PUT) When the current user likes/unlikes update the post 
    - Create posts screen
        - (POST) Create a new Post object
    - Search screen
        - (GET) Query Users based on username
    - Profile screen
        - (GET) Query logged in user (or whatever user we want to see if not current user)
        - (PUT) Update user's profile picture (if viewing current user's profile)
- Existing API endpoints
    - Spotify API
        - Base URL: https://api.spotify.com/v1/
            | HTTP Verb | Endpoint | Description |
            | -------- | -------- | -------- |
            | GET     | /search?q=query&type=type | Searches spotify api that relates to query of type type (track, artist, album)    |
