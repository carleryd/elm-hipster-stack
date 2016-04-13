module Actions (..) where

import Item.Model exposing (ItemId)
import Http
import GraphQL.Ahead as Ahead exposing (QueryLinksResult)
import Effects exposing (..)

type alias GraphQLAction =
  Result Http.Error QueryLinksResult

type Action
  = NoOp
  | Remove ItemId
  | Add
  | UpdateTitle String
  | UpdateUrl String
  | GraphQLAction Maybe QueryLinksResult
