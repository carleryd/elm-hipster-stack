module Model (..) where

import Item.Model exposing (Item, ItemId)


type alias Model =
  { items : List Item
  , item : Item
  , nextId : ItemId
  }


dummyItems : List Item
dummyItems =
  []


dummyLength : Int
dummyLength =
  List.length dummyItems


initialModel : Model
initialModel =
  { items = dummyItems
  , item = Item dummyLength "" ""
  , nextId = dummyLength
  }
