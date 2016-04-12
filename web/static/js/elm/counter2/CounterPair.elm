module CounterPair (..) where

import Counter
import Html exposing (..)
import Html.Events exposing (..)
import Debug exposing (log)


type alias Model =
  { topCounter : Counter.Model
  , bottomCounter : Counter.Model
  }


init : Int -> Int -> Model
init top bottom =
  { topCounter = Counter.init top
  , bottomCounter = Counter.init bottom
  }


type Action
  = Reset
  | Top Counter.Action
  | Bottom Counter.Action


inbox : Signal.Mailbox Action
inbox =
  Signal.mailbox Reset


actions : Signal Action
actions =
  inbox.signal


update : Action -> Model -> Model
update action model =
  case action of
    Reset ->
      log "Reset" init 0 0

    Top act ->
      log
        "2. Pair-update"
        { model
          | topCounter = Counter.update act model.topCounter
        }

    Bottom act ->
      log
        "2. Pair-update"
        { model
          | bottomCounter = Counter.update act model.bottomCounter
        }


view : Signal.Address Action -> Model -> Html
view address model =
  div
    []
    -- The reason we KNOW that this (...) will give an address to whatever
    -- Action Top takes in as an argument.
    --      forwardTo : Address b -> (a -> b) -> Address a
    -- So in our case Top/Bottom takes in an action
    -- "An Address points to a specific signal."
    [ log "3. Pair-View Top " Counter.view (Signal.forwardTo address Top) 2
    , log "3. Pair-View Bottom " Counter.view (Signal.forwardTo address Bottom) model.bottomCounter
    , button [ onClick address Reset ] [ text "RESET" ]
    , text (toString model.topCounter)
    ]
