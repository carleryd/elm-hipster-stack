module Main exposing (..)

import Html exposing (Html)
import App.Types exposing (Model, Msg(..))
import App.State exposing (init, update, subscriptions)
import App.View exposing (root)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = root
        , update = update
        , subscriptions = subscriptions
        }
