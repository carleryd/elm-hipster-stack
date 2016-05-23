module Link.Model exposing (..)


type alias Model =
  { title : String
  , url : String
  , createdAt : String
  }


initialModel : Model
initialModel =
  Model "" "" ""
