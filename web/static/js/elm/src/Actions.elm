module Actions (..) where

import Item.Model exposing (ItemId)
-- import Http
import GraphQL.Ahead as Ahead exposing (QueryLinksResult)
-- import Effects exposing (..)


type Action
  = NoOp
  | NewQuery (Maybe QueryLinksResult)
  | Remove ItemId
  | Add
  | UpdateTitle String
  | UpdateUrl String
