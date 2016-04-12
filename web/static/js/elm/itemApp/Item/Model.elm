module Item.Model (..) where


type alias Item =
  { id : ItemId
  , title : String
  , url : String
  }


type alias ItemId =
  Int
