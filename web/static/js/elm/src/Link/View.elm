module Link.View exposing (viewLinks)

import Html exposing (..)
import Html.Attributes exposing (class, style, href, target)
import Types exposing (Model, Msg(..))
import Link.Model
import Regex


viewLink item =
    li
        -- Should not need this. It is defined in Materialize CSS
        [ style [ ( "list-style-type", "none" ) ] ]
        [ div
            [ class "card-panel"
            , style [ ( "padding", "1em" ) ]
            ]
            [ a [ href item.url, target "_blank" ]
                [ text item.title ]
            , div [ class "truncate" ]
                [ span [ dateStyle ]
                    [ text item.createdAt ]
                , a
                    [ href item.url
                    , urlStyle
                    ]
                    [ text (urlPrettify item.url) ]
                ]
            ]
        ]


regex : String -> String
regex =
    Regex.replace Regex.All (Regex.regex "^https?://|/$") (\_ -> " ")


urlPrettify : String -> String
urlPrettify url =
    url
        |> regex


urlStyle : Attribute
urlStyle =
    style
        [ ( "color", "#062" )
        , ( "fontSize", "0.85" )
        ]


dateStyle : Attribute
dateStyle =
    style
        [ ( "color", "#888" )
        , ( "fontSize", "0.7em" )
        , ( "marginRight", "0.5em" )
        ]


viewLinkList itemList =
    itemList
        |> List.map viewLink
        |> div []


viewLinks : Address Msg -> Model -> Html
viewLinks model =
    let
        itemsHtml =
            viewLinkList model.items
    in
        div []
            [ itemsHtml ]
