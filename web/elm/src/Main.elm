module Main (..) where

import Html exposing (..)
import Signal exposing (..)
import Model exposing (..)
import Update exposing (..)
import View exposing (..)
import Actions exposing (..)


inbox : Signal.Mailbox Action
inbox =
  Signal.mailbox NoOp


actions : Signal Action
actions =
  inbox.signal


model : Signal Model
model =
  Signal.foldp update initialModel actions


main : Signal Html
main =
  Signal.map (view inbox.address) model
