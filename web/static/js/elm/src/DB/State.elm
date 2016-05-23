module DB.State exposing (..)

import Task exposing (Task)
import Json.Decode exposing (..)
import Http


url : String
url =
  "http://localhost:4000/graphql"


{-| variables: "{\"queryParam\":\"en enkel parameter\"}" : String
-}
query : String -> String -> String -> String -> Decoder a -> Task Http.Error a
query url query operation variables decoder =
  Http.get
    (queryResult decoder)
    (Http.url
      url
      [ ( "query", query )
      , ( "operationName", operation )
      , ( "variables", variables )
      ]
    )


{-| variables: "{"mutateParam":{"title":"title1","short_text":"short_text1","longitude":"15.6214","latitude":"58.4108","image_src":"image_src1","id":"id1","genre":"genre1","full_text":"full_text1"}}"
-}
mutate : String -> String -> String -> String -> Decoder a -> Task Http.Error a
mutate url mutation operation variables decoder =
  Http.get
    (queryResult decoder)
    (Http.url
      url
      [ ( "query", mutation )
      , ( "variables", variables )
      ]
    )


queryResult : Decoder a -> Decoder a
queryResult decoder =
  -- todo: check for success/failure of the query
  oneOf
    [ at [ "data" ] decoder
    , fail "expecting data"
      -- todo: report failure reason from server
    ]


apply : Decoder (a -> b) -> Decoder a -> Decoder b
apply func value =
  object2 (<|) func value
