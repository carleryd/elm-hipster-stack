module Main (..) where

import Html exposing (..)
import Signal exposing (..)
import Model exposing (..)
import Update exposing (..)
import View exposing (..)
import Actions exposing (..)
import Effects exposing (Effects)
import Task exposing (..)


actionsMailbox : Signal.Mailbox (List Action)
actionsMailbox =
  Signal.mailbox []


oneActionAddress : Signal.Address Action
oneActionAddress =
  Signal.forwardTo actionsMailbox.address (\action -> [ action ])


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
      ( initialModel, Effects.none )
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


port closeModal : Signal ()
port closeModal =
  closeModalMailbox.signal


port tasks : Signal (Task.Task Effects.Never ())
port tasks =
  taskSignal



-- app =
--   start
--     { init = ( initialModel, Effects.none )
--     , update = update
--     , view = view
--     , inputs = []
--     }
-- main =
--   app.html
