module Actions (..) where

import Item.Model exposing (Item)
import GraphQL.Ahead as Ahead exposing (QueryLinksResult)


type Action
  = NoOp
  | NewQuery (Maybe QueryLinksResult)
  | UpdateSearch String
  | Add Item
  | UpdateTitle String
  | UpdateUrl String
