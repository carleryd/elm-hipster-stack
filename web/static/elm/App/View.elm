module App.View exposing (..)

import App.Types exposing (Model, PostSummary, Msg(..))
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


itemView : PostSummary -> Html Msg
itemView item =
    div
        [ style
            [ ( "margin", "10px" )
            , ( "cursor", "pointer" )
            ]
        , onClick (OpenItem item.id)
        ]
        [ text (Maybe.withDefault "no title" item.title) ]


a openedItem =
    let
        header =
            Just (h3 [] [ text (Maybe.withDefault "no title" openedItem.title) ])

        body =
            Just (p [] [ text (Maybe.withDefault "no body" openedItem.body) ])

        footer =
            Just
                (button
                    [ class "btn btn-success"
                    , onClick CloseItem
                    ]
                    [ text "OK" ]
                )
    in
        Just
            { closeMessage = Just CloseItem
            , containerClass = Nothing
            , header = header
            , body = body
            , footer = footer
            }


dialog : Maybe PostSummary -> Html Msg
dialog maybeOpenedItem =
    case maybeOpenedItem of
        Just openedItem ->
            Dialog.view (a openedItem)

        Nothing ->
            Dialog.view Nothing


asdf : PostSummary -> Html Msg
asdf item =
    let
        str =
            case item.title of
                Just title ->
                    title

                Nothing ->
                    "(no title)"
    in
        itemView item


list : List PostSummary -> Html Msg
list items =
    div
        [ style
            [ ( "display", "flex" )
            , ( "flex-direction", "column" )
            ]
        ]
        (List.map asdf items)


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
        , list model.items
        , dialog model.openedItem
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
