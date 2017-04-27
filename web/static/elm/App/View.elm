module App.View exposing (..)

import App.Types exposing (Model, Post, NewPost, DialogConfig, Msg(..))
import App.Utils exposing (bootstrap)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Keyed
import String exposing (slice, length)
import Dialog
import List
import InlineHover exposing (hover)
import Json.Decode


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
    div [ style [ ( "text-align", "center" ) ] ]
        [ h1 [] [ text "Elm Hipster Stack!" ]
        , h4
            [ style
                [ ( "display", "flex" )
                , ( "white-space", "pre" )
                , ( "margin-bottom", "30px" )
                ]
            ]
            [ text "Written in "
            , styledWord "Elm"
            , text ", "
            , styledWord "Phoenix"
            , text ", "
            , styledWord "PostgreSQL"
            , text " and "
            , styledWord "GraphQL"
            ]
        , hr [] []
        ]


list : List Post -> Html Msg
list posts =
    div
        [ style
            [ ( "display", "flex" )
            , ( "flex-direction", "column" )
            , ( "width", "500px" )
            ]
        ]
        [ h3
            [ style [ ( "text-align", "center" ) ] ]
            [ text "List of posts" ]
        , div [ style [ ( "list-style", "none" ) ] ] (List.map postRow posts)
        ]


{-| We need to use Html.Keyed.node here because otherwise the select
    event when pressing remove on items will bug.
-}
postRow : Post -> Html Msg
postRow post =
    let
        rowText =
            div
                [ style
                    [ ( "margin", "5px" )
                    ]
                ]
                [ text post.title ]

        rowRemoveButton =
            button
                [ style
                    [ ( "align-self", "center" )
                    , ( "outline-style", "none" )
                    ]
                , onWithOptions
                    "click"
                    { stopPropagation = True
                    , preventDefault = False
                    }
                    (Json.Decode.succeed (DeletePost post.id))
                ]
                [ text "X" ]

        rowContainer =
            Html.Keyed.node "li"
                [ onClick (OpenPost post.id)
                , class "list-group-item"
                , style
                    [ ( "padding", "3px 10px" )
                    , ( "cursor", "pointer" )
                    , ( "display", "flex" )
                    , ( "justify-content", "space-between" )
                    , ( "flex-direction", "row" )
                    ]
                ]
                [ ( post.id, rowText )
                , ( post.id, rowRemoveButton )
                ]
    in
        rowContainer


newPostButton : Html Msg
newPostButton =
    button
        [ class "btn btn-success"
        , style [ ( "margin", "10px" ) ]
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
            Just
                (h3
                    [ style [ ( "text-align", "center" ) ] ]
                    [ text openedPost.title ]
                )

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
            Just
                (h3 [ style [ ( "text-align", "center" ) ] ]
                    [ text "Create Post" ]
                )

        body =
            Just
                (div
                    [ style
                        [ ( "display", "flex" )
                        , ( "flex-direction", "column" )
                        , ( "justify-content", "center" )
                        ]
                    ]
                    [ input
                        [ placeholder "Title"
                        , onInput NewTitleChange
                        , class "form-control"
                        , style
                            [ ( "margin-bottom", "15px" )
                            , ( "padding", "5px" )
                            ]
                        ]
                        []
                    , textarea
                        [ placeholder "Body"
                        , onInput NewBodyChange
                        , rows 5
                        , class "form-control"
                        , style
                            [ ( "padding", "5px" ) ]
                        ]
                        []
                    ]
                )

        footer =
            Just
                (button
                    [ class "btn btn-success"
                    , onClick (CreatePost newPost)
                    ]
                    [ text "Create" ]
                )
    in
        { closeMessage = Just ClosePost
        , containerClass = Nothing
        , header = header
        , body = body
        , footer = footer
        }


root : Model -> Html Msg
root model =
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
