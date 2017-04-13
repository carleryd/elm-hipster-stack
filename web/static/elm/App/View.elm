module App.View exposing (..)

import App.Types exposing (Model, Msg(..))
import Html exposing (Html, div, text)


view : Model -> Html Msg
view model =
    div []
        [ model |> toString |> text ]
