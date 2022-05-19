module Test.Extra exposing (fuzzDistinctClassNames3)

import Expect
import Fuzz.Extra as Fuzz
import Test exposing (Test)


fuzzDistinctClassNames3 : String -> (String -> String -> String -> Expect.Expectation) -> Test
fuzzDistinctClassNames3 descr expectation =
    Test.fuzz3 Fuzz.className Fuzz.className Fuzz.className descr <|
        \c1 c2 c3 ->
            expectation ("c1-" ++ c1) ("c2-" ++ c2) ("c3-" ++ c3)
