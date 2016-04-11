module Model (..) where


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
