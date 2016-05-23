module DB.Link.State exposing (..)

import Cmd
import Task exposing (Task)
import Json.Encode exposing (encode, object)
import Http
import Msgs exposing (Msg(Link))
import Link.Model
import DB.State exposing (url, apply)
import DB.Link.Types exposing (QueryResult, MutateResult)
import DB.Link.Utils exposing (toMaybeLinkList, toMaybeLink, linkToParamList, queryLinksResult, mutateLinksResult)


queryLinks : String -> Task Http.Error QueryLinksResult
queryLinks queryParam =
  let
    query =
      """query queryLinks($queryParam: String!) { store { linkConnection(query: $queryParam) { edges { node { id title url createdAt } } } } }"""
  in
    let
      params =
        object
          [ ( "queryParam", Json.Encode.string queryParam )
          ]
    in
      GraphQL.query url query "queryLinks" (encode 0 params) queryLinksResult


queryLinksResult : Decoder QueryLinksResult
queryLinksResult =
  map
    QueryLinksResult
    ("store"
      := (map
            (\linkConnection -> { linkConnection = linkConnection })
            ("linkConnection"
              := (map
                    (\edges -> { edges = edges })
                    ("edges"
                      := (list
                            (map
                              (\node -> { node = node })
                              ("node"
                                := (map (\id title url createdAt -> { id = id, title = title, url = url, createdAt = createdAt }) (maybe ("id" := string))
                                      `apply` (maybe ("title" := string))
                                      `apply` (maybe ("url" := string))
                                      `apply` (maybe ("createdAt" := string))
                                   )
                              )
                            )
                         )
                    )
                 )
            )
         )
    )


{-| Sends a mutation query to GraphQL which creates an link in the database.
-}



-- create : Link.Model.Model -> Cmd.Cmd Msg
-- create link =
--   let
--     linkParamList =
--       linkToParamList link
--
--     addLinkMsg =
--       (Link << Link.Root.Types.AddLink)
--   in
--     createMutation linkParamList
--       |> Task.toMaybe
--       |> Task.map toMaybeLink
--       |> Task.map addLinkMsg
--       |> Cmd.task


{-| Sends a query to GraphQL which fetches all links in the database.
    A sortString can be provided to sort the results retrieved from GraphQL.
-}
fetchAll : String -> Cmd.Cmd Msg
fetchAll sortString =
  let
    updateListMsg =
      (Add)
  in
    fetchAllQuery sortString
      |> Task.toMaybe
      |> Task.map toMaybeLinkList
      |> Task.map updateListMsg
      |> Cmd.task


fetchAllQuery : String -> Task Http.Error QueryResult
fetchAllQuery queryParam =
  let
    queryString =
      """query queryLinks($queryParam: String!) { store { link_connection(query: $queryParam) { edges { node { id title short_text full_text genre image_src latitude longitude } } } } }"""
  in
    let
      params =
        object
          [ ( "queryParam", Json.Encode.string queryParam )
          ]
    in
      DB.State.query
        url
        queryString
        "queryLinks"
        (encode 0 params)
        queryLinksResult


createMutation : List ( String, Json.Encode.Value ) -> Task Http.Error MutateResult
createMutation linkParamList =
  let
    queryString =
      """mutation createLinkMutation($mutateParam : CreateLinkInput!) { create_link(input: $mutateParam) { link_edge { node { id title short_text full_text genre image_src latitude longitude } } } }"""
  in
    let
      params =
        object
          [ ( "mutateParam", (object linkParamList) )
          ]
    in
      DB.State.mutate
        url
        queryString
        "createLink"
        (encode 0 params)
        mutateLinksResult
