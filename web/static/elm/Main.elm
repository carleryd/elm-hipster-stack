module Main exposing (..)

import Html exposing (Html, div, text)
import GraphQL.Request.Builder exposing (..)
import GraphQL.Request.Builder.Arg as Arg
import GraphQL.Request.Builder.Variable as Var
import GraphQL.Client.Http as GraphQLClient
import Task exposing (Task)


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


type alias PostsResponse =
    Result GraphQLClient.Error (List PostSummary)


type alias Model =
    Maybe PostsResponse


type Msg
    = ReceiveQueryResponse PostsResponse


init : ( Model, Cmd Msg )
init =
    ( Nothing, sendPostsQuery )


view : Model -> Html Msg
view model =
    div []
        [ model |> toString |> text ]


update : Msg -> Model -> ( Model, Cmd Msg )
update (ReceiveQueryResponse response) model =
    ( Just response, Cmd.none )


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
