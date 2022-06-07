module Pyxis.Commons.Events exposing
    ( PointerType(..)
    , onClickPreventDefault, alwaysStopPropagationOn
    , stopPropagationAndPreventDefaultOn
    )

{-|


## Events utilities

@docs PointerType
@docs onClickPreventDefault, alwaysStopPropagationOn

-}

import Html
import Html.Events
import Json.Decode


{-| The event .pointerType field
-}
type PointerType
    = Mouse
    | Pen
    | Touch


{-| Internal
-}
pointerEventDecoder : Json.Decode.Decoder (Maybe PointerType)
pointerEventDecoder =
    pointerTypeDecoder
        |> Json.Decode.field "pointerType"
        |> Json.Decode.maybe


{-| Internal
-}
pointerTypeDecoder : Json.Decode.Decoder PointerType
pointerTypeDecoder =
    Json.Decode.andThen
        (\str ->
            case str of
                "mouse" ->
                    Json.Decode.succeed Mouse

                "pen" ->
                    Json.Decode.succeed Pen

                "touch" ->
                    Json.Decode.succeed Touch

                _ ->
                    Json.Decode.fail ""
        )
        Json.Decode.string


{-| A version of onClick that decodes extra data about the PointerEvent.
-}
onClickPreventDefault : (Maybe PointerType -> value) -> Html.Attribute value
onClickPreventDefault tagger =
    Html.Events.on "click" (Json.Decode.map tagger pointerEventDecoder)


{-| Stops propagation of a provided event.
-}
alwaysStopPropagationOn : String -> msg -> Html.Attribute msg
alwaysStopPropagationOn event msg =
    Html.Events.stopPropagationOn event (Json.Decode.succeed ( msg, True ))


stopPropagationAndPreventDefaultOn : String -> msg -> Html.Attribute msg
stopPropagationAndPreventDefaultOn event msg =
    Html.Events.custom
        event
        (Json.Decode.succeed
            { message = msg
            , stopPropagation = True
            , preventDefault = True
            }
        )
