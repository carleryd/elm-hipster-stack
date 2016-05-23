module DB.Link.Types exposing (..)


type alias Edge =
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


type alias MutateResult =
  { data :
      { create_link :
          { link_edge :
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


type alias QueryResult =
  { store :
      { linkConnection :
          { edges :
              List
                { node :
                    { id : Maybe String
                    , title : Maybe String
                    , url : Maybe String
                    , createdAt : Maybe String
                    }
                }
          }
      }
  }


type alias CreateInput =
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
