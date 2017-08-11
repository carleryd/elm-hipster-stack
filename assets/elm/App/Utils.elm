module App.Utils exposing (..)

import Html exposing (Html, node)
import Html.Attributes exposing (href, rel)


bootstrap : Html msg
bootstrap =
    node "link"
        [ href "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
        , rel "stylesheet"
        ]
        []
