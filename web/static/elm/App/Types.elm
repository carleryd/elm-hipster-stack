module App.Types exposing (..)

import GraphQL.Client.Http as GraphQLClient
import Html exposing (Html)


type Msg
    = ReceiveQueryResponse PostsResponse
    | ReceiveCreateMutationResponse PostResponse
    | ReceieveDeleteMutationResponse DeletePostResponse
    | OpenCreateView
    | CreatePost NewPost
    | DeletePost PostId
    | OpenPost PostId
    | ClosePost


type alias PostsResponse =
    Result GraphQLClient.Error (List Post)


type alias PostResponse =
    Result GraphQLClient.Error Post


type alias DeletePostResponse =
    Result GraphQLClient.Error PostId


type alias PostId =
    String


type alias Model =
    { posts : List Post
    , openedPost : Maybe Post
    , newPost : Maybe NewPost
    }


type alias Post =
    { id : PostId
    , title : String
    , body : String
    }


type alias NewPost =
    { title : String
    , body : String
    }


type alias DialogConfig =
    { closeMessage : Maybe Msg
    , containerClass : Maybe String
    , header : Maybe (Html Msg)
    , body : Maybe (Html Msg)
    , footer : Maybe (Html Msg)
    }
