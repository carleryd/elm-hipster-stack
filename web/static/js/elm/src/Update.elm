module Update (..) where

import Model exposing (..)
import Actions exposing (..)
import Item.Model exposing (Item)
import Effects exposing (Effects)


-- import GraphQL.Ahead as Ahead exposing (QueryLinksResult)


closeModalMailbox : Signal.Mailbox ()
closeModalMailbox =
  Signal.mailbox ()


sendToCloseModalMailbox : Effects Action
sendToCloseModalMailbox =
  Signal.send closeModalMailbox.address ()
    |> Effects.task
    |> Effects.map (always NoOp)


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    NoOp ->
      ( model
      , Effects.none
      )

    NewQuery maybeQuery ->
      let
        queryString =
          case maybeQuery of
            Just query ->
              toString query
            Nothing ->
              "Bad string"

        newModel =
          { model
            | result = queryString
          }
      in
        ( newModel
        , Effects.none
        )

    Remove id ->
      let
        newModel =
          { model
            | items =
                List.filter (\mappedItem -> id /= mappedItem.id) model.items
          }
      in
        ( newModel, Effects.none )

    Add ->
      let
        newItems =
          model.item :: model.items

        newItem =
          Item model.nextId "" ""

        newNextId =
          model.nextId + 1

        newModel =
          { model
            | items = newItems
            , item = newItem
            , nextId = newNextId
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
