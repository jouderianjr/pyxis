module Pyxis.Components.Field.FieldStatus exposing (FieldStatus, init, setIsBlurred, setIsDirty)


type alias FieldStatus =
    { isBlurred : Bool
    , isDirty : Bool
    }


init : FieldStatus
init =
    FieldStatus False False


setIsBlurred : Bool -> { fieldStatus | isBlurred : Bool } -> { fieldStatus | isBlurred : Bool }
setIsBlurred isBlurred fieldStatus =
    { fieldStatus | isBlurred = isBlurred }


setIsDirty : Bool -> { fieldStatus | isDirty : Bool } -> { fieldStatus | isDirty : Bool }
setIsDirty isDirty fieldStatus =
    { fieldStatus | isDirty = isDirty }
