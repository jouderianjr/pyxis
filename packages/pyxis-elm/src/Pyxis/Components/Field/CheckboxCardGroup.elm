module Pyxis.Components.Field.CheckboxCardGroup exposing
    ( Model
    , init
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
    , withIsSubmitted
    , withLabel
    , withId
    , withStrategy
    , medium
    , large
    , withSize
    , Msg
    , isOnCheck
    , update
    , updateValue
    , getValue
    , validate
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
@docs withIsSubmitted
@docs withLabel
@docs withId
@docs withStrategy


## Size

@docs medium
@docs large
@docs withSize


## Update

@docs Msg
@docs isOnCheck
@docs update
@docs updateValue


## Readers

@docs getValue
@docs validate


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
import Pyxis.Components.CardGroup as CardGroup
import Pyxis.Components.Field.Error.Strategy as Strategy exposing (Strategy)
import Pyxis.Components.Field.Error.Strategy.Internal as InternalStrategy
import Pyxis.Components.Field.Hint as Hint
import Pyxis.Components.Field.Label as Label
import Pyxis.Components.Field.Status as FieldStatus
import Pyxis.Components.IconSet as IconSet


type alias ModelData ctx value parsedValue =
    { checkedValues : List value
    , validation : ctx -> List value -> Result String parsedValue
    , fieldStatus : FieldStatus.Status
    }


{-| The CheckboxCardGroup model.
-}
type Model ctx value parsedValue
    = Model (ModelData ctx value parsedValue)


{-| Initialize the CheckboxCardGroup Model.
-}
init : List value -> (ctx -> List value -> Result String parsedValue) -> Model ctx value parsedValue
init initialValues validation =
    Model
        { checkedValues = initialValues
        , validation = validation
        , fieldStatus = FieldStatus.Untouched
        }


type alias ConfigData value =
    { additionalContent : Maybe (Html Never)
    , classList : List ( String, Bool )
    , hint : Maybe Hint.Config
    , id : String
    , isDisabled : Bool
    , label : Maybe Label.Config
    , layout : CardGroup.Layout
    , name : String
    , options : List (Option value)
    , size : CardGroup.Size
    , strategy : Strategy
    , isSubmitted : Bool
    }


{-| The CheckboxCardGroup configuration.
-}
type Config value
    = Config (ConfigData value)


{-| Initialize the CheckboxCardGroup Config.
-}
config : String -> Config value
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
        , strategy = Strategy.onBlur
        , isSubmitted = False
        }


{-| Represent the messages which the CheckboxCardGroup can handle.
-}
type Msg value
    = Checked value Bool
    | Focused value
    | Blurred value


{-| Update the CheckboxGroup Model.
-}
update : Msg value -> Model ctx value parsedValue -> Model ctx value parsedValue
update msg model =
    case msg of
        Checked value check ->
            model
                |> PrimaFunction.ifThenElseMap (always check)
                    (checkValue value)
                    (uncheckValue value)
                |> mapFieldStatus FieldStatus.onChange

        Focused _ ->
            model
                |> mapFieldStatus FieldStatus.onFocus

        Blurred _ ->
            model
                |> mapFieldStatus FieldStatus.onBlur


{-| Update the field value.
-}
updateValue : value -> Bool -> Model ctx value parsedValue -> Model ctx value parsedValue
updateValue value checked =
    update (Checked value checked)


{-| Internal
-}
checkValue : value -> Model ctx value parsedValue -> Model ctx value parsedValue
checkValue value =
    mapCheckedValues ((::) value)


{-| Internal
-}
uncheckValue : value -> Model ctx value parsedValue -> Model ctx value parsedValue
uncheckValue value =
    mapCheckedValues (List.filter ((/=) value))


{-| Return the selected value.
-}
getValue : Model ctx value parsedValue -> List value
getValue (Model { checkedValues }) =
    checkedValues


{-| Get the parsed value
-}
validate : ctx -> Model ctx value parsedValue -> Result String parsedValue
validate ctx (Model { checkedValues, validation }) =
    validation ctx checkedValues


{-| Returns True if the message is triggered by `Html.Events.onCheck`
-}
isOnCheck : Msg value -> Bool
isOnCheck msg =
    case msg of
        Checked _ _ ->
            True

        _ ->
            False


{-| Represent the single Checkbox option.
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
withLayout : Layout -> Config value -> Config value
withLayout (Layout layout) (Config configuration) =
    Config { configuration | layout = layout }


{-| Add the classes to the card group wrapper.
-}
withClassList : List ( String, Bool ) -> Config value -> Config value
withClassList classList (Config configuration) =
    Config { configuration | classList = classList }


{-| Adds the hint to the CheckboxCardGroup.
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


{-| Add an ID to the inputs.
-}
withId : String -> Config value -> Config value
withId id (Config configuration) =
    Config { configuration | id = id }


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


{-| Add a label to the card group.
-}
withLabel : Label.Config -> Config value -> Config value
withLabel label (Config configuration) =
    Config { configuration | label = Just label }


{-| Define the visible options in the checkbox group.
-}
withOptions : List (Option value) -> Config value -> Config value
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
withSize : CardGroup.Size -> Config value -> Config value
withSize size (Config configuration) =
    Config { configuration | size = size }


{-| Append an additional custom html.
-}
withAdditionalContent : Html Never -> Config value -> Config value
withAdditionalContent additionalContent (Config configuration) =
    Config { configuration | additionalContent = Just additionalContent }


{-| Render the checkboxCardGroup
-}
render : (Msg value -> msg) -> ctx -> Model ctx value parsedValue -> Config value -> Html msg
render tagger ctx (Model modelData) (Config configData) =
    let
        shownValidation : Result String ()
        shownValidation =
            InternalStrategy.getShownValidation
                modelData.fieldStatus
                (modelData.validation ctx modelData.checkedValues)
                configData.isSubmitted
                configData.strategy
    in
    CardGroup.renderCheckbox
        shownValidation
        configData
        (List.map (mapOption tagger modelData.checkedValues) configData.options)


{-| Internal
-}
mapOption : (Msg value -> msg) -> List value -> Option value -> CardGroup.Option msg
mapOption tagger checkedValues (Option { value, text, title, addon, disabled }) =
    { onCheck = Checked value >> tagger
    , onBlur = Blurred value |> tagger
    , onFocus = Focused value |> tagger
    , addon = Maybe.map (\(Addon a) -> a) addon
    , text = text
    , title = title
    , isChecked = List.member value checkedValues
    , isDisabled = disabled
    }



-- Getters/Setters boilerplate


{-| Internal
-}
mapCheckedValues : (List value -> List value) -> Model ctx value parsedValue -> Model ctx value parsedValue
mapCheckedValues f (Model r) =
    Model { r | checkedValues = f r.checkedValues }


{-| Internal
-}
mapFieldStatus : (FieldStatus.Status -> FieldStatus.Status) -> Model ctx value parsedValue -> Model ctx value parsedValue
mapFieldStatus f (Model model) =
    Model { model | fieldStatus = f model.fieldStatus }
