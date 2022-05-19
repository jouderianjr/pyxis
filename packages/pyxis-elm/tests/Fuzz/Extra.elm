module Fuzz.Extra exposing
    ( className
    , nonEmptyString
    )

import Fuzz


nonEmptyString : Fuzz.Fuzzer String
nonEmptyString =
    Fuzz.map2 String.cons
        Fuzz.char
        Fuzz.string


className : Fuzz.Fuzzer String
className =
    Fuzz.map (\str -> "_" ++ String.filter (\ch -> ch /= ' ') str)
        Fuzz.string
