module Item.Model (..) where


type alias Item =
  { title : String
  , url : String
  , createdAt : String
  }


itemTemplate : Item
itemTemplate =
  Item "" "" ""
