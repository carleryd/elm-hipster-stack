module Actions (..) where

import Item.Model exposing (ItemId)


type Action
  = NoOp
  | Remove ItemId
  | Add
  | UpdateTitle String
  | UpdateUrl String
