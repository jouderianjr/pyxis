module Components.Field.RadioCardGroup exposing
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
    , withDisabled
    , withHint
    , withLabel
    , withName
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
    , render
    )

{-|


# RadioCardGroup component

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
@docs withDisabled
@docs withHint
@docs withIsSubmitted
@docs withLabel
@docs withName

@docs withSize
@docs withStrategy


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


## Rendering

@docs render

-}

import Commons.Properties.Size as Size exposing (Size)
import Components.CardGroup as CardGroup
import Components.Field.Error.Strategy as Strategy exposing (Strategy)
import Components.Field.Error.Strategy.Internal as InternalStrategy
import Components.Field.Hint as Hint
import Components.Field.Label as Label
import Components.Field.Status as FieldStatus
import Components.IconSet as IconSet
import Html exposing (Html)


{-| The RadioCardGroup model.
-}
type Model ctx value parsedValue
    = Model
        { selectedValue : Maybe value
        , validation : ctx -> Maybe value -> Result String parsedValue
        , fieldStatus : FieldStatus.Status
        }


{-| Initialize the RadioCardGroup Model.
-}
init : Maybe value -> (ctx -> Maybe value -> Result String parsedValue) -> Model ctx value parsedValue
init initialValue validation =
    Model
        { selectedValue = initialValue
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
    , name : Maybe String
    , options : List (Option value)
    , size : Size
    , strategy : Strategy
    , isSubmitted : Bool
    }


{-| The RadioCardGroup configuration.
-}
type Config value
    = Config (ConfigData value)


{-| Initialize the RadioCardGroup Config.
-}
config : String -> Config value
config id =
    Config
        { additionalContent = Nothing
        , classList = []
        , hint = Nothing
        , id = id
        , isDisabled = False
        , layout = CardGroup.Horizontal
        , label = Nothing
        , name = Nothing
        , options = []
        , size = Size.medium
        , strategy = Strategy.onBlur
        , isSubmitted = False
        }


{-| Represent the messages which the RadioCardGroup can handle.
-}
type Msg value
    = OnCheck value
    | Focused value
    | Blurred value


{-| Returns True if the message is triggered by `Html.Events.onCheck`
-}
isOnCheck : Msg value -> Bool
isOnCheck msg =
    case msg of
        OnCheck _ ->
            True

        _ ->
            False


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
withLayout : Layout -> Config value -> Config value
withLayout (Layout layout) (Config configuration) =
    Config { configuration | layout = layout }


{-| Add the classes to the card group wrapper.
-}
withClassList : List ( String, Bool ) -> Config value -> Config value
withClassList classList (Config configuration) =
    Config { configuration | classList = classList }


{-| Define if the group is disabled or not.
-}
withDisabled : Bool -> Config value -> Config value
withDisabled isDisabled (Config configuration) =
    Config { configuration | isDisabled = isDisabled }


{-| Adds the hint to the RadioCardGroup.
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


{-| Add a name to the inputs.
-}
withName : String -> Config value -> Config value
withName name (Config configuration) =
    Config { configuration | name = Just name }


{-| Add a label to the card group.
-}
withLabel : Label.Config -> Config value -> Config value
withLabel label (Config configuration) =
    Config { configuration | label = Just label }


{-| Define the visible options in the radio group.
-}
withOptions : List (Option value) -> Config value -> Config value
withOptions options (Config configuration) =
    Config { configuration | options = options }


{-| Define the size of cards.
-}
withSize : Size -> Config value -> Config value
withSize size (Config configuration) =
    Config { configuration | size = size }


{-| Append an additional custom html.
-}
withAdditionalContent : Html Never -> Config value -> Config value
withAdditionalContent additionalContent (Config configuration) =
    Config { configuration | additionalContent = Just additionalContent }


{-| Render the RadioCardGroup.
-}
render : (Msg value -> msg) -> ctx -> Model ctx value parsedValue -> Config value -> Html msg
render tagger ctx (Model modelData) (Config configData) =
    let
        shownValidation : Result String ()
        shownValidation =
            InternalStrategy.getShownValidation
                modelData.fieldStatus
                (modelData.validation ctx modelData.selectedValue)
                configData.isSubmitted
                configData.strategy
    in
    CardGroup.renderRadio shownValidation
        configData
        (List.map (mapOption configData modelData.selectedValue) configData.options)
        |> Html.map tagger


mapOption : { config | isDisabled : Bool } -> Maybe value -> Option value -> CardGroup.Option (Msg value)
mapOption { isDisabled } checkedValue (Option { value, text, title, addon }) =
    { onCheck = always (OnCheck value)
    , onFocus = Focused value
    , onBlur = Blurred value
    , addon = Maybe.map (\(Addon a) -> a) addon
    , text = text
    , title = title
    , isChecked = checkedValue == Just value
    , isDisabled = isDisabled
    }


{-| Update the RadioGroup Model.
-}
update : Msg value -> Model ctx value parsedValue -> Model ctx value parsedValue
update msg model =
    case msg of
        OnCheck value ->
            model
                |> setValue value
                |> mapFieldStatus FieldStatus.onChange

        Blurred _ ->
            model
                |> mapFieldStatus FieldStatus.onBlur

        Focused _ ->
            model
                |> mapFieldStatus FieldStatus.onFocus


{-| Update the field value.
-}
updateValue : value -> Model ctx value parsedValue -> Model ctx value parsedValue
updateValue value =
    update (OnCheck value)


{-| Internal.
-}
setValue : value -> Model ctx value parsedValue -> Model ctx value parsedValue
setValue value (Model model) =
    Model { model | selectedValue = Just value }


{-| Return the selected value.
-}
getValue : Model ctx value parsedValue -> Maybe value
getValue (Model { selectedValue }) =
    selectedValue


{-| Get the parsed value
-}
validate : ctx -> Model ctx value parsedValue -> Result String parsedValue
validate ctx (Model { selectedValue, validation }) =
    validation ctx selectedValue


{-| Internal
-}
mapFieldStatus : (FieldStatus.Status -> FieldStatus.Status) -> Model ctx value parsedValue -> Model ctx value parsedValue
mapFieldStatus f (Model model) =
    Model { model | fieldStatus = f model.fieldStatus }
