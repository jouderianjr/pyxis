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
    , withIsSubmitted
    , withStrategy
    , withAdditionalContent
    , withClassList
    , withDisabled
    , withHint
    , withId
    , withLabel
    , Msg
    , update
    , updateValue
    , getValue
    , validate
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
@docs withIsSubmitted
@docs withStrategy


## Generics

@docs withAdditionalContent
@docs withClassList
@docs withDisabled
@docs withHint
@docs withId
@docs withLabel


## Update

@docs Msg
@docs update
@docs updateValue


## Readers

@docs getValue
@docs validate


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
import Pyxis.Commons.Attributes as CommonsAttributes
import Pyxis.Commons.Commands as Commands
import Pyxis.Commons.String as CommonsString
import Pyxis.Components.Field.Error as Error
import Pyxis.Components.Field.Error.Strategy as Strategy exposing (Strategy)
import Pyxis.Components.Field.Error.Strategy.Internal as InternalStrategy
import Pyxis.Components.Field.Hint as Hint
import Pyxis.Components.Field.Label as Label
import Pyxis.Components.Field.Status as FieldStatus
import Pyxis.Components.Form.FormItem as FormItem
import Result.Extra


{-| The RadioGroup model.
-}
type Model ctx value parsedValue msg
    = Model
        { selectedValue : Maybe value
        , validation : ctx -> Maybe value -> Result String parsedValue
        , fieldStatus : FieldStatus.Status
        , onBlur : Maybe msg
        , onFocus : Maybe msg
        , onCheck : Maybe msg
        }


{-| Initialize the RadioGroup Model.
-}
init : Maybe value -> (ctx -> Maybe value -> Result String parsedValue) -> Model ctx value parsedValue msg
init initialValue validation =
    Model
        { selectedValue = initialValue
        , validation = validation
        , fieldStatus = FieldStatus.Untouched
        , onBlur = Nothing
        , onFocus = Nothing
        , onCheck = Nothing
        }


type alias ConfigData value =
    { additionalContent : Maybe (Html Never)
    , classList : List ( String, Bool )
    , hint : Maybe Hint.Config
    , id : String
    , isDisabled : Bool
    , isSubmitted : Bool
    , label : Maybe Label.Config
    , layout : Layout
    , name : String
    , options : List (Option value)
    , strategy : Strategy
    }


{-| The RadioGroup configuration.
-}
type Config value
    = Config (ConfigData value)


{-| Initialize the RadioGroup Config.
-}
config : String -> Config value
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
        , strategy = Strategy.onBlur
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
withClassList : List ( String, Bool ) -> Config value -> Config value
withClassList classList (Config configuration) =
    Config { configuration | classList = classList }


{-| Define if the group is disabled or not.
-}
withDisabled : Bool -> Config value -> Config value
withDisabled isDisabled (Config configuration) =
    Config { configuration | isDisabled = isDisabled }


{-| Adds the hint to the RadioGroup.
-}
withHint : String -> Config value -> Config value
withHint hintMessage (Config configuration) =
    Config
        { configuration
            | hint =
                Hint.config hintMessage
                    |> Hint.withFieldId configuration.id
                    |> Just
        }


{-| Sets the validation strategy (when to show the error, if present)
-}
withStrategy : Strategy -> Config value -> Config value
withStrategy strategy (Config configuration) =
    Config { configuration | strategy = strategy }


{-| Sets whether the form was submitted
-}
withIsSubmitted : Bool -> Config value -> Config value
withIsSubmitted isSubmitted (Config configuration) =
    Config { configuration | isSubmitted = isSubmitted }


{-| Add an id to the inputs.
-}
withId : String -> Config value -> Config value
withId id (Config configuration) =
    Config { configuration | id = id }


{-| Add a label to the inputs.
-}
withLabel : Label.Config -> Config value -> Config value
withLabel label (Config configuration) =
    Config { configuration | label = Just label }


{-| Define the visible options in the radio group.
-}
withOptions : List (Option value) -> Config value -> Config value
withOptions options (Config configuration) =
    Config { configuration | options = options }


{-| Change the visual layout. The default one is horizontal.
-}
withLayout : Layout -> Config value -> Config value
withLayout layout (Config configuration) =
    Config { configuration | layout = layout }


{-| Append an additional custom html.
-}
withAdditionalContent : Html Never -> Config value -> Config value
withAdditionalContent additionalContent (Config configuration) =
    Config { configuration | additionalContent = Just additionalContent }


{-| Generate a Radio Option
-}
option : OptionConfig value -> Option value
option =
    Option


{-| Render the RadioGroup.
-}
render : (Msg value -> msg) -> ctx -> Model ctx value parsedValue msg -> Config value -> Html.Html msg
render tagger ctx ((Model modelData) as model) ((Config configData) as configuration) =
    let
        shownValidation : Result String ()
        shownValidation =
            InternalStrategy.getShownValidation
                modelData.fieldStatus
                (modelData.validation ctx modelData.selectedValue)
                configData.isSubmitted
                configData.strategy
    in
    renderField shownValidation model configuration
        |> Html.map tagger
        |> FormItem.config configData
        |> FormItem.withLabel configData.label
        |> FormItem.withAdditionalContent configData.additionalContent
        |> FormItem.render shownValidation


renderField : Result String () -> Model ctx value parsedValue msg -> Config value -> Html.Html (Msg value)
renderField shownValidation model ((Config configData) as configuration) =
    Html.div
        [ Html.Attributes.classList
            [ ( "form-control-group", True )
            , ( "form-control-group--column", configData.layout == Vertical )
            ]
        , Html.Attributes.classList configData.classList
        , Html.Attributes.id configData.id
        , CommonsAttributes.role "radiogroup"
        , CommonsAttributes.ariaLabelledbyBy (labelId configData.id)
        , shownValidation
            |> Error.fromResult
            |> Maybe.map (always (Error.toId configData.id))
            |> CommonsAttributes.ariaDescribedByErrorOrHint
                (Maybe.map (always (Hint.toId configData.id)) configData.hint)
        ]
        (List.map (renderRadio shownValidation model configuration) configData.options)


{-| Internal.
-}
labelId : String -> String
labelId id =
    id ++ "-label"


{-| Internal.
-}
renderRadio : Result String x -> Model ctx value parsedValue msg -> Config value -> Option value -> Html.Html (Msg value)
renderRadio validationResult (Model { selectedValue }) (Config { id, name, isDisabled }) (Option { value, label }) =
    Html.label
        [ Html.Attributes.classList
            [ ( "form-control", True )
            , ( "form-control--error", Result.Extra.isErr validationResult )
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
        , Html.text label
        ]


{-| Internal.
-}
radioId : String -> String -> String
radioId id label =
    [ id, label |> CommonsString.toKebabCase, "option" ]
        |> String.join "-"


{-| Update the RadioGroup Model.
-}
update : Msg value -> Model ctx value parsedValue msg -> ( Model ctx value parsedValue msg, Cmd msg )
update msg ((Model modelData) as model) =
    case msg of
        OnCheck value ->
            Model { modelData | selectedValue = Just value }
                |> mapFieldStatus FieldStatus.onChange
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onCheck ]

        OnBlur ->
            model
                |> mapFieldStatus FieldStatus.onBlur
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onBlur ]

        OnFocus ->
            model
                |> mapFieldStatus FieldStatus.onFocus
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onFocus ]


{-| Update the field value.
-}
updateValue : value -> Model ctx value parsedValue msg -> ( Model ctx value parsedValue msg, Cmd msg )
updateValue value =
    update (OnCheck value)


{-| Sets an OnBlur side effect.
-}
setOnBlur : msg -> Model ctx value parsedValue msg -> Model ctx value parsedValue msg
setOnBlur msg (Model configuration) =
    Model { configuration | onBlur = Just msg }


{-| Sets an OnFocus side effect.
-}
setOnFocus : msg -> Model ctx value parsedValue msg -> Model ctx value parsedValue msg
setOnFocus msg (Model configuration) =
    Model { configuration | onFocus = Just msg }


{-| Sets an OnCheck side effect.
-}
setOnCheck : msg -> Model ctx value parsedValue msg -> Model ctx value parsedValue msg
setOnCheck msg (Model configuration) =
    Model { configuration | onCheck = Just msg }


{-| Internal
-}
mapFieldStatus : (FieldStatus.Status -> FieldStatus.Status) -> Model ctx value parsedValue msg -> Model ctx value parsedValue msg
mapFieldStatus f (Model model) =
    Model { model | fieldStatus = f model.fieldStatus }


{-| Return the selected value.
-}
getValue : Model ctx value parsedValue msg -> Maybe value
getValue (Model { selectedValue }) =
    selectedValue


{-| Get the (parsed) value
-}
validate : ctx -> Model ctx value parsedValue msg -> Result String parsedValue
validate ctx (Model { selectedValue, validation }) =
    validation ctx selectedValue
