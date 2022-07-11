module Pyxis.Components.Field.Textarea exposing
    ( Model
    , init
    , setOnBlur
    , setOnFocus
    , setOnInput
    , Config
    , config
    , Size
    , medium
    , small
    , withSize
    , withAdditionalContent
    , withClassList
    , withDisabled
    , withHint
    , withId
    , withLabel
    , withPlaceholder
    , withValidationOnBlur
    , withValidationOnInput
    , withValidationOnSubmit
    , withValueMapper
    , Msg
    , update
    , updateValue
    , getValue
    , render
    )

{-|


# Textarea component

@docs Model
@docs init
@docs setOnBlur
@docs setOnFocus
@docs setOnInput


## Config

@docs Config
@docs config


## Size

@docs Size
@docs medium
@docs small
@docs withSize


## Generics

@docs withAdditionalContent
@docs withClassList
@docs withDisabled
@docs withHint
@docs withId
@docs withLabel
@docs withPlaceholder
@docs withValidationOnBlur
@docs withValidationOnInput
@docs withValidationOnSubmit
@docs withValueMapper


## Update

@docs Msg
@docs update
@docs updateValue


## Readers

@docs getValue


## Rendering

@docs render

-}

import Html exposing (Html)
import Html.Attributes
import Html.Events
import PrimaUpdate
import Pyxis.Commons.Alias as CommonsAlias
import Pyxis.Commons.Attributes as CommonsAttributes
import Pyxis.Commons.Commands as Commands
import Pyxis.Components.Field.Error as Error
import Pyxis.Components.Field.FieldStatus as FieldStatus exposing (FieldStatus)
import Pyxis.Components.Field.Hint as Hint
import Pyxis.Components.Field.Label as Label
import Pyxis.Components.Form.FormItem as FormItem


{-| The Textarea model.
-}
type Model msg
    = Model
        { value : String
        , fieldStatus : FieldStatus
        , onBlur : Maybe msg
        , onFocus : Maybe msg
        , onInput : Maybe msg
        }


{-| Initializes the Textarea model.
-}
init : String -> Model msg
init initialValue =
    Model
        { value = initialValue
        , fieldStatus = FieldStatus.init
        , onBlur = Nothing
        , onFocus = Nothing
        , onInput = Nothing
        }


{-| Textarea size
-}
type Size
    = Small
    | Medium


{-| Textarea size small
-}
small : Size
small =
    Small


{-| Textarea size medium
-}
medium : Size
medium =
    Medium


{-| The view configuration.
-}
type Config validationData parsedValue
    = Config
        { additionalContent : Maybe (Html Never)
        , classList : List ( String, Bool )
        , disabled : Bool
        , hint : Maybe Hint.Config
        , id : String
        , name : CommonsAlias.Name
        , placeholder : Maybe String
        , size : Size
        , label : Maybe Label.Config
        , errorShowingStrategy : Maybe Error.ShowingStrategy
        , validation : Maybe (CommonsAlias.Validation validationData String parsedValue)
        , isSubmitted : CommonsAlias.IsSubmitted
        , valueMapper : String -> String
        }


{-| Creates a Textarea.
-}
config : CommonsAlias.Name -> Config validationData parsedValue
config name =
    Config
        { additionalContent = Nothing
        , classList = []
        , disabled = False
        , hint = Nothing
        , id = "id-" ++ name
        , name = name
        , placeholder = Nothing
        , size = Medium
        , label = Nothing
        , errorShowingStrategy = Nothing
        , validation = Nothing
        , isSubmitted = False
        , valueMapper = identity
        }


{-| Adds a Label to the Textarea.
-}
withLabel : Label.Config -> Config validationData parsedValue -> Config validationData parsedValue
withLabel label (Config configuration) =
    Config { configuration | label = Just label }


{-| Sets the Textarea as disabled
-}
withDisabled : Bool -> Config validationData parsedValue -> Config validationData parsedValue
withDisabled isDisabled (Config configuration) =
    Config { configuration | disabled = isDisabled }


{-| Adds the hint to the TextArea.
-}
withHint : String -> Config validationData parsedValue -> Config validationData parsedValue
withHint hintMessage (Config configuration) =
    Config
        { configuration
            | hint =
                Hint.config hintMessage
                    |> Hint.withFieldId configuration.id
                    |> Just
        }


{-| Sets the showing error strategy to `OnSubmit` (The error will be shown only after the form submission)
-}
withValidationOnSubmit :
    CommonsAlias.Validation validationData String parsedValue
    -> CommonsAlias.IsSubmitted
    -> Config validationData parsedValue
    -> Config validationData parsedValue
withValidationOnSubmit validation isSubmitted (Config configuration) =
    Config
        { configuration
            | isSubmitted = isSubmitted
            , validation = Just validation
            , errorShowingStrategy = Error.onSubmit |> Just
        }


{-| Sets the showing error strategy to `OnInput` (The error will be shown after inputting a value in the field or after the form submission)
-}
withValidationOnInput :
    CommonsAlias.Validation validationData String parsedValue
    -> CommonsAlias.IsSubmitted
    -> Config validationData parsedValue
    -> Config validationData parsedValue
withValidationOnInput validation isSubmitted (Config configuration) =
    Config
        { configuration
            | isSubmitted = isSubmitted
            , validation = Just validation
            , errorShowingStrategy = Error.onInput |> Just
        }


{-| Sets the showing error strategy to `OnBlur` (The error will be shown after the user leave the field or after the form submission)
-}
withValidationOnBlur :
    CommonsAlias.Validation validationData String parsedValue
    -> CommonsAlias.IsSubmitted
    -> Config validationData parsedValue
    -> Config validationData parsedValue
withValidationOnBlur validation isSubmitted (Config configuration) =
    Config
        { configuration
            | isSubmitted = isSubmitted
            , validation = Just validation
            , errorShowingStrategy = Error.onBlur |> Just
        }


{-| Maps the inputted string before the update

    Textarea.config "id"
        |> Textarea.withValueMapper String.toUppercase
        |> Textarea.render Tagger formData model.textareaModel

In this example, if the user inputs "abc", the actual inputted text is "ABC".
This applies to both the user UI and the `getValue`/`validate` functions

-}
withValueMapper : (String -> String) -> Config validationData parsedValue -> Config validationData parsedValue
withValueMapper mapper (Config configData) =
    Config { configData | valueMapper = mapper }


{-| Sets a Size to the Textarea
-}
withSize : Size -> Config validationData parsedValue -> Config validationData parsedValue
withSize size (Config configuration) =
    Config { configuration | size = size }


{-| Sets a ClassList to the Textarea
-}
withClassList : List ( String, Bool ) -> Config validationData parsedValue -> Config validationData parsedValue
withClassList classes (Config configuration) =
    Config { configuration | classList = classes }


{-| Sets a id to the Textarea
-}
withId : CommonsAlias.Id -> Config validationData parsedValue -> Config validationData parsedValue
withId id (Config configuration) =
    Config { configuration | id = id }


{-| Sets a Placeholder to the Textarea
-}
withPlaceholder : String -> Config validationData parsedValue -> Config validationData parsedValue
withPlaceholder placeholder (Config configuration) =
    Config { configuration | placeholder = Just placeholder }


{-| Append an additional custom html.
-}
withAdditionalContent : Html Never -> Config validationData parsedValue -> Config validationData parsedValue
withAdditionalContent additionalContent (Config configuration) =
    Config { configuration | additionalContent = Just additionalContent }


{-| Represent the messages which the Textarea can handle.
-}
type Msg
    = OnInput String
    | OnFocus
    | OnBlur


{-| The update function.
-}
update : Msg -> Model msg -> ( Model msg, Cmd msg )
update msg ((Model modelData) as model) =
    case msg of
        OnBlur ->
            model
                |> mapFieldStatus (FieldStatus.setIsBlurred True)
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onBlur ]

        OnFocus ->
            model
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onFocus ]

        OnInput value ->
            Model { modelData | value = value }
                |> mapFieldStatus (FieldStatus.setIsDirty True)
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onInput ]


{-| Update the field value.
-}
updateValue : String -> Model msg -> ( Model msg, Cmd msg )
updateValue value =
    update (OnInput value)


{-| Sets an OnBlur side effect.
-}
setOnBlur : msg -> Model msg -> Model msg
setOnBlur msg (Model configuration) =
    Model { configuration | onBlur = Just msg }


{-| Sets an OnFocus side effect.
-}
setOnFocus : msg -> Model msg -> Model msg
setOnFocus msg (Model configuration) =
    Model { configuration | onFocus = Just msg }


{-| Sets an OnInput side effect.
-}
setOnInput : msg -> Model msg -> Model msg
setOnInput msg (Model configuration) =
    Model { configuration | onInput = Just msg }


{-| Returns the current value of the Textarea.
-}
getValue : Model msg -> String
getValue (Model { value }) =
    value


{-| Renders the Textarea.
-}
render : (Msg -> msg) -> validationData -> Model msg -> Config validationData parsedValue -> Html msg
render tagger validationData model ((Config configData) as config_) =
    let
        customizedLabel : Maybe Label.Config
        customizedLabel =
            Maybe.map (configData.size |> mapLabelSize |> Label.withSize) configData.label

        error : Maybe (Error.Config parsedValue)
        error =
            generateErrorConfig validationData model config_
    in
    config_
        |> renderTextarea error model
        |> Html.map tagger
        |> FormItem.config configData
        |> FormItem.withLabel customizedLabel
        |> FormItem.withAdditionalContent configData.additionalContent
        |> FormItem.render error


{-| Internal
-}
generateErrorConfig : validationData -> Model msg -> Config validationData parsedValue -> Maybe (Error.Config parsedValue)
generateErrorConfig validationData (Model { fieldStatus, value }) (Config { id, isSubmitted, validation, errorShowingStrategy }) =
    let
        getErrorConfig : Result CommonsAlias.ErrorMessage parsedValue -> Error.ShowingStrategy -> Error.Config parsedValue
        getErrorConfig validationResult =
            Error.config id validationResult
                >> Error.withIsDirty fieldStatus.isDirty
                >> Error.withIsBlurred fieldStatus.isBlurred
                >> Error.withIsSubmitted isSubmitted
    in
    Maybe.map2 getErrorConfig
        (Maybe.map (\v -> v validationData value) validation)
        errorShowingStrategy


{-| Internal.
-}
renderTextarea : Maybe (Error.Config parsedValue) -> Model msg -> Config validationData parsedValue -> Html Msg
renderTextarea error (Model modelData) (Config configData) =
    Html.div
        [ Html.Attributes.classList
            [ ( "form-field", True )
            , ( "form-field--error", Error.isVisible error )
            , ( "form-field--disabled", configData.disabled )
            ]
        ]
        [ Html.textarea
            [ Html.Attributes.id configData.id
            , Html.Attributes.classList
                [ ( "form-field__textarea", True )
                , ( "form-field__textarea--small", Small == configData.size )
                ]
            , Html.Attributes.classList configData.classList
            , Html.Attributes.disabled configData.disabled
            , Html.Attributes.value modelData.value
            , CommonsAttributes.testId configData.id
            , Html.Attributes.name configData.name
            , CommonsAttributes.maybe Html.Attributes.placeholder configData.placeholder
            , CommonsAttributes.ariaDescribedByErrorOrHint
                (Maybe.map (always (Error.idFromFieldId configData.id)) error)
                (Maybe.map (always (Hint.toId configData.id)) configData.hint)
            , Html.Events.onInput (configData.valueMapper >> OnInput)
            , Html.Events.onFocus OnFocus
            , Html.Events.onBlur OnBlur
            ]
            []
        ]


{-| Internal
-}
mapFieldStatus : (FieldStatus -> FieldStatus) -> Model msg -> Model msg
mapFieldStatus mapper (Model model) =
    Model { model | fieldStatus = mapper model.fieldStatus }


{-| Internal
-}
mapLabelSize : Size -> Label.Size
mapLabelSize size =
    case size of
        Small ->
            Label.small

        Medium ->
            Label.medium
