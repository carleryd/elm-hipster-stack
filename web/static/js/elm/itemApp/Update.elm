module Update (..) where

import Model exposing (..)
import Actions exposing (..)
import Item.Model exposing (Item)
import Effects exposing (Effects)


port closeModal : Signal ()
port closeModal =
  closeModalMailbox.signal


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

    Remove id ->
      ( { model
          | items =
              List.filter (\mappedItem -> id /= mappedItem.id) model.items
        }
      , Effects.none
      )

    Add ->
      let
        newItems =
          model.item :: model.items

        newItem =
          Item model.nextId "" ""

        newNextId =
          model.nextId + 1
      in
        ( { model
            | items = newItems
            , item = newItem
            , nextId = newNextId
          }
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
