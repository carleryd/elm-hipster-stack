module Update (..) where

import Model exposing (..)
import Actions exposing (..)
import Item.Model exposing (Item)
import Effects exposing (Effects)
import Html exposing (div, ul, li, text)
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


type alias QueryResult a b c d =
  { d | store : { c | linkConnection : { b | edges : a } } }


toList : QueryResult a b c d -> a
toList queriedObject =
  queriedObject.store.linkConnection.edges


edgeToItem edge =
  Item
    (default edge.node.title)
    (default edge.node.url)


default : Maybe String -> String
default maybeStuff =
  case maybeStuff of
    Just text ->
      text

    Nothing ->
      "Missing Value"


superListItem edge =
  ul
    []
    [ li [] [ text (default edge.node.id) ]
    , li [] [ text (default edge.node.url) ]
    , li
        []
        [ text (default edge.node.title)
        ]
    ]


addToModel adder item =
  default item


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

        newItem =
          Item "" ""

        newModel =
          { model
            | items = newItems
            , item = newItem
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
