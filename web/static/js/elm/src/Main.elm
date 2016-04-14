module Main (..) where

import Signal exposing (..)
import Model exposing (Model, initialModel)
import Update exposing (..)
import View exposing (..)
import Effects
import Task exposing (..)
import Html exposing (Html)


-- import Http
import GraphQL.Ahead as Ahead exposing (QueryLinksResult)

import Actions exposing (..)


actionsMailbox : Signal.Mailbox (List Action)
actionsMailbox =
  Signal.mailbox []


oneActionAddress : Signal.Address Action
oneActionAddress =
  Signal.forwardTo actionsMailbox.address (\action -> [ action ])


modelSignal : Signal Model
modelSignal =
  Signal.map fst modelAndFxSignal


init : String -> ( Model, Effects.Effects Action )
init sortString =
  ( initialModel
  , getQuery sortString
  )


getQuery : String -> Effects.Effects Action
getQuery sortString =
  Ahead.queryLinks sortString
    |> Task.toMaybe
    |> Task.map NewQuery
    -- task (can't fail)
    |> Effects.task


modelAndFxSignal : Signal.Signal ( Model, Effects.Effects Action )
modelAndFxSignal =
  let
    modelAndFx action ( previousModel, _ ) =
      update action previousModel

    modelAndManyFxs actions ( previousModel, _ ) =
      List.foldl modelAndFx ( previousModel, Effects.none ) actions

    initial =
      init "k"
  in
    Signal.foldp modelAndManyFxs initial actionsMailbox.signal


main : Signal Html
main =
  Signal.map (view oneActionAddress) modelSignal


fxSignal : Signal.Signal (Effects.Effects Action)
fxSignal =
  Signal.map snd modelAndFxSignal


taskSignal : Signal (Task.Task Effects.Never ())
taskSignal =
  Signal.map (Effects.toTask actionsMailbox.address) fxSignal


port tasks : Signal (Task.Task Effects.Never ())
port tasks =
  taskSignal


port closeModal : Signal ()
port closeModal =
  closeModalMailbox.signal
