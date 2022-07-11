module Pyxis.Components.Field.RadioCardGroup exposing
    ( Model
    , init
    , resetValue
    , setOnBlur
    , setOnCheck
    , setOnFocus
    , setValue
    , Config
    , config
    , Addon
    , iconAddon
    , imgAddon
    , textAddon
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
    , medium
    , large
    , withSize
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


# RadioCardGroup component

@docs Model
@docs init
@docs resetValue
@docs setOnBlur
@docs setOnCheck
@docs setOnFocus
@docs setValue


## Config

@docs Config
@docs config


# Addon

@docs Addon
@docs iconAddon
@docs imgAddon
@docs textAddon


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


## Size

@docs medium
@docs large
@docs withSize


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
import PrimaUpdate
import Pyxis.Commons.Alias as CommonsAlias
import Pyxis.Commons.Commands as Commands
import Pyxis.Components.CardGroup as CardGroup
import Pyxis.Components.Field.Error as Error
import Pyxis.Components.Field.FieldStatus as FieldStatus exposing (FieldStatus)
import Pyxis.Components.Field.Hint as Hint
import Pyxis.Components.Field.Label as Label
import Pyxis.Components.IconSet as IconSet


{-| The RadioCardGroup model.
-}
type Model value msg
    = Model
        { selectedValue : Maybe value
        , fieldStatus : FieldStatus
        , onBlur : Maybe msg
        , onFocus : Maybe msg
        , onCheck : Maybe msg
        }


{-| Initialize the RadioCardGroup Model.
-}
init : Model value msg
init =
    Model
        { selectedValue = Nothing
        , fieldStatus = FieldStatus.init
        , onBlur = Nothing
        , onFocus = Nothing
        , onCheck = Nothing
        }


{-| The RadioCardGroup configuration.
-}
type Config validationData value parsedValue
    = Config
        { additionalContent : Maybe (Html Never)
        , classList : List ( String, Bool )
        , hint : Maybe Hint.Config
        , id : CommonsAlias.Id
        , isDisabled : Bool
        , label : Maybe Label.Config
        , layout : CardGroup.Layout
        , name : CommonsAlias.Name
        , options : List (Option value)
        , size : CardGroup.Size
        , validation : Maybe (CommonsAlias.Validation validationData (Maybe value) parsedValue)
        , errorShowingStrategy : Maybe Error.ShowingStrategy
        , isSubmitted : CommonsAlias.IsSubmitted
        }


{-| Initialize the RadioCardGroup Config.
-}
config : CommonsAlias.Name -> Config validationData value parsedValue
config name =
    Config
        { additionalContent = Nothing
        , classList = []
        , hint = Nothing
        , id = "id-" ++ name
        , isDisabled = False
        , layout = CardGroup.Horizontal
        , label = Nothing
        , name = name
        , options = []
        , size = CardGroup.Medium
        , errorShowingStrategy = Nothing
        , isSubmitted = False
        , validation = Nothing
        }


{-| Represent the messages which the RadioCardGroup can handle.
-}
type Msg value
    = OnCheck value
    | OnFocus
    | OnBlur


{-| Represent the single Radio option.
-}
type Option value
    = Option (OptionConfig value)


{-| Internal.
-}
type alias OptionConfig value =
    { value : value
    , text : Maybe String
    , title : Maybe String
    , addon : Maybe Addon
    }


{-| Generate a RadioCard Option
-}
option : OptionConfig value -> Option value
option =
    Option


{-| Represent the different types of addon
-}
type Addon
    = Addon CardGroup.Addon


{-| TextAddon for option.
-}
textAddon : String -> Maybe Addon
textAddon =
    CardGroup.TextAddon >> Addon >> Just


{-| IconAddon for option.
-}
iconAddon : IconSet.Icon -> Maybe Addon
iconAddon =
    CardGroup.IconAddon >> Addon >> Just


{-| ImgAddon for option.
-}
imgAddon : String -> Maybe Addon
imgAddon =
    CardGroup.ImgUrlAddon >> Addon >> Just


{-| Represent the layout of the group.
-}
type Layout
    = Layout CardGroup.Layout


{-| Horizontal layout.
-}
horizontal : Layout
horizontal =
    Layout CardGroup.Horizontal


{-| Vertical layout.
-}
vertical : Layout
vertical =
    Layout CardGroup.Vertical


{-| Change the visual layout. The default one is horizontal.
-}
withLayout : Layout -> Config validationData value parsedValue -> Config validationData value parsedValue
withLayout (Layout layout) (Config configuration) =
    Config { configuration | layout = layout }


{-| Append an additional custom html.
-}
withAdditionalContent : Html Never -> Config validationData value parsedValue -> Config validationData value parsedValue
withAdditionalContent additionalContent (Config configuration) =
    Config { configuration | additionalContent = Just additionalContent }


{-| Add the classes to the card group wrapper.
-}
withClassList : List ( String, Bool ) -> Config validationData value parsedValue -> Config validationData value parsedValue
withClassList classList (Config configuration) =
    Config { configuration | classList = classList }


{-| Define if the group is disabled or not.
-}
withDisabled : Bool -> Config validationData value parsedValue -> Config validationData value parsedValue
withDisabled isDisabled (Config configuration) =
    Config { configuration | isDisabled = isDisabled }


{-| Adds the hint to the RadioCardGroup.
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


{-| Add a label to the card group.
-}
withLabel : Label.Config -> Config validationData value parsedValue -> Config validationData value parsedValue
withLabel label (Config configuration) =
    Config { configuration | label = Just label }


{-| Define the visible options in the radio group.
-}
withOptions : List (Option value) -> Config validationData value parsedValue -> Config validationData value parsedValue
withOptions options (Config configuration) =
    Config { configuration | options = options }


{-| Card group size medium
-}
medium : CardGroup.Size
medium =
    CardGroup.Medium


{-| Card group size large
-}
large : CardGroup.Size
large =
    CardGroup.Large


{-| Define the size of cards.
-}
withSize : CardGroup.Size -> Config validationData value parsedValue -> Config validationData value parsedValue
withSize size (Config configuration) =
    Config { configuration | size = size }


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


{-| Render the RadioCardGroup.
-}
render : (Msg value -> msg) -> validationData -> Model value msg -> Config validationData value parsedValue -> Html msg
render tagger validationData ((Model { selectedValue }) as model) ((Config ({ isDisabled, options } as configData)) as config_) =
    let
        error : Maybe (Error.Config parsedValue)
        error =
            generateErrorConfig validationData model config_
    in
    options
        |> List.map (mapOption isDisabled selectedValue)
        |> CardGroup.renderRadio error configData
        |> Html.map tagger


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


mapOption : Bool -> Maybe value -> Option value -> CardGroup.Option (Msg value)
mapOption isDisabled checkedValue (Option { value, text, title, addon }) =
    { onCheck = always (OnCheck value)
    , onFocus = OnFocus
    , onBlur = OnBlur
    , addon = Maybe.map (\(Addon a) -> a) addon
    , text = text
    , title = title
    , isChecked = checkedValue == Just value
    , isDisabled = isDisabled
    }


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


{-| Set the field value
-}
setValue : value -> Model value msg -> Model value msg
setValue selectedValue (Model modelData) =
    Model { modelData | selectedValue = Just selectedValue }


{-| Reset the field value
-}
resetValue : Model value msg -> Model value msg
resetValue (Model modelData) =
    Model { modelData | selectedValue = Nothing }


{-| Return the selected value.
-}
getValue : Model value msg -> Maybe value
getValue (Model { selectedValue }) =
    selectedValue


{-| Internal
-}
mapFieldStatus : (FieldStatus -> FieldStatus) -> Model value msg -> Model value msg
mapFieldStatus f (Model model) =
    Model { model | fieldStatus = f model.fieldStatus }
