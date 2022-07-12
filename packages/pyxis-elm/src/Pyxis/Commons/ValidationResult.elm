module Pyxis.Commons.ValidationResult exposing (ValidationResult, fromResult, getErrorMessage, invalid, isValid, valid)

import Pyxis.Commons.Alias as CommonsAlias


type ValidationResult
    = Valid
    | Invalid CommonsAlias.ErrorMessage


isValid : ValidationResult -> Bool
isValid result =
    case result of
        Valid ->
            True

        Invalid _ ->
            False


valid : ValidationResult
valid =
    Valid


invalid : CommonsAlias.ErrorMessage -> ValidationResult
invalid =
    Invalid


fromResult : Result String value -> ValidationResult
fromResult result =
    case result of
        Ok _ ->
            Valid

        Err error ->
            Invalid error


getErrorMessage : ValidationResult -> Maybe CommonsAlias.ErrorMessage
getErrorMessage result =
    case result of
        Valid ->
            Nothing

        Invalid errorMessage ->
            Just errorMessage
