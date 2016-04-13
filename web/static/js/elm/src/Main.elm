module Main (..) where

import Signal exposing (..)
import Model exposing (Model, initialModel)
import Update exposing (..)
import View exposing (..)
import Effects exposing (Effects)
import Task exposing (..)
import StartApp exposing (start)
import Html exposing (Html)
import Http
import GraphQL.Ahead as Ahead exposing (QueryLinksResult)
import Actions exposing (..)


init : (Model, Effects Action)
init =
  let
    effects =
      Ahead.queryLinks "k"
        -- task (can fail)
        |>
          Task.toResult
        -- task (can't fail)
        |>
          Effects.task

    -- effect containing task
  in
    ( initialModel , effects )

app : StartApp.App Model
app =
  start
    { init = init
    , update = update
    , view = view
    , inputs = []
    }

main : Signal Html
main =
  app.html


port tasks : Signal (Task.Task Effects.Never ())
port tasks =
  app.tasks

port closeModal : Signal ()
port closeModal =
  closeModalMailbox.signal
