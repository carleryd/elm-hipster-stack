module Counter (Model, init, Action, update, view) where

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Debug exposing (log)


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
      log "1. Counter update Increment: " (model + 1)

    Decrement ->
      log "1. Counter update Decrement: " (model - 1)


view : Signal.Address Action -> Model -> Html
view address model =
  div
    []
    -- an address is an opaque handle that identifies which signal a value
    -- should be sent to.
    -- Thanks to the hassle in CounterPair::view we now have the address
    -- of our own Actions.
    -- Does this mean we actually get a 'nudge' to this view function whenever
    -- an action of Counter::update is run? In that case we actually get this
    -- view updated when Increment and Decrement is run! Otherwise, if even
    -- possible, I suppose we would have had this view update when Reset,
    -- Top act or Bottom act were run.
    -- Signals, addresses, mailboxes, difficult stuff...
    [ button [ onClick address Decrement ] [ text "-" ]
    , div [ countStyle ] [ text (toString model) ]
    , button [ onClick address Increment ] [ text "+" ]
    ]


countStyle : Attribute
countStyle =
  style
    [ ( "font-size", "20px" )
    , ( "font-family", "monospace" )
    , ( "display", "inline-block" )
    , ( "width", "50px" )
    , ( "text-align", "center" )
    ]
