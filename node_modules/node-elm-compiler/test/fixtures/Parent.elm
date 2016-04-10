module Parent (..) where

import Test.ChildA


-- This is a comment in between two import statements.

import Test.ChildB exposing (..)
import Native.Child exposing (..)
import Graphics.Element exposing (show)


main =
    show "Hello, World!"
