module Test.Simulation exposing
    ( Simulation
    , expectHtml
    , expectModel
    , fromElement
    , fromSandbox
    , run
    , simulate
    )

{-| Experimental testing utility

    A simple wrapper over an elm { init, update, view } record useful to perform the following steps::

    1. render the view from the current model
    2. trigger a message from a vdom event
    3. run the message over the update function and generate a new model
    4. (repeat)

-}

import Expect
import Html exposing (Html)
import Json.Encode
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector exposing (Selector)


type alias App model msg =
    { update : msg -> model -> model
    , view : model -> Html msg
    }


type alias State_ model msg =
    { modelResult : Result String model
    , expectations : List (() -> Expect.Expectation)
    , app : App model msg
    }


type Simulation model msg
    = Simulation (State_ model msg)


fromSandbox :
    { init : model
    , update : msg -> model -> model
    , view : model -> Html msg
    }
    -> Simulation model msg
fromSandbox flags =
    Simulation
        { modelResult = Ok flags.init
        , expectations = []
        , app =
            { update = flags.update
            , view = flags.view
            }
        }


fromElement :
    { init : ( model, x )
    , update : msg -> model -> ( model, x )
    , view : model -> Html msg
    }
    -> Simulation model msg
fromElement args =
    fromSandbox
        { init = Tuple.first args.init
        , update = \msg -> args.update msg >> Tuple.first
        , view = args.view
        }



-- Actions


run : Simulation model msg -> Expect.Expectation
run (Simulation state) =
    case state.modelResult of
        Err err ->
            () |> Expect.all (state.expectations ++ [ \() -> Expect.fail err ])

        Ok _ ->
            Expect.all state.expectations ()


{-| Internal, DO NOT expose
-}
whenOk : (model -> State_ model msg -> State_ model msg) -> Simulation model msg -> Simulation model msg
whenOk f (Simulation state) =
    case state.modelResult of
        Err _ ->
            Simulation state

        Ok model ->
            Simulation (f model state)


expectModel :
    (model -> Expect.Expectation)
    -> Simulation model msg
    -> Simulation model msg
expectModel expect =
    whenOk <|
        \model state ->
            { state | expectations = state.expectations ++ [ always (expect model) ] }


expectHtml :
    (Query.Single msg -> Expect.Expectation)
    -> Simulation model msg
    -> Simulation model msg
expectHtml expect =
    whenOk <|
        \model state ->
            { state
                | expectations =
                    state.expectations
                        ++ [ state.app.view model
                                |> Query.fromHtml
                                |> expect
                                |> always
                           ]
            }


simulate : ( ( String, Json.Encode.Value ), List Selector ) -> Simulation model msg -> Simulation model msg
simulate ( event, selectors ) =
    whenOk <|
        \model state ->
            { state
                | modelResult =
                    state.app.view model
                        |> Query.fromHtml
                        |> Query.find selectors
                        |> Event.simulate event
                        |> Event.toResult
                        |> Result.map (\msg -> state.app.update msg model)
            }
