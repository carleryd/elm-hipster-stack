module DB.Link.Utils exposing (..)

import String
import Json.Encode
import Json.Decode exposing (Decoder, (:=), map, maybe, list)
import Link.Model
import DB.Link.Types exposing (Edge, QueryResult, MutateResult)
import DB.State exposing (apply)


queryResultToEdges : QueryResult -> List Edge
queryResultToEdges queriedObject =
  queriedObject.store.link_connection.edges


mutationResultToEdge : MutateResult -> Edge
mutationResultToEdge object =
  object.data.create_link.link_edge


toMaybeLink : Maybe MutateResult -> Maybe Link.Model.Model
toMaybeLink maybeMutationResult =
  case maybeMutationResult of
    Just mutationResult ->
      let
        result =
          mutationResult
            |> mutationResultToEdge
            |> edgeToLink
      in
        Just result

    Nothing ->
      Nothing


toMaybeLinkList : Maybe QueryResult -> Maybe (List Link.Model.Model)
toMaybeLinkList maybeMutationResult =
  case maybeMutationResult of
    Just mutationResult ->
      let
        result =
          mutationResult
            |> queryResultToEdges
            |> List.map edgeToLink
      in
        Just result

    Nothing ->
      Nothing


linkToParamList : Link.Model.Model -> List ( String, Json.Encode.Value )
linkToParamList link =
  [ ( "id", Json.Encode.string link.id )
  , ( "title", Json.Encode.string link.title )
  , ( "short_text", Json.Encode.string link.shortText )
  , ( "full_text", Json.Encode.string link.fullText )
  , ( "genre", Json.Encode.string link.genre )
  , ( "image_src", Json.Encode.string link.imageSrc )
  , ( "latitude", Json.Encode.string (toString link.latitude) )
  , ( "longitude", Json.Encode.string (toString link.longitude) )
  ]


edgeToLink : Edge -> Link.Model.Model
edgeToLink edge =
  let
    initialModel =
      Link.Model.initialModel

    id =
      (Maybe.withDefault "Missing id" edge.node.id)

    title =
      (Maybe.withDefault "Missing title" edge.node.title)

    shortText =
      (Maybe.withDefault "Missing shortText" edge.node.short_text)

    fullText =
      (Maybe.withDefault "Missing fullText" edge.node.full_text)

    genre =
      (Maybe.withDefault "Missing genre" edge.node.genre)

    imageSrc =
      (Maybe.withDefault "Missing imageSrc" edge.node.image_src)

    latitudeString =
      (Maybe.withDefault "0" edge.node.latitude)

    latitude =
      (Result.withDefault
        initialModel.latitude
        (String.toFloat latitudeString)
      )

    longitudeString =
      (Maybe.withDefault
        "0"
        edge.node.longitude
      )

    longitude =
      (Result.withDefault
        initialModel.longitude
        (String.toFloat longitudeString)
      )

    newLink =
      Link.Model.Model
        id
        title
        fullText
        shortText
        genre
        imageSrc
        latitude
        longitude
  in
    newLink


{-| Decoder used by GraphQL.mutate to decode result fetched from HTTP call
    to GraphQL.
-}
mutateLinksResult : Decoder MutateResult
mutateLinksResult =
  Json.Decode.map
    MutateResult
    ("data"
      := (Json.Decode.map
            (\create_link -> { create_link = create_link })
            ("create_link"
              := (Json.Decode.map
                    (\link_edge -> { link_edge = link_edge })
                    ("link_edge"
                      := (Json.Decode.map
                            (\node -> { node = node })
                            ("node"
                              := (Json.Decode.map (\id title short_text full_text genre image_src latitude longitude -> { id = id, title = title, short_text = short_text, full_text = full_text, genre = genre, image_src = image_src, latitude = latitude, longitude = longitude }) (maybe ("id" := Json.Decode.string))
                                    `apply` (maybe ("title" := Json.Decode.string))
                                    `apply` (maybe ("short_text" := Json.Decode.string))
                                    `apply` (maybe ("full_text" := Json.Decode.string))
                                    `apply` (maybe ("genre" := Json.Decode.string))
                                    `apply` (maybe ("image_src" := Json.Decode.string))
                                    `apply` (maybe ("latitude" := Json.Decode.string))
                                    `apply` (maybe ("longitude" := Json.Decode.string))
                                 )
                            )
                         )
                    )
                 )
            )
         )
    )


{-| Decoder used by GraphQL.query to decode result fetched from HTTP call
    to GraphQL.
-}
queryLinksResult : Decoder QueryResult
queryLinksResult =
  Json.Decode.map
    QueryResult
    ("store"
      := (Json.Decode.map
            (\link_connection -> { link_connection = link_connection })
            ("link_connection"
              := (Json.Decode.map
                    (\edges -> { edges = edges })
                    ("edges"
                      := (list
                            (Json.Decode.map
                              (\node -> { node = node })
                              ("node"
                                := (Json.Decode.map (\id title short_text full_text genre image_src latitude longitude -> { id = id, title = title, short_text = short_text, full_text = full_text, genre = genre, image_src = image_src, latitude = latitude, longitude = longitude }) (maybe ("id" := Json.Decode.string))
                                      `apply` (maybe ("title" := Json.Decode.string))
                                      `apply` (maybe ("short_text" := Json.Decode.string))
                                      `apply` (maybe ("full_text" := Json.Decode.string))
                                      `apply` (maybe ("genre" := Json.Decode.string))
                                      `apply` (maybe ("image_src" := Json.Decode.string))
                                      `apply` (maybe ("latitude" := Json.Decode.string))
                                      `apply` (maybe ("longitude" := Json.Decode.string))
                                   )
                              )
                            )
                         )
                    )
                 )
            )
         )
    )
