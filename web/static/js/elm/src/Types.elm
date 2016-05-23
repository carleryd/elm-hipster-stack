module Types exposing (..)

import Item.Types
import GraphQL.Ahead as Ahead exposing (QueryLinksResult)


type alias Model =
    { items : List Item.Types.Model
    , item : Item.Types.Model
    , newItem : Item.Types.Model
    , searchStr : String
    }


type Msg
    = NoOp
    | NewQuery (Maybe QueryLinksResult)
    | UpdateSearch String
    | Add String
    | UpdateTitle String
    | UpdateUrl String


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
