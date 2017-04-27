module App.View exposing (..)

import App.Types exposing (Model, Post, NewPost, DialogConfig, Msg(..))
import App.Utils exposing (bootstrap)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import String exposing (slice, length)
import Dialog
import List


styledWord : String -> Html Msg
styledWord str =
    let
        head =
            strong [] [ text (slice 0 1 str) ]

        tail =
            text (slice 1 (length str) str)
    in
        div [] [ head, tail ]


header : Html Msg
header =
    h4
        [ style
            [ ( "display", "flex" )
            , ( "white-space", "pre" )
            ]
        ]
        [ styledWord "Elm"
        , text ", "
        , styledWord "Phoenix"
        , text ", "
        , styledWord "PostgresQL"
        , text ", "
        , styledWord "GraphQL"
        ]


list : List Post -> Html Msg
list posts =
    div
        [ style
            [ ( "display", "flex" )
            , ( "flex-direction", "column" )
            ]
        ]
        (List.map postView posts)


postView : Post -> Html Msg
postView post =
    div
        [ style
            [ ( "display", "flex" )
            , ( "justify-content", "space-between" )
            ]
        ]
        [ div
            [ style
                [ ( "margin", "10px" )
                , ( "cursor", "pointer" )
                ]
            , onClick (OpenPost post.id)
            ]
            [ text post.title ]
        , button [ onClick (DeletePost post.id) ] [ text "X" ]
        ]


newPostButton : Html Msg
newPostButton =
    button
        [ class "btn btn-success"
        , onClick OpenCreateView
        ]
        [ text "New Post" ]


openDialog : Maybe Post -> Html Msg
openDialog maybeOpenedPost =
    case maybeOpenedPost of
        Just openedPost ->
            Dialog.view (Just (openDialogConfig openedPost))

        Nothing ->
            Dialog.view Nothing


openDialogConfig : Post -> Dialog.Config Msg
openDialogConfig openedPost =
    let
        header =
            Just (h3 [] [ text openedPost.title ])

        body =
            Just (p [] [ text openedPost.body ])

        footer =
            Just
                (button
                    [ class "btn btn-success"
                    , onClick ClosePost
                    ]
                    [ text "OK" ]
                )
    in
        { closeMessage = Just ClosePost
        , containerClass = Nothing
        , header = header
        , body = body
        , footer = footer
        }


createDialog : Maybe NewPost -> Html Msg
createDialog maybeNewPost =
    case maybeNewPost of
        Just newPost ->
            Dialog.view (Just (createDialogConfig newPost))

        Nothing ->
            Dialog.view Nothing


createDialogConfig : NewPost -> Dialog.Config Msg
createDialogConfig newPost =
    let
        header =
            Just (h3 [] [ text newPost.title ])

        body =
            Just (p [] [ text newPost.body ])

        footer =
            Just
                (button
                    [ class "btn btn-success"
                    , onClick (CreatePost newPost)
                    ]
                    [ text "CREATE" ]
                )
    in
        { closeMessage = Just ClosePost
        , containerClass = Nothing
        , header = header
        , body = body
        , footer = footer
        }


container : Model -> Html Msg
container model =
    div
        [ style
            [ ( "display", "flex" )
            , ( "flex-direction", "column" )
            , ( "justify-content", "center" )
            , ( "align-items", "center" )
            ]
        ]
        [ bootstrap
        , header
        , list model.posts
        , newPostButton
        , openDialog model.openedPost
        , createDialog model.newPost
        ]


root : Model -> Html Msg
root model =
    div
        [ style
            [ ( "display", "flex" )
            , ( "justify-content", "center" )
            ]
        ]
        [ container model ]
