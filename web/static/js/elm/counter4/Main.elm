module Main (..) where

import CounterList exposing (init, update, view)
import StartApp.Simple exposing (start)
import Html exposing (Html)


main : Signal Html
main =
  start
    { model = init
    , update = update
    , view = view
    }
