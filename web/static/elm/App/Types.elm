module App.Types exposing (..)

import GraphQL.Client.Http as GraphQLClient


type Msg
    = ReceiveQueryResponse PostsResponse
    | OpenItem (Maybe String)
    | CloseItem


type alias PostsResponse =
    Result GraphQLClient.Error (List PostSummary)


type alias Model =
    { response : Maybe PostsResponse
    , items : List PostSummary
    , openedItem : Maybe PostSummary
    }


type alias PostSummary =
    { id : Maybe String
    , title : Maybe String
    , body : Maybe String
    }
