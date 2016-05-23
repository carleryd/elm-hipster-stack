module State exposing (..)

import Types exposing (Model, Msg(..))
import Item.State
import Item.Types
import GraphQL.Ahead as Ahead exposing (QueryLinksResult)
import Ports exposing (closeModal)
import Task


initialModel : Model
initialModel =
    { items = []
    , item = Item.State.initialModel
    , newItem = Item.State.initialModel
    , searchStr = ""
    }


toList queriedObject =
    queriedObject.store.linkConnection.edges


edgeToItem edge =
    Item.Types.Model (Maybe.withDefault "Missing title" edge.node.title)
        (Maybe.withDefault "Missing url" edge.node.url)
        (Maybe.withDefault "Missing createdAt" edge.node.createdAt)


getQuery sortString =
    Ahead.queryLinks { queryParam = sortString }
        |> Task.toMaybe
        |> Task.perform (\_ -> NoOp) NewQuery


createQuery linkInput =
    Ahead.createLinkMutation { input_0 = { url = "http://test.com", title = "Test1234", clientMutationId = "0" } }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model
            , Cmd.none
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
                , Cmd.none
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

        Add ->
            let
                newItems =
                    model.item :: model.items

                newModel =
                    { model
                        | items = newItems
                        , item = model.newItem
                    }
            in
                ( newModel
                , closeModal ()
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
                , Cmd.none
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
                , Cmd.none
                )
