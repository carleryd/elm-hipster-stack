module Http
    ( getString, get, post, send
    , url, uriEncode, uriDecode
    , Request
    , Body, empty, string, multipart
    , Data, stringData
    , Settings, defaultSettings
    , Response, Value(..)
    , Error(..), RawError(..)
    , fromJson
    ) where
{-|

# Encoding and Decoding
@docs url, uriEncode, uriDecode

# Fetch Strings and JSON
@docs getString, get, post, Error

# Body Values
@docs Body, empty, string, multipart, Data, stringData

# Arbitrary Requests
@docs send, Request, Settings, defaultSettings

# Responses
@docs Response, Value, fromJson, RawError
-}

import Dict exposing (Dict)
import Json.Decode as Json
import Native.Http
import Task exposing (Task, andThen, mapError, succeed, fail)
import String
import Time exposing (Time)


type Blob = TODO_implement_blob_in_another_library
type File = TODO_implement_file_in_another_library


-- REQUESTS

{-| Create a properly encoded URL with a [query string][qs]. The first argument is
the portion of the URL before the query string, which is assumed to be
properly encoded already. The second argument is a list of all the
key/value pairs needed for the query string. Both the keys and values
will be appropriately encoded, so they can contain spaces, ampersands, etc.

[qs]: http://en.wikipedia.org/wiki/Query_string

    url "http://example.com/users" [ ("name", "john doe"), ("age", "30") ]
    -- http://example.com/users?name=john+doe&age=30
-}
url : String -> List (String,String) -> String
url baseUrl args =
  case args of
    [] ->
        baseUrl

    _ ->
        baseUrl ++ "?" ++ String.join "&" (List.map queryPair args)


queryPair : (String,String) -> String
queryPair (key,value) =
  queryEscape key ++ "=" ++ queryEscape value


queryEscape : String -> String
queryEscape string =
  String.join "+" (String.split "%20" (uriEncode string))


{-| Encode a string to be placed in any part of a URI. Same behavior as
JavaScript's `encodeURIComponent` function.
-}
uriEncode : String -> String
uriEncode =
  Native.Http.uriEncode


{-| Decode a URI string. Same behavior as JavaScript's `decodeURIComponent`
function.
-}
uriDecode : String -> String
uriDecode =
  Native.Http.uriDecode


{-| Fully specify the request you want to send. For example, if you want to
send a request between domains (CORS request) you will need to specify some
headers manually.

    corsPost : Request
    corsPost =
        { verb = "POST"
        , headers =
            [ ("Origin", "http://elm-lang.org")
            , ("Access-Control-Request-Method", "POST")
            , ("Access-Control-Request-Headers", "X-Custom-Header")
            ]
        , url = "http://example.com/hats"
        , body = empty
        }
-}
type alias Request =
    { verb : String
    , headers : List (String, String)
    , url : String
    , body : Body
    }


{-| An opaque type representing the body of your HTTP message. With GET
requests this is empty, but in other cases it may be a string or blob.
-}
type Body
    = Empty
    | BodyString String
    | ArrayBuffer
    | BodyFormData
    | BodyBlob Blob


{-| An empty request body, no value will be sent along.
-}
empty : Body
empty =
  Empty


{-| Provide a string as the body of the request. Useful if you need to send
JSON data to a server that does not belong in the URL.

    import Json.Decode as JS

    coolestHats : Task Error (List String)
    coolestHats =
        post
          (JS.list JS.string)
          "http://example.com/hats"
          (string """{ "sortBy": "coolness", "take": 10 }""")
-}
string : String -> Body
string =
  BodyString


{--
arrayBuffer : ArrayBuffer -> Body


blob : Blob -> Body
blob _ =
  BodyBlob
--}

{-| Represents data that can be put in a multi-part body. Right now it only
supports strings, but we will support blobs and files when we get an API for
them in Elm.
-}
type Data
    = StringData String String
    | BlobData String (Maybe String) Blob
    | FileData String (Maybe String) File


{-| Create multi-part request bodies, allowing you to send many chunks of data
all in one request. All chunks of data must be given a name.

Currently, you can only construct `stringData`, but we will support `blobData`
and `fileData` once we have proper APIs for those types of data in Elm.
-}
multipart : List Data -> Body
multipart =
  Native.Http.multipart


{-| A named chunk of string data.

    import Json.Encode as JS

    body =
      multipart
        [ stringData "user" (JS.encode user)
        , stringData "payload" (JS.encode payload)
        ]
-}
stringData : String -> String -> Data
stringData =
  StringData


{-| A named chunk of blob data. You provide a name for this piece of data,
an optional file name for where the data came from, and the blob itself. If
no file name is given, it will default to `"blob"`.

Currently the only way to obtain a `Blob` is in a `Response` but support will
expand once we have an API for blobs in Elm.
-}
blobData : String -> Maybe String -> Blob -> Data
blobData =
  BlobData


{--
fileData : String -> Maybe String -> File -> Data
fileData =
  FileData
--}


-- SETTINGS


{-| Configure your request if you need specific behavior.

  * `timeout` lets you specify how long you are willing to wait for a response
    before giving up. By default it is 0 which means &ldquo;never give
    up!&rdquo;

  * `onStart` and `onProgress` allow you to monitor progress. This is useful
    if you want to show a progress bar when uploading a large amount of data.

  * `desiredResponseType` lets you override the MIME type of the response, so
    you can influence what kind of `Value` you get in the `Response`.
-}
type alias Settings =
    { timeout : Time
    , onStart : Maybe (Task () ())
    , onProgress : Maybe (Maybe { loaded : Int, total : Int } -> Task () ())
    , desiredResponseType : Maybe String
    , withCredentials : Bool
    }


{-| The default settings used by `get` and `post`.

    { timeout = 0
    , onStart = Nothing
    , onProgress = Nothing
    , desiredResponseType = Nothing
    }
-}
defaultSettings : Settings
defaultSettings =
    { timeout = 0
    , onStart = Nothing
    , onProgress = Nothing
    , desiredResponseType = Nothing
    , withCredentials = False
    }


-- RESPONSE HANDLER

{-| All the details of the response. There are many weird facts about
responses which include:

  * The `status` may be 0 in the case that you load something from `file://`
  * You cannot handle redirects yourself, they will all be followed
    automatically. If you want to know if you have gone through one or more
    redirect, the `url` field will let you know who sent you the response, so
    you will know if it does not match the URL you requested.
  * You are allowed to have duplicate headers, and their values will be
    combined into a single comma-separated string.

We have left these underlying facts about `XMLHttpRequest` as is because one
goal of this library is to give a low-level enough API that others can build
whatever helpful behavior they want on top of it.
-}
type alias Response =
    { status : Int
    , statusText : String
    , headers : Dict String String
    , url : String
    , value : Value
    }


{-| The information given in the response. Currently there is no way to handle
`Blob` types since we do not have an Elm API for that yet. This type will
expand as more values become available in Elm itself.
-}
type Value
    = Text String
--    | ArrayBuffer ArrayBuffer
    | Blob Blob
--    | Document Document


-- Errors

{-| The things that count as errors at the lowest level. Technically, getting
a response back with status 404 is a &ldquo;successful&rdquo; response in that
you actually got all the information you asked for.

The `fromJson` function and `Error` type provide higher-level errors, but the
point of `RawError` is to allow you to define higher-level errors however you
want.
-}
type RawError
    = RawTimeout
    | RawNetworkError


{-| The kinds of errors you typically want in practice. When you get a
response but its status is not in the 200 range, it will trigger a
`BadResponse`. When you try to decode JSON but something goes wrong,
you will get an `UnexpectedPayload`.
-}
type Error
    = Timeout
    | NetworkError
    | UnexpectedPayload String
    | BadResponse Int String


-- ACTUALLY SEND REQUESTS

{-| Send a request exactly how you want it. The `Settings` argument lets you
configure things like timeouts and progress monitoring. The `Request` argument
defines all the information that will actually be sent along to a server.

    crossOriginGet : String -> String -> Task RawError Response
    crossOriginGet origin url =
      send defaultSettings
        { verb = "GET"
        , headers = [("Origin", origin)]
        , url = url
        , body = empty
        }
-}
send : Settings -> Request -> Task RawError Response
send =
  Native.Http.send


-- HIGH-LEVEL REQUESTS

{-| Send a GET request to the given URL. You will get the entire response as a
string.

    hats : Task Error String
    hats =
        getString "http://example.com/hat-categories.markdown"

-}
getString : String -> Task Error String
getString url =
  let request =
        { verb = "GET"
        , headers = []
        , url = url
        , body = empty
        }
  in
      mapError promoteError (send defaultSettings request)
        `andThen` handleResponse succeed


{-| Send a GET request to the given URL. You also specify how to decode the
response.

    import Json.Decode (list, string)

    hats : Task Error (List String)
    hats =
        get (list string) "http://example.com/hat-categories.json"

-}
get : Json.Decoder value -> String -> Task Error value
get decoder url =
  let request =
        { verb = "GET"
        , headers = []
        , url = url
        , body = empty
        }
  in
      fromJson decoder (send defaultSettings request)


{-| Send a POST request to the given URL, carrying the given body. You also
specify how to decode the response with [a JSON decoder][json].

[json]: http://package.elm-lang.org/packages/elm-lang/core/latest/Json-Decode#Decoder

    import Json.Decode (list, string)

    hats : Task Error (List String)
    hats =
        post (list string) "http://example.com/hat-categories.json" empty

-}
post : Json.Decoder value -> String -> Body -> Task Error value
post decoder url body =
  let request =
        { verb = "POST"
        , headers = []
        , url = url
        , body = body
        }
  in
      fromJson decoder (send defaultSettings request)


{-| Turn a `Response` into an Elm value that is easier to deal with. Helpful
if you are making customized HTTP requests with `send`, as is the case with
`get` and `post`.

Given a `Response` this function will:

  * Check that the status code is in the 200 range.
  * Make sure the response `Value` is a string.
  * Convert the string to Elm with the given `Decoder`.

Assuming all these steps succeed, you will get an Elm value as the result!
-}
fromJson : Json.Decoder a -> Task RawError Response -> Task Error a
fromJson decoder response =
  let decode str =
        case Json.decodeString decoder str of
          Ok v -> succeed v
          Err msg -> fail (UnexpectedPayload msg)
  in
      mapError promoteError response
        `andThen` handleResponse decode


handleResponse : (String -> Task Error a) -> Response -> Task Error a
handleResponse handle response =
  if 200 <= response.status && response.status < 300 then

      case response.value of
        Text str ->
            handle str

        _ ->
            fail (UnexpectedPayload "Response body is a blob, expecting a string.")

  else

      fail (BadResponse response.status response.statusText)



promoteError : RawError -> Error
promoteError rawError =
  case rawError of
    RawTimeout -> Timeout
    RawNetworkError -> NetworkError
