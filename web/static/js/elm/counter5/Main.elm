module Main (..) where

import Effects exposing (Never)
import RandomGif exposing (init, update, view)
import StartApp
import Task
import Html exposing (Html)


app : StartApp.App RandomGif.Model
app =
  StartApp.start
    { init = init "funny cats"
    , update = update
    , view = view
    , inputs = []
    }


main : Signal Html
main =
  app.html


port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
