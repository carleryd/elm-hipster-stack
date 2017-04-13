module App.Types exposing (..)

import GraphQL.Client.Http as GraphQLClient


type Msg
    = ReceiveQueryResponse PostsResponse


type alias PostsResponse =
    Result GraphQLClient.Error (List PostSummary)


type alias Model =
    Maybe PostsResponse


type UserPosts
    = UserPosts (List PostSummary)


type alias UserSummary =
    { id : Maybe String
    , name : Maybe String
    , email : Maybe String
    , posts : UserPosts
    }


type alias PostSummary =
    { id : Maybe String
    , title : Maybe String
    , body :
        Maybe String
        -- , user : UserSummary
    }
