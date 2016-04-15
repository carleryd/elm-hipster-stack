module Model (..) where

import Item.Model exposing (Item, itemTemplate)


type alias Edge =
  { node :
      { id : Maybe String
      , title : Maybe String
      , url : Maybe String
      , createdAt : Maybe String
      }
  }


type alias QueryResult a b c d =
  { d
    | store :
        { c
          | linkConnection :
              { b
                | edges :
                    a
              }
        }
  }


type alias Model =
  { items : List Item
  , item : Item
  , newItem : Item
  , searchStr : String
  }


initialModel : Model
initialModel =
  { items = []
  , item = itemTemplate
  , newItem = itemTemplate
  , searchStr = ""
  }
