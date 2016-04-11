module Actions (..) where

import Model exposing (ItemId)


type Action
  = Remove ItemId
  | Add
  | UpdateTitle String
  | UpdateUrl String
  | NoOp
