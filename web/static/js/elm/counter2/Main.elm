module Main (..) where

import Html exposing (Html)
import CounterPair exposing (Model, actions, inbox, init, update, view)


initialModel : Model
initialModel =
  init 0 0


model : Signal Model
model =
  Signal.foldp update initialModel actions


main : Signal Html
main =
  Signal.map (view inbox.address) model



-- main : Signal Html
-- main =
--   start
--     { model = init 0 0
--     , update = update
--     , view = view
--     }
