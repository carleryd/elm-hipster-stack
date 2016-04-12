module Main (..) where

-- import Html exposing (..)
-- import Signal exposing (..)

import Model exposing (..)
import Update exposing (..)
import View exposing (..)


-- import Actions exposing (..)

import Effects exposing (Effects)
import StartApp exposing (start)
import Task exposing (..)


-- inbox : Signal.Mailbox Action
-- inbox =
--   Signal.mailbox NoOp
--
--
-- actions : Signal Action
-- actions =
--   inbox.signal
--
--
-- model : Signal ( Model, Effects )
-- model =
--   Signal.foldp update initialModel actions
--
--
-- main : Signal Html
-- main =
--   Signal.map (view inbox.address) model


app =
  start
    { init = ( initialModel, Effects.none )
    , update = update
    , view = view
    , inputs = []
    }


main =
  app.html


port tasks : Signal (Task.Task Effects.Never ())
port tasks =
  app.tasks
