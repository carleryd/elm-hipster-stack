module Main (..) where

import StartApp as StartApp exposing (..)
import Task exposing (Task)
import Effects exposing (Effects)
import Html exposing (Html, div, button, text)
import Http
import GraphQL.Ahead as Ahead exposing (QueryLinksResult)


app =
  start { init = init, view = view, update = update, inputs = [] }


main =
  app.html


port tasks : Signal (Task Effects.Never ())
port tasks =
  app.tasks


type alias Action =
  Result Http.Error QueryLinksResult


type alias Model =
  Maybe QueryLinksResult


init : ( Model, Effects Action )
init =
  let
    effects =
      Ahead.queryLinks "k"
        -- task (can fail)
        |>
          Task.toResult
        -- task (can't fail)
        |>
          Effects.task

    -- effect containing task
  in
    ( Nothing, effects )


view : Signal.Address action -> Model -> Html
view address model =
  case model of
    Just res ->
      text (toString res)

    Nothing ->
      text "no result yet"



-- todo: add failure as a 3rd state w/reason


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    Ok res ->
      ( Just res, Effects.none )

    Err e ->
      ( Nothing, Effects.none )
