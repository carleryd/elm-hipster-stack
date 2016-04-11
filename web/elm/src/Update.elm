module Update (..) where

import Model exposing (..)
import Actions exposing (..)


update : Action -> Model -> Model
update action model =
  case action of
    Remove id ->
      { model
        | items =
            List.filter (\mappedItem -> id /= mappedItem.id) model.items
      }

    -- { model | items = [] }
    Add ->
      { model
        | items = model.item :: model.items
        , item = { newItem | id = model.nextId }
        , nextId = model.nextId + 1
      }

    UpdateTitle str ->
      let
        item =
          model.item

        updatedItem =
          { item | title = str }

        newModel =
          { model | item = updatedItem }
      in
        newModel

    UpdateUrl str ->
      let
        item =
          model.item

        updatedItem =
          { item | url = str }

        newModel =
          { model | item = updatedItem }
      in
        newModel

    NoOp ->
      model
