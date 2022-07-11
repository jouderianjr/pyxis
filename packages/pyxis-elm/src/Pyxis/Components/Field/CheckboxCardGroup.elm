module Pyxis.Components.Field.CheckboxCardGroup exposing
    ( Model
    , init
    , setOnBlur
    , setOnFocus
    , setOnCheck
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
    , withDisabledOption
    , render
    )

{-|


# CheckboxCardGroup component

@docs Model
@docs init
@docs setOnBlur
@docs setOnFocus
@docs setOnCheck


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
@docs withDisabledOption


## Rendering

@docs render

-}

import Html exposing (Html)
import PrimaFunction
import PrimaUpdate
import Pyxis.Commons.Alias as CommonsAlias
import Pyxis.Commons.Commands as Commands
import Pyxis.Components.CardGroup as CardGroup
import Pyxis.Components.Field.Error as Error
import Pyxis.Components.Field.FieldStatus as FieldStatus exposing (FieldStatus)
import Pyxis.Components.Field.Hint as Hint
import Pyxis.Components.Field.Label as Label
import Pyxis.Components.IconSet as IconSet


{-| The CheckboxCardGroup model.
-}
type Model value msg
    = Model
        { checkedValues : List value
        , fieldStatus : FieldStatus
        , onBlur : Maybe msg
        , onFocus : Maybe msg
        , onCheck : Maybe msg
        }


{-| Initialize the CheckboxCardGroup Model.
-}
init : List value -> Model value msg
init initialValues =
    Model
        { checkedValues = initialValues
        , fieldStatus = FieldStatus.init
        , onBlur = Nothing
        , onFocus = Nothing
        , onCheck = Nothing
        }


{-| The CheckboxCardGroup configuration.
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
        , errorShowingStrategy : Maybe Error.ShowingStrategy
        , isSubmitted : CommonsAlias.IsSubmitted
        , validation : Maybe (CommonsAlias.Validation validationData (List value) parsedValue)
        }


{-| Initialize the CheckboxCardGroup Config.
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


{-| Represent the messages which the CheckboxCardGroup can handle.
-}
type Msg value
    = OnCheck value Bool
    | OnFocus value
    | OnBlur value


{-| Update the CheckboxGroup Model.
-}
update : Msg value -> Model value msg -> ( Model value msg, Cmd msg )
update msg ((Model modelData) as model) =
    case msg of
        OnBlur _ ->
            model
                |> mapFieldStatus (FieldStatus.setIsBlurred True)
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onBlur ]

        OnFocus _ ->
            model
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onFocus ]

        OnCheck value check ->
            model
                |> PrimaFunction.ifThenElseMap (always check)
                    (checkValue value)
                    (uncheckValue value)
                |> mapFieldStatus (FieldStatus.setIsDirty True)
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onCheck ]


{-| Update the field value.
-}
updateValue : value -> Bool -> Model value msg -> ( Model value msg, Cmd msg )
updateValue value checked =
    update (OnCheck value checked)


{-| Internal
-}
checkValue : value -> Model value msg -> Model value msg
checkValue value =
    mapCheckedValues ((::) value)


{-| Internal
-}
uncheckValue : value -> Model value msg -> Model value msg
uncheckValue value =
    mapCheckedValues (List.filter ((/=) value))


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


{-| Return the selected value.
-}
getValue : Model value msg -> List value
getValue (Model { checkedValues }) =
    checkedValues


{-| Represent the single Checkbox option.
-}
type Option value
    = Option
        { value : value
        , text : Maybe String
        , title : Maybe String
        , addon : Maybe Addon
        , disabled : Bool
        }


{-| Generate a CheckboxCard Option
-}
option :
    { value : value
    , text : Maybe String
    , title : Maybe String
    , addon : Maybe Addon
    }
    -> Option value
option args =
    Option
        { value = args.value
        , text = args.text
        , title = args.title
        , addon = args.addon
        , disabled = False
        }


{-| Sets the disabled attribute on option
-}
withDisabledOption : Bool -> Option value -> Option value
withDisabledOption disabled (Option option_) =
    Option { option_ | disabled = disabled }


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


{-| Add the classes to the card group wrapper.
-}
withClassList : List ( String, Bool ) -> Config validationData value parsedValue -> Config validationData value parsedValue
withClassList classList (Config configuration) =
    Config { configuration | classList = classList }


{-| Adds the hint to the CheckboxCardGroup.
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


{-| Add an ID to the inputs.
-}
withId : CommonsAlias.Id -> Config validationData value parsedValue -> Config validationData value parsedValue
withId id (Config configuration) =
    Config { configuration | id = id }


{-| Add a label to the card group.
-}
withLabel : Label.Config -> Config validationData value parsedValue -> Config validationData value parsedValue
withLabel label (Config configuration) =
    Config { configuration | label = Just label }


{-| Define the visible options in the checkbox group.
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


{-| Append an additional custom html.
-}
withAdditionalContent : Html Never -> Config validationData value parsedValue -> Config validationData value parsedValue
withAdditionalContent additionalContent (Config configuration) =
    Config { configuration | additionalContent = Just additionalContent }


{-| Sets the showing error strategy to `OnSubmit` (The error will be shown only after the form submission)
-}
withValidationOnSubmit :
    CommonsAlias.Validation validationData (List value) parsedValue
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
    CommonsAlias.Validation validationData (List value) parsedValue
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
    CommonsAlias.Validation validationData (List value) parsedValue
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


{-| Render the checkboxCardGroup
-}
render : (Msg value -> msg) -> validationData -> Model value msg -> Config validationData value parsedValue -> Html msg
render tagger validationData ((Model { checkedValues }) as model) ((Config configData) as config_) =
    CardGroup.renderCheckbox
        (generateErrorConfig validationData model config_)
        configData
        (List.map (mapOption tagger checkedValues) configData.options)


{-| Internal
-}
generateErrorConfig : validationData -> Model value msg -> Config validationData value parsedValue -> Maybe (Error.Config parsedValue)
generateErrorConfig validationData (Model { fieldStatus, checkedValues }) (Config { id, isSubmitted, validation, errorShowingStrategy }) =
    let
        getErrorConfig : Result CommonsAlias.ErrorMessage parsedValue -> Error.ShowingStrategy -> Error.Config parsedValue
        getErrorConfig validationResult =
            Error.config id validationResult
                >> Error.withIsDirty fieldStatus.isDirty
                >> Error.withIsBlurred fieldStatus.isBlurred
                >> Error.withIsSubmitted isSubmitted
    in
    Maybe.map2 getErrorConfig
        (Maybe.map (\v -> v validationData checkedValues) validation)
        errorShowingStrategy


{-| Internal
-}
mapOption : (Msg value -> msg) -> List value -> Option value -> CardGroup.Option msg
mapOption tagger checkedValues (Option { value, text, title, addon, disabled }) =
    { onCheck = OnCheck value >> tagger
    , onBlur = OnBlur value |> tagger
    , onFocus = OnFocus value |> tagger
    , addon = Maybe.map (\(Addon a) -> a) addon
    , text = text
    , title = title
    , isChecked = List.member value checkedValues
    , isDisabled = disabled
    }


{-| Internal
-}
mapCheckedValues : (List value -> List value) -> Model value msg -> Model value msg
mapCheckedValues f (Model r) =
    Model { r | checkedValues = f r.checkedValues }


{-| Internal
-}
mapFieldStatus : (FieldStatus -> FieldStatus) -> Model value msg -> Model value msg
mapFieldStatus mapper (Model model) =
    Model { model | fieldStatus = mapper model.fieldStatus }
