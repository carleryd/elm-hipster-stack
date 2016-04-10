
import ElmTest.Runner.Console exposing (runDisplay)
import ElmTest.Test exposing (Test, suite)
import IO.IO exposing (IO)
import IO.Runner exposing (Request, Response)
import IO.Runner as Run

import TestCases.Lazy

tests : Test
tests =
    suite
        "VirtualDom Library Tests"
        [
            TestCases.Lazy.tests
        ]

console : IO ()
console = runDisplay tests

port requests : Signal Request
port requests = Run.run responses console

port responses : Signal Response