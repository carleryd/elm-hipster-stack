module Actions (..) where

import Item.Model exposing (Item)
-- import Http
import GraphQL.Ahead as Ahead exposing (QueryLinksResult)
-- import Effects exposing (..)


type Action
  = NoOp
  | NewQuery (Maybe QueryLinksResult)
  | Add Item
  | UpdateTitle String
  | UpdateUrl String
