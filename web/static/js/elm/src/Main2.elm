module Main (..) where

import StartApp as StartApp exposing (..)
import Task exposing (Task)
import Effects exposing (Effects)
import Html exposing (Html, div, button, text)
import Http
import GraphQL.Ahead as Ahead exposing (QueryLinksResult)


app : StartApp.App Model
app =
  start
    { init = init "k"
    , view = view
    , update = update
    , inputs = []
    }


test : Effects a
test =
  Effects.none


main : Signal Html
main =
  app.html


port tasks : Signal (Task Effects.Never ())
port tasks =
  app.tasks



-- type alias Action =
--   Result Http.Error QueryLinksResult


type Action
  = NewQuery (Maybe QueryLinksResult)


type alias Model =
  { result : String
  }

getQuery : String -> Effects Action
getQuery sortString =
  Ahead.queryLinks sortString
    -- task (can fail)
    |> Task.toMaybe -- .toResult
    |> Task.map NewQuery
    -- task (can't fail)
    |> Effects.task


init : String -> ( Model, Effects Action )
init sortString =
    ( Model "init result"
    , getQuery sortString
    )

view : Signal.Address Action -> Model -> Html
view address model =
  div
    []
    [ text ("Hej" ++ model.result) ]

update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    NewQuery maybeQuery ->
      let
        queryString =
          case maybeQuery of
            Just query ->
              toString query
            Nothing ->
              "Bad string"
      in
        ( Model queryString
        , Effects.none
        )
