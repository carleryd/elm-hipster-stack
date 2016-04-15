module Model (..) where

import Item.Model exposing (Item)


type alias Model =
  { items : List Item
  , item : Item
  , searchStr : String
  }


initialModel : Model
initialModel =
  { items = []
  , item = Item "" ""
  , searchStr = ""
  }
