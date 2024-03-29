module Pyxis.Components.Field.Error exposing
    ( Config
    , config
    , ShowingStrategy
    , onBlur
    , onInput
    , onSubmit
    , withIsBlurred
    , withIsDirty
    , withIsSubmitted
    , render
    , idFromFieldId
    , isVisible
    )

{-|


# Error

@docs Config
@docs config


## ShowingStrategy

@docs ShowingStrategy
@docs onBlur
@docs onInput
@docs onSubmit


## Generics

@docs withFieldId
@docs withIsBlurred
@docs withIsDirty
@docs withIsSubmitted


## Rendering

@docs render


## Utils

@docs idFromFieldId
@docs isVisible

-}

import Html
import Html.Attributes
import Maybe.Extra
import Pyxis.Commons.Alias as CommonsAlias
import Pyxis.Commons.Render as CommonsRender
import Result.Extra


{-| Represent a form field error configuration.
-}
type Config parsedValue
    = Config
        { id : CommonsAlias.Id
        , isBlurred : Bool
        , isDirty : Bool
        , isSubmitted : CommonsAlias.IsSubmitted
        , showingStrategy : ShowingStrategy
        , validationResult : Result CommonsAlias.ErrorMessage parsedValue
        }


{-| Creates a form field error.
-}
config : CommonsAlias.Id -> Result CommonsAlias.ErrorMessage parsedValue -> ShowingStrategy -> Config parsedValue
config id validationResult showingStrategy =
    Config
        { id = idFromFieldId id
        , isBlurred = False
        , isDirty = False
        , isSubmitted = False
        , showingStrategy = showingStrategy
        , validationResult = validationResult
        }


{-| Define if the form is submitted.
-}
withIsSubmitted : CommonsAlias.IsSubmitted -> Config parsedValue -> Config parsedValue
withIsSubmitted isSubmitted (Config configuration) =
    Config { configuration | isSubmitted = isSubmitted }


{-| Define if the field is dirty.
-}
withIsDirty : Bool -> Config parsedValue -> Config parsedValue
withIsDirty isDirty (Config configuration) =
    Config { configuration | isDirty = isDirty }


{-| Define if the field has been blurred.
-}
withIsBlurred : Bool -> Config parsedValue -> Config parsedValue
withIsBlurred isBlurred (Config configuration) =
    Config { configuration | isBlurred = isBlurred }


{-| Given the field id returns an errorId.
-}
idFromFieldId : CommonsAlias.Id -> CommonsAlias.Id
idFromFieldId fieldId =
    fieldId ++ "-error"


{-| View the error message
-}
render : Config parsedValue -> Html.Html msg
render ((Config { id, validationResult }) as config_) =
    validationResult
        |> getErrorMessage config_
        |> Maybe.map (renderError id)
        |> CommonsRender.renderMaybe


{-| Internal.
-}
renderError : CommonsAlias.Id -> CommonsAlias.ErrorMessage -> Html.Html msg
renderError id error =
    Html.div
        [ Html.Attributes.class "form-item__error-message"
        , Html.Attributes.id id
        ]
        [ Html.text error ]


{-| The strategies to show the field error
-}
type ShowingStrategy
    = OnInput
    | OnBlur
    | OnSubmit


{-| The strategy to show the error on input
-}
onInput : ShowingStrategy
onInput =
    OnInput


{-| The strategy to show the error on blur
-}
onBlur : ShowingStrategy
onBlur =
    OnBlur


{-| The strategy to show the error on submit
-}
onSubmit : ShowingStrategy
onSubmit =
    OnSubmit


{-| Internal.
-}
getErrorMessage : Config parsedValue -> Result CommonsAlias.ErrorMessage parsedValue -> Maybe String
getErrorMessage (Config { showingStrategy, isSubmitted, isDirty, isBlurred }) validationResult =
    case showingStrategy of
        OnInput ->
            getErrorIf (isSubmitted || isDirty) validationResult

        OnBlur ->
            getErrorIf (isSubmitted || isBlurred) validationResult

        OnSubmit ->
            getErrorIf isSubmitted validationResult


{-| Return a boolean based on if the error message is visible under the field or not.
-}
isVisible : Maybe (Config parsedValue) -> Bool
isVisible maybeConfig =
    maybeConfig
        |> Maybe.andThen (\((Config { validationResult }) as config_) -> getErrorMessage config_ validationResult)
        |> Maybe.Extra.isJust


{-| Internal.
-}
getErrorIf : Bool -> Result CommonsAlias.ErrorMessage parsedValue -> Maybe String
getErrorIf condition validationResult =
    if condition then
        Result.Extra.error validationResult

    else
        Nothing
