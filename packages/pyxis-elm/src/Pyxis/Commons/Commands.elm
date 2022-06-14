module Pyxis.Commons.Commands exposing
    ( dispatch
    , dispatchFromMaybe
    )

{-| Commands utilities


## Dispatcher

@docs dispatch
@docs dispatchFromMaybe

-}

import Task


{-| Given a msg, run it as a side effect.
-}
dispatch : msg -> Cmd msg
dispatch msg =
    Task.perform (always msg) (Task.succeed (always msg))


{-| Given a maybe msg, run it as a side effect or do nothing.
-}
dispatchFromMaybe : Maybe msg -> Cmd msg
dispatchFromMaybe =
    Maybe.map dispatch >> Maybe.withDefault Cmd.none
