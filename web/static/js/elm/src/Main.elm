module Main (..) where

import Signal exposing (..)
import Model exposing (Model, initialModel)
import Update exposing (update, getQuery, closeModalMailbox)
import View exposing (..)
import Effects
import Task
import Html exposing (Html)
import Actions exposing (..)


actionsMailbox : Signal.Mailbox (List Action)
actionsMailbox =
  Signal.mailbox []


oneActionAddress : Signal.Address Action
oneActionAddress =
  Signal.forwardTo actionsMailbox.address (\action -> [ action ])


init : String -> ( Model, Effects.Effects Action )
init sortString =
  ( initialModel
  , getQuery sortString
  )


modelSignal : Signal Model
modelSignal =
  Signal.map fst modelAndFxSignal


modelAndFxSignal : Signal.Signal ( Model, Effects.Effects Action )
modelAndFxSignal =
  let
    modelAndFx action ( previousModel, _ ) =
      update action previousModel

    modelAndManyFxs actions ( previousModel, _ ) =
      List.foldl modelAndFx ( previousModel, Effects.none ) actions

    initial =
      init ""
  in
    Signal.foldp modelAndManyFxs initial actionsMailbox.signal


fxSignal : Signal.Signal (Effects.Effects Action)
fxSignal =
  Signal.map snd modelAndFxSignal


taskSignal : Signal (Task.Task Effects.Never ())
taskSignal =
  Signal.map (Effects.toTask actionsMailbox.address) fxSignal


main : Signal Html
main =
  Signal.map (view oneActionAddress) modelSignal


port tasks : Signal (Task.Task Effects.Never ())
port tasks =
  taskSignal


port closeModal : Signal ()
port closeModal =
  closeModalMailbox.signal
