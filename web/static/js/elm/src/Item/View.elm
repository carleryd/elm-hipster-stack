module Item.View (viewItems) where

import Html exposing (..)
import Html.Attributes exposing (class, style, href, target)
import Signal exposing (..)
import Model exposing (Model)
import Item.Model exposing (Item)
import Actions exposing (..)
import Regex


viewItem : Address Action -> Item -> Html
viewItem address item =
  li
    -- Should not need this. It is defined in Materialize CSS
    [ style [ ( "list-style-type", "none" ) ] ]
    [ div
        [ class "card-panel"
        , style [ ( "padding", "1em" ) ]
        ]
        [ a
            [ href item.url, target "_blank" ]
            [ text item.title ]
        , div
            [ class "truncate" ]
            [ span
                [ dateStyle ]
                [ text "DATUM" ]
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


viewItemList : Address Action -> List (Item) -> Html
viewItemList address itemList =
  itemList
    |> List.map (viewItem address)
    |> div []


viewItems : Address Action -> Model -> Html
viewItems address model =
  let
    itemsHtml =
      viewItemList address model.items
  in
    div
      []
      [ itemsHtml ]
