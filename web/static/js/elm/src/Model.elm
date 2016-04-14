module Model (..) where

import Item.Model exposing (Item, ItemId)


type alias Model =
  { items : List Item
  , item : Item
  , nextId : ItemId
  , result : String
  }


dummyItems : List Item
dummyItems =
  [ Item 0 "E to the L to the M" "http://elm-lang.org/" ]


dummyLength : Int
dummyLength =
  List.length dummyItems


initialModel : Model
initialModel =
  { items = dummyItems
  , item = Item dummyLength "" ""
  , nextId = dummyLength
  , result = "No result yet..."
  }
