module App.State exposing (..)

import App.Types exposing (Model, Msg(..), Post, NewPost, PostId)
import GraphQL.Request.Builder exposing (..)
import GraphQL.Request.Builder.Arg as Arg
import GraphQL.Request.Builder.Variable as Var
import GraphQL.Client.Http as GraphQLClient
import Task exposing (Task)


sendQueryRequest : Request Query a -> Task GraphQLClient.Error a
sendQueryRequest request =
    GraphQLClient.sendQuery "/api" request


sendMutationRequest : Request Mutation a -> Task GraphQLClient.Error a
sendMutationRequest request =
    GraphQLClient.sendMutation "/api" request


postsRequest : Request Query (List Post)
postsRequest =
    extract
        (field "posts"
            []
            (list
                (object Post
                    |> with (field "id" [] string)
                    |> with (field "title" [] string)
                    |> with (field "body" [] string)
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


createPostRequest : NewPost -> Request Mutation Post
createPostRequest newPost =
    let
        idVar =
            Var.required "id" .id Var.int

        titleVar =
            Var.required "title" .title Var.string

        bodyVar =
            Var.required "body" .body Var.string
    in
        extract
            (field "createPost"
                [ ( "userId", Arg.variable idVar )
                , ( "title", Arg.variable titleVar )
                , ( "body", Arg.variable bodyVar )
                ]
                (object Post
                    |> with (field "id" [] string)
                    |> with (field "title" [] string)
                    |> with (field "body" [] string)
                )
            )
            |> mutationDocument
            |> request
                { id = 1
                , title = newPost.title
                , body = newPost.body
                }


sendCreatePostMutation : NewPost -> Cmd Msg
sendCreatePostMutation post =
    sendMutationRequest (createPostRequest post)
        |> Task.attempt ReceiveCreateMutationResponse


deletePostRequest : PostId -> Request Mutation PostId
deletePostRequest postId =
    let
        idVar =
            Var.required "id" .id Var.int
    in
        extract
            (field "deletePost"
                [ ( "id", Arg.variable idVar ) ]
                (extract (field "id" [] string))
            )
            |> mutationDocument
            |> request
                { id = Result.withDefault 0 (String.toInt postId) }


sendDeletePostMutation : PostId -> Cmd Msg
sendDeletePostMutation postId =
    sendMutationRequest (deletePostRequest postId)
        |> Task.attempt ReceieveDeleteMutationResponse


initialModel : Model
initialModel =
    { posts = []
    , openedPost = Nothing
    , newPost = Nothing
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, sendPostsQuery )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceiveQueryResponse response ->
            let
                posts =
                    case response of
                        Ok result ->
                            result

                        Err err ->
                            []
            in
                ( { model | posts = posts }
                , Cmd.none
                )

        ReceiveCreateMutationResponse postResponse ->
            let
                posts1 =
                    case postResponse of
                        Ok post ->
                            model.posts ++ [ post ]

                        Err _ ->
                            model.posts
            in
                ( { model | newPost = Nothing, posts = posts1 }
                , Cmd.none
                )

        ReceieveDeleteMutationResponse deleteResponse ->
            let
                posts1 =
                    case deleteResponse of
                        Ok postId ->
                            List.filter (\p -> p.id /= postId) model.posts

                        Err err ->
                            Debug.log "Delete mutation failed!" model.posts
            in
                ( { model | posts = posts1 }, Cmd.none )

        OpenCreateView ->
            ( { model | newPost = Just (NewPost "" "") }
            , Cmd.none
            )

        CreatePost newPost ->
            let
                cmd =
                    if
                        ((String.length newPost.title)
                            > 0
                            && (String.length newPost.body)
                            > 0
                        )
                    then
                        sendCreatePostMutation newPost
                    else
                        Cmd.none
            in
                ( model, cmd )

        NewTitleChange str ->
            let
                newPost =
                    case model.newPost of
                        Just post ->
                            Just { post | title = str }

                        Nothing ->
                            Debug.log
                                "Problem with updating new post title!"
                                model.newPost
            in
                ( { model | newPost = newPost }, Cmd.none )

        NewBodyChange str ->
            let
                newPost =
                    case model.newPost of
                        Just post ->
                            Just { post | body = str }

                        Nothing ->
                            Debug.log
                                "Problem with updating new post body!"
                                model.newPost
            in
                ( { model | newPost = newPost }, Cmd.none )

        DeletePost postId ->
            ( model, sendDeletePostMutation postId )

        OpenPost id ->
            let
                idCheck id =
                    (\i -> i.id == id)

                openedPost =
                    List.head
                        (List.filter (idCheck id) model.posts)
            in
                ( { model | openedPost = openedPost }
                , Cmd.none
                )

        ClosePost ->
            ( { model | openedPost = Nothing, newPost = Nothing }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
