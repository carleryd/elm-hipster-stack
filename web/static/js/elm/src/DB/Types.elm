module DB.Types exposing (..)


type alias MutateLinksInput =
  { node :
      { id : Maybe String
      , title : Maybe String
      , short_text : Maybe String
      , full_text : Maybe String
      , genre : Maybe String
      , image_src : Maybe String
      , latitude : Maybe String
      , longitude : Maybe String
      }
  }


type alias MutateLinksResult =
  { data :
      { create_link :
          { edges :
              { node :
                  { id : Maybe String
                  , title : Maybe String
                  , short_text : Maybe String
                  , full_text : Maybe String
                  , genre : Maybe String
                  , image_src : Maybe String
                  , latitude : Maybe String
                  , longitude : Maybe String
                  }
              }
          }
      }
  }
