module Main (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (..)


type alias Item =
  { id : ItemId
  , title : String
  , url : String
  }


type alias ItemId =
  Int


type alias Model =
  { items : List Item
  , item : Item
  , nextId : ItemId
  }


type Action
  = Remove ItemId
  | Add
  | UpdateTitle String
  | UpdateUrl String
  | NoOp


newItem : Item
newItem =
  { id = 0
  , title = ""
  , url = ""
  }


initialModel : Model
initialModel =
  { items = [ Item 0 "Elm language" "http://elm-lang.org/" ]
  , item = newItem
  , nextId = 1
  }


update : Action -> Model -> Model
update action model =
  case action of
    Remove id ->
      { model
        | items =
            List.filter (\mappedItem -> id /= mappedItem.id ) model.items
      }

    -- { model | items = [] }
    Add ->
      { model
        | items = model.item :: model.items
        , item = { newItem | id = model.nextId }
        , nextId = model.nextId + 1
      }

    UpdateTitle str ->
      let
        item = model.item
        updatedItem = { item | title = str }
        newModel = { model | item = updatedItem }
      in
        newModel

    UpdateUrl str ->
      let
        item = model.item
        updatedItem = { item | url = str }
        newModel = { model | item = updatedItem }
      in
        newModel

    NoOp ->
      model


dummyItem =
  Item 0 "Elm language" "http://elm-lang.org/"



-- handleKeyPress : Int -> Action
-- handleKeyPress code =
--   case code of
--     13 ->
--       Add mockTodo
--     _ ->
--       NoOp


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
        , on "input" targetValue
            (\str -> Signal.message address (UpdateTitle str))
        ]
        []
    , input
        [ placeholder "Enter URL"
        , value model.item.url
        , on "input" targetValue
            (\str -> Signal.message address (UpdateUrl str))
        ]
        []
    , button
        [ onClick address Add ]
        [ text "Add" ]
    ]


inbox : Signal.Mailbox Action
inbox =
  Signal.mailbox NoOp


actions : Signal Action
actions =
  inbox.signal


model : Signal Model
model =
  Signal.foldp update initialModel actions


main : Signal Html
main =
  Signal.map (view inbox.address) model
