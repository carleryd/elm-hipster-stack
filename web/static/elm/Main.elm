module Main exposing (..)

import Html exposing (Html)
import App.Types exposing (Model, Msg(..))
import App.State exposing (init, update, subscriptions)
import App.View exposing (view)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
