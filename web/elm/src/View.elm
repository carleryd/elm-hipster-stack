module View (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (..)
import Model exposing (Model, Item)
import Actions exposing (..)


viewItem : Address Action -> Item -> Html
viewItem address { id, title, url } =
  div
    []
    [ div [ class "item-title" ] [ text title ]
    , a [ class "item-url", href url ] [ text url ]
    , button
        [ onClick address (Remove id) ]
        [ text "Remove" ]
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
      [ h3 [] [ text "Elm Phoenix RethinkDB" ]
      , itemsHtml
      ]


view : Address Action -> Model -> Html
view address model =
  div
    []
    [ viewItems address model
    , input
        [ placeholder "Enter Title"
        , value model.item.title
        , on
            "input"
            targetValue
            (\str -> Signal.message address (UpdateTitle str))
        ]
        []
    , input
        [ placeholder "Enter URL"
        , value model.item.url
        , on
            "input"
            targetValue
            (\str -> Signal.message address (UpdateUrl str))
        ]
        []
    , button
        [ onClick address Add ]
        [ text "Add" ]
    ]
