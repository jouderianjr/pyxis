module Pyxis.Components.Field.RadioGroup exposing
    ( Model
    , init
    , setOnBlur
    , setOnFocus
    , setOnCheck
    , Config
    , config
    , Layout
    , horizontal
    , vertical
    , withLayout
    , withAdditionalContent
    , withClassList
    , withDisabled
    , withHint
    , withId
    , withLabel
    , withValidationOnBlur
    , withValidationOnInput
    , withValidationOnSubmit
    , Msg
    , update
    , updateValue
    , getValue
    , Option
    , option
    , withOptions
    , render
    )

{-|


# Input RadioGroup component


## Model

@docs Model
@docs init
@docs setOnBlur
@docs setOnFocus
@docs setOnCheck


## Config

@docs Config
@docs config


# Layout

@docs Layout
@docs horizontal
@docs vertical
@docs withLayout


## Generics

@docs withAdditionalContent
@docs withClassList
@docs withDisabled
@docs withHint
@docs withId
@docs withLabel
@docs withValidationOnBlur
@docs withValidationOnInput
@docs withValidationOnSubmit


## Update

@docs Msg
@docs update
@docs updateValue


## Readers

@docs getValue


## Options

@docs Option
@docs option
@docs withOptions


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
import Pyxis.Commons.String as CommonsString
import Pyxis.Components.Field.Error as Error
import Pyxis.Components.Field.FieldStatus as FieldStatus exposing (FieldStatus)
import Pyxis.Components.Field.Hint as Hint
import Pyxis.Components.Field.Label as Label
import Pyxis.Components.Form.FormItem as FormItem


{-| The RadioGroup model.
-}
type Model value msg
    = Model
        { selectedValue : Maybe value
        , fieldStatus : FieldStatus
        , onBlur : Maybe msg
        , onFocus : Maybe msg
        , onCheck : Maybe msg
        }


{-| Initialize the RadioGroup Model.
-}
init : Maybe value -> Model value msg
init initialValue =
    Model
        { selectedValue = initialValue
        , fieldStatus = FieldStatus.init
        , onBlur = Nothing
        , onFocus = Nothing
        , onCheck = Nothing
        }


{-| The RadioGroup configuration.
-}
type Config validationData value parsedValue
    = Config
        { additionalContent : Maybe (Html Never)
        , classList : List ( String, Bool )
        , hint : Maybe Hint.Config
        , id : String
        , isDisabled : Bool
        , isSubmitted : CommonsAlias.IsSubmitted
        , label : Maybe Label.Config
        , layout : Layout
        , name : CommonsAlias.Name
        , options : List (Option value)
        , errorShowingStrategy : Maybe Error.ShowingStrategy
        , validation : Maybe (CommonsAlias.Validation validationData (Maybe value) parsedValue)
        }


{-| Initialize the RadioGroup Config.
-}
config : CommonsAlias.Name -> Config validationData value parsedValue
config name =
    Config
        { additionalContent = Nothing
        , classList = []
        , hint = Nothing
        , id = "id-" ++ name
        , isDisabled = False
        , isSubmitted = False
        , label = Nothing
        , layout = Horizontal
        , name = name
        , options = []
        , errorShowingStrategy = Nothing
        , validation = Nothing
        }


{-| Represent the single Radio option.
-}
type Option value
    = Option (OptionConfig value)


{-| Internal.
-}
type alias OptionConfig value =
    { value : value
    , label : String
    }


{-| Represent the messages which the RadioGroup can handle.
-}
type Msg value
    = OnCheck value
    | OnFocus
    | OnBlur


{-| Represent the layout of the group.
-}
type Layout
    = Horizontal
    | Vertical


{-| Horizontal layout.
-}
horizontal : Layout
horizontal =
    Horizontal


{-| Vertical layout.
-}
vertical : Layout
vertical =
    Vertical


{-| Add the classes to the group wrapper.
-}
withClassList : List ( String, Bool ) -> Config validationData value parsedValue -> Config validationData value parsedValue
withClassList classList (Config configuration) =
    Config { configuration | classList = classList }


{-| Define if the group is disabled or not.
-}
withDisabled : Bool -> Config validationData value parsedValue -> Config validationData value parsedValue
withDisabled isDisabled (Config configuration) =
    Config { configuration | isDisabled = isDisabled }


{-| Adds the hint to the RadioGroup.
-}
withHint : String -> Config validationData value parsedValue -> Config validationData value parsedValue
withHint hintMessage (Config configuration) =
    Config
        { configuration
            | hint =
                Hint.config hintMessage
                    |> Hint.withFieldId configuration.id
                    |> Just
        }


{-| Add an id to the inputs.
-}
withId : CommonsAlias.Id -> Config validationData value parsedValue -> Config validationData value parsedValue
withId id (Config configuration) =
    Config { configuration | id = id }


{-| Add a label to the inputs.
-}
withLabel : Label.Config -> Config validationData value parsedValue -> Config validationData value parsedValue
withLabel label (Config configuration) =
    Config { configuration | label = Just label }


{-| Define the visible options in the radio group.
-}
withOptions : List (Option value) -> Config validationData value parsedValue -> Config validationData value parsedValue
withOptions options (Config configuration) =
    Config { configuration | options = options }


{-| Change the visual layout. The default one is horizontal.
-}
withLayout : Layout -> Config validationData value parsedValue -> Config validationData value parsedValue
withLayout layout (Config configuration) =
    Config { configuration | layout = layout }


{-| Append an additional custom html.
-}
withAdditionalContent : Html Never -> Config validationData value parsedValue -> Config validationData value parsedValue
withAdditionalContent additionalContent (Config configuration) =
    Config { configuration | additionalContent = Just additionalContent }


{-| Sets the showing error strategy to `OnSubmit` (The error will be shown only after the form submission)
-}
withValidationOnSubmit :
    CommonsAlias.Validation validationData (Maybe value) parsedValue
    -> CommonsAlias.IsSubmitted
    -> Config validationData value parsedValue
    -> Config validationData value parsedValue
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
    CommonsAlias.Validation validationData (Maybe value) parsedValue
    -> CommonsAlias.IsSubmitted
    -> Config validationData value parsedValue
    -> Config validationData value parsedValue
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
    CommonsAlias.Validation validationData (Maybe value) parsedValue
    -> CommonsAlias.IsSubmitted
    -> Config validationData value parsedValue
    -> Config validationData value parsedValue
withValidationOnBlur validation isSubmitted (Config configuration) =
    Config
        { configuration
            | isSubmitted = isSubmitted
            , validation = Just validation
            , errorShowingStrategy = Error.onBlur |> Just
        }


{-| Generate a Radio Option
-}
option : OptionConfig value -> Option value
option =
    Option


{-| Render the RadioGroup.
-}
render : (Msg value -> msg) -> validationData -> Model value msg -> Config validationData value parsedValue -> Html.Html msg
render tagger validationData model ((Config configData) as config_) =
    let
        error : Maybe (Error.Config parsedValue)
        error =
            generateErrorConfig validationData model config_
    in
    renderField error model config_
        |> Html.map tagger
        |> FormItem.config configData
        |> FormItem.withLabel configData.label
        |> FormItem.withAdditionalContent configData.additionalContent
        |> FormItem.render error


{-| Internal
-}
generateErrorConfig : validationData -> Model value msg -> Config validationData value parsedValue -> Maybe (Error.Config parsedValue)
generateErrorConfig validationData (Model { fieldStatus, selectedValue }) (Config { id, isSubmitted, validation, errorShowingStrategy }) =
    let
        getErrorConfig : Result CommonsAlias.ErrorMessage parsedValue -> Error.ShowingStrategy -> Error.Config parsedValue
        getErrorConfig validationResult =
            Error.config id validationResult
                >> Error.withIsDirty fieldStatus.isDirty
                >> Error.withIsBlurred fieldStatus.isBlurred
                >> Error.withIsSubmitted isSubmitted
    in
    Maybe.map2 getErrorConfig
        (Maybe.map (\v -> v validationData selectedValue) validation)
        errorShowingStrategy


renderField : Maybe (Error.Config parsedValue) -> Model value msg -> Config validationData value parsedValue -> Html (Msg value)
renderField error model ((Config configData) as configuration) =
    Html.div
        [ Html.Attributes.classList
            [ ( "form-control-group", True )
            , ( "form-control-group--column", configData.layout == Vertical )
            ]
        , Html.Attributes.classList configData.classList
        , Html.Attributes.id configData.id
        , CommonsAttributes.role "radiogroup"
        , CommonsAttributes.ariaLabelledbyBy (labelId configData.id)
        , CommonsAttributes.ariaDescribedByErrorOrHint
            (Maybe.map (always (Error.idFromFieldId configData.id)) error)
            (Maybe.map (always (Hint.toId configData.id)) configData.hint)
        ]
        (List.map (renderRadio error model configuration) configData.options)


{-| Internal.
-}
labelId : CommonsAlias.Id -> String
labelId id =
    id ++ "-label"


{-| Internal.
-}
renderRadio : Maybe (Error.Config parsedValue) -> Model value msg -> Config validationData value parsedValue -> Option value -> Html.Html (Msg value)
renderRadio error (Model { selectedValue }) (Config { id, name, isDisabled }) (Option { value, label }) =
    Html.label
        [ Html.Attributes.classList
            [ ( "form-control", True )
            , ( "form-control--error", Error.isVisible error )
            ]
        ]
        [ Html.input
            [ Html.Attributes.type_ "radio"
            , Html.Attributes.classList [ ( "form-control__radio", True ) ]
            , Html.Attributes.checked (selectedValue == Just value)
            , Html.Attributes.disabled isDisabled
            , Html.Attributes.id (radioId id label)
            , CommonsAttributes.testId (radioId id label)
            , Html.Attributes.name name
            , Html.Events.onCheck (always (OnCheck value))
            , Html.Events.onFocus OnFocus
            , Html.Events.onBlur OnBlur
            ]
            []
        , Html.span
            [ Html.Attributes.class "form-control__text" ]
            [ Html.text label ]
        ]


{-| Internal.
-}
radioId : CommonsAlias.Id -> String -> String
radioId id label =
    [ id, label |> CommonsString.toKebabCase, "option" ]
        |> String.join "-"


{-| Update the RadioGroup Model.
-}
update : Msg value -> Model value msg -> ( Model value msg, Cmd msg )
update msg ((Model modelData) as model) =
    case msg of
        OnCheck value ->
            Model { modelData | selectedValue = Just value }
                |> mapFieldStatus (FieldStatus.setIsDirty True)
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onCheck ]

        OnBlur ->
            model
                |> mapFieldStatus (FieldStatus.setIsBlurred True)
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onBlur ]

        OnFocus ->
            model
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onFocus ]


{-| Update the field value.
-}
updateValue : value -> Model value msg -> ( Model value msg, Cmd msg )
updateValue value =
    update (OnCheck value)


{-| Sets an OnBlur side effect.
-}
setOnBlur : msg -> Model value msg -> Model value msg
setOnBlur msg (Model configuration) =
    Model { configuration | onBlur = Just msg }


{-| Sets an OnFocus side effect.
-}
setOnFocus : msg -> Model value msg -> Model value msg
setOnFocus msg (Model configuration) =
    Model { configuration | onFocus = Just msg }


{-| Sets an OnCheck side effect.
-}
setOnCheck : msg -> Model value msg -> Model value msg
setOnCheck msg (Model configuration) =
    Model { configuration | onCheck = Just msg }


{-| Internal
-}
mapFieldStatus : (FieldStatus -> FieldStatus) -> Model value msg -> Model value msg
mapFieldStatus f (Model model) =
    Model { model | fieldStatus = f model.fieldStatus }


{-| Return the selected value.
-}
getValue : Model value msg -> Maybe value
getValue (Model { selectedValue }) =
    selectedValue
