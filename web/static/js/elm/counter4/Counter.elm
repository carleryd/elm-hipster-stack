module Counter (Model, init, Action, update, view, viewAction, viewRemove) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias Model =
  Int


init : Int -> Model
init count =
  count


type Action
  = Increment
  | Decrement


update : Action -> Model -> Model
update action model =
  case action of
    Increment ->
      model + 1

    Decrement ->
      model - 1


view : Signal.Address Action -> Model -> Html
view address model =
  div
    []
    [ button [ onClick address Decrement ] [ text "-" ]
    , div [ countStyle ] [ text (toString model) ]
    , button [ onClick address Increment ] [ text "+" ]
    ]



-- type alias Context =
--   { actions : Signal.Address Action
--   , remove : Signal.Address ()
--   }
-- view
--   viewAction actions : Signal.Address Action
--   viewRemove remove : Signal.Address ()


viewAction : Signal.Address Action -> Model -> List Html
viewAction actions model =
  -- div
  --   []
  [ button [ onClick actions Decrement ] [ text "-" ]
  , div [ countStyle ] [ text (toString model) ]
  , button [ onClick actions Increment ] [ text "+" ]
  , div [ countStyle ] []
  ]


viewRemove : Signal.Address () -> Model -> List Html
viewRemove remove model =
  -- div
  --   []
  [ button [ onClick remove () ] [ text "X" ] ]



-- viewWithRemoveButton : Context -> Model -> Html
-- viewWithRemoveButton context model =
--   div
--     []
--     [ button [ onClick context.actions Decrement ] [ text "-" ]
--     , div [ countStyle ] [ text (toString model) ]
--     , button [ onClick context.actions Increment ] [ text "+" ]
--     , div [ countStyle ] []
--     , button [ onClick context.remove () ] [ text "X" ]
--     ]


countStyle : Attribute
countStyle =
  style
    [ ( "font-size", "20px" )
    , ( "font-family", "monospace" )
    , ( "display", "inline-block" )
    , ( "width", "50px" )
    , ( "text-align", "center" )
    ]
