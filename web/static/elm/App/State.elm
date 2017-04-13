module App.State exposing (..)

import App.Types exposing (Model, Msg(..), PostSummary)
import GraphQL.Request.Builder exposing (..)
import GraphQL.Client.Http as GraphQLClient
import Task exposing (Task)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


sendQueryRequest : Request Query a -> Task GraphQLClient.Error a
sendQueryRequest request =
    GraphQLClient.sendQuery "/api" request


postsRequest : Request Query (List PostSummary)
postsRequest =
    extract
        (field "posts"
            []
            (list
                (object PostSummary
                    |> with (field "id" [] (nullable string))
                    |> with (field "title" [] (nullable string))
                    |> with (field "body" [] (nullable string))
                )
            )
        )
        |> queryDocument
        |> request
            {}


sendPostsQuery : Cmd Msg
sendPostsQuery =
    sendQueryRequest postsRequest
        |> Task.attempt ReceiveQueryResponse


init : ( Model, Cmd Msg )
init =
    ( Nothing, sendPostsQuery )


update : Msg -> Model -> ( Model, Cmd Msg )
update (ReceiveQueryResponse response) model =
    ( Just response, Cmd.none )
