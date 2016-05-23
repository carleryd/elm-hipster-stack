module Main exposing (..)

import Html.App
import State exposing (initialModel, update, getQuery)
import Types exposing (Model, Msg)
import View exposing (view)


init : String -> ( Model, Cmd Msg )
init sortString =
    ( initialModel
    , getQuery sortString
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch []


main : Program Never
main =
    Html.App.program
        { init = init ""
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
