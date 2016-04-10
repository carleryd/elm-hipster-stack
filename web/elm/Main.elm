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
  , nextId : Int
  }


type Action
  = Remove ItemId
  | Add Item
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
    Remove itemEntryId ->
      model
      -- { model | items = [] }

    Add itemEntry ->
      { model
        | items = model.item :: model.items
        , item = { newItem | id = model.nextId }
        , nextId = model.nextId + 1
      }

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


viewBook : Item -> Html
viewBook { title, url } =
  div
    []
    [ div [ class "item-title" ] [ text title ]
    , a [ class "item-url", href url ] [ text url ]
    ]


viewBookList : List (Item) -> Html
viewBookList itemList =
  itemList
    |> List.map viewBook
    |> div [ class "item-collection-container" ]


viewItemBasket : Model -> Html
viewItemBasket model =
  let
    yourBasket =
      model.items
        -- This gets us just the values in a list
        |> viewBookList
  in
    div
      []
      [ h3 [] [ text "Elm Phoenix RethinkDB" ]
      , yourBasket
      ]


view : Address Action -> Model -> Html
view address model =
  let
    entry =
      dummyItem
  in
    div
      []
      [ viewItemBasket model
      , input
          [ placeholder "Enter Title" ]
          []
      , input
          [ placeholder "Enter URL" ]
          []
      , button
          [ onClick address (Add entry) ]
          [ text "Add" ]
      , button
          [ onClick address (Remove entry.id) ]
          [ text "Remove" ]
      -- , input
      --     [ class "new-todo"
      --     , placeholder "What needs to be done?"
      --     -- We'll explicitly set the value to the model's todo's title
      --     , value model.todo.title
      --     , autofocus True
      --     , onKeyPress address handleKeyPress
      --     ]
      --     []
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
