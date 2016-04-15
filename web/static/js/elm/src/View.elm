module View (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, targetValue, onClick, onSubmit, onWithOptions)
import Signal
import Actions exposing (..)
import Model exposing (Model)
import Item.View exposing (viewItems)
import Json.Decode


onSubmitOptions : { preventDefault : Bool, stopPropagation : Bool }
onSubmitOptions =
  { stopPropagation = True
  , preventDefault = True
  }


onSubmitWithOptions : Html.Events.Options -> Signal.Address a -> a -> Attribute
onSubmitWithOptions options addr msg =
  onWithOptions
    "submit"
    options
    Json.Decode.value
    (\_ -> Signal.message addr msg)


view : Signal.Address Action -> Model -> Html
view address model =
  let
    searchField =
      div
        [ class "input-field" ]
        [ input
            [ id "search"
            , type' "text"
            , value model.searchStr
            , on
                "input"
                targetValue
                (\str -> Signal.message address (UpdateSearch str))
            ]
            []
        , label
            [ for "search" ]
            [ text "Search All Resources" ]
        ]

    addButton =
      a
        [ href "#modal1"
        , class
            ("waves-effect waves-light btn modal-trigger right light-blue"
              ++ " white-text"
            )
        ]
        [ text "Add new resource" ]

    modal =
      div
        [ id "modal1"
        , class "modal modal-fixed-footer"
        ]
        [ Html.form
            [ onSubmitWithOptions onSubmitOptions address (Add model.item) ]
            [ div
                [ class "modal-content" ]
                [ h5
                    []
                    [ text "Add New Resource" ]
                , div
                    [ class "input-field" ]
                    [ input
                        [ class "validate"
                        , id "newTitle"
                        , required True
                        , type' "text"
                        , value model.item.title
                        , on
                            "input"
                            targetValue
                            (\str -> Signal.message address (UpdateTitle str))
                        ]
                        []
                    , label
                        [ for "newTitle" ]
                        [ text "Title" ]
                    ]
                , div
                    [ class "input-field" ]
                    [ input
                        [ class "validate"
                        , id "newUrl"
                        , required True
                        , type' "url"
                        , value model.item.url
                        , on
                            "input"
                            targetValue
                            (\str -> Signal.message address (UpdateUrl str))
                        ]
                        []
                    , label [ for "newUrl" ] [ text "Url" ]
                    ]
                ]
            , div
                [ class "modal-footer" ]
                [ button
                    [ class
                        ("waves-effect waves-green btn-flat green darken-3 "
                          ++ "white-text"
                        )
                    , type' "submit"
                    ]
                    [ strong [] [ text "Add" ] ]
                , a
                    [ class
                        ("modal-action modal-close waves-effect waves-red "
                          ++ "btn-flat"
                        )
                    ]
                    [ text "Cancel" ]
                ]
            ]
        ]
  in
    div
      []
      [ searchField
      , div
          [ class "row" ]
          [ addButton ]
      , viewItems address model
      , modal
      ]
