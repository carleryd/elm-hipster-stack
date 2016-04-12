# elm-http

Make HTTP requests in Elm.

The `Http` module aims to cover some of the most common cases of requesting
JSON data, but also have lower-level functions such that the API covers all
of the underlying functionality.

## Example

```elm
import Http
import Json.Decode as Json exposing ((:=))
import Task exposing (..)


lookupZipCode : String -> Task Http.Error (List String)
lookupZipCode query =
    Http.get places ("http://api.zippopotam.us/us/" ++ query)


places : Json.Decoder (List String)
places =
  let place =
        Json.object2 (\city state -> city ++ ", " ++ state)
          ("place name" := Json.string)
          ("state" := Json.string)
  in
      "places" := Json.list place
```
