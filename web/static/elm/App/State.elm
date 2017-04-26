module App.State exposing (..)

import App.Types exposing (Model, Msg(..), PostSummary)
import GraphQL.Request.Builder exposing (..)
import GraphQL.Client.Http as GraphQLClient
import Task exposing (Task)


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


initialModel : Model
initialModel =
    { response = Nothing
    , items = []
    , openedItem = Nothing
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, sendPostsQuery )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceiveQueryResponse response ->
            let
                items =
                    case response of
                        Ok result ->
                            result

                        Err err ->
                            []
            in
                ( { model | items = items }
                , Cmd.none
                )

        OpenItem maybeId ->
            let
                idCheck id =
                    (\i -> (Maybe.withDefault "LOL" i.id) == id)

                openedItem =
                    case maybeId of
                        Just id ->
                            List.head
                                (List.filter (idCheck id) model.items)

                        Nothing ->
                            Nothing
            in
                ( { model | openedItem = openedItem }
                , Cmd.none
                )

        CloseItem ->
            ( { model | openedItem = Nothing }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
