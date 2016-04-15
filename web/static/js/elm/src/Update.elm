module Update (..) where

import Model exposing (Model, QueryResult, Edge)
import Item.Model exposing (Item)
import Actions exposing (..)
import Effects exposing (Effects)
import GraphQL.Ahead as Ahead exposing (QueryLinksResult)
import Task


closeModalMailbox : Signal.Mailbox ()
closeModalMailbox =
  Signal.mailbox ()


sendToCloseModalMailbox : Effects Action
sendToCloseModalMailbox =
  Signal.send closeModalMailbox.address ()
    |> Effects.task
    |> Effects.map (always NoOp)


toList : QueryResult (List Edge) b c d -> List Edge
toList queriedObject =
  queriedObject.store.linkConnection.edges


edgeToItem : Edge -> Item
edgeToItem edge =
  Item
    (Maybe.withDefault "Missing title" edge.node.title)
    (Maybe.withDefault "Missing url" edge.node.url)
    (Maybe.withDefault "Missing createdAt" edge.node.createdAt)


getQuery : String -> Effects.Effects Action
getQuery sortString =
  Ahead.queryLinks sortString
    |> Task.toMaybe
    |> Task.map NewQuery
    |> Effects.task


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    NoOp ->
      ( model
      , Effects.none
      )

    NewQuery maybeQuery ->
      let
        newItems =
          case maybeQuery of
            Just query ->
              let
                list =
                  toList query
              in
                List.map edgeToItem list

            Nothing ->
              []

        newModel =
          { model
            | items = newItems
          }
      in
        ( newModel
        , Effects.none
        )

    UpdateSearch str ->
      let
        newModel =
          { model
            | searchStr = str
          }
      in
        ( newModel
        , getQuery str
        )

    Add item ->
      let
        newItems =
          item :: model.items

        newModel =
          { model
            | items = newItems
            , item = model.newItem
          }
      in
        ( newModel
        , sendToCloseModalMailbox
        )

    UpdateTitle str ->
      let
        item =
          model.item

        updatedItem =
          { item | title = str }

        newModel =
          { model | item = updatedItem }
      in
        ( newModel
        , Effects.none
        )

    UpdateUrl str ->
      let
        item =
          model.item

        updatedItem =
          { item | url = str }

        newModel =
          { model | item = updatedItem }
      in
        ( newModel
        , Effects.none
        )
