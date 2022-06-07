module Pyxis.Components.Field.Select exposing
    ( Model
    , init
    , getValue
    , setDropdownClosed
    , setId
    , setValue
    , validate
    , Config
    , config
    , small
    , medium
    , Size
    , withSize
    , withAdditionalContent
    , withClassList
    , withDisabled
    , withHint
    , withIsSubmitted
    , withLabel
    , withPlaceholder
    , withStrategy
    , Msg
    , update
    , Option
    , option
    , setOptions
    , render
    )

{-|


# Select component

@docs Model
@docs init
@docs getValue
@docs setDropdownClosed
@docs setId
@docs setValue
@docs validate


## Config

@docs Config
@docs config


## Size

@docs small
@docs medium
@docs Size
@docs withSize


## Generics

@docs withAdditionalContent
@docs withClassList
@docs withDisabled
@docs withHint
@docs withIsSubmitted
@docs withLabel
@docs withPlaceholder
@docs withStrategy


## Update

@docs Msg
@docs update


## Options

@docs Option
@docs option
@docs setOptions


## Rendering

@docs render

-}

import Array
import Browser.Dom as Dom
import Html exposing (Html)
import Html.Attributes
import Html.Events
import PrimaFunction
import PrimaUpdate
import Pyxis.Commons.Attributes as CommonsAttributes
import Pyxis.Commons.Events as CommonsEvents
import Pyxis.Commons.Events.KeyDown as KeyDown
import Pyxis.Commons.Render as CommonsRender
import Pyxis.Commons.String as CommonsString
import Pyxis.Components.Field.Error.Strategy as Strategy exposing (Strategy)
import Pyxis.Components.Field.Error.Strategy.Internal as StrategyInternal
import Pyxis.Components.Field.Hint as Hint
import Pyxis.Components.Field.Label as Label
import Pyxis.Components.Field.Status as FieldStatus
import Pyxis.Components.Form.FormItem as FormItem
import Pyxis.Components.Icon as Icon
import Pyxis.Components.IconSet as IconSet
import Result.Extra
import Task


{-| A type representing the internal component `Msg`
-}
type Msg
    = NoOp
    | OnBlur
    | OnClick Target
    | OnFocus
    | OnKeyDown Target KeyDown.Event
    | OnSelect String


type Target
    = Label
    | Select
    | DropdownOption Option


{-| A type representing the select field internal state
-}
type Model context parsedValue
    = Model
        { activeOption : Maybe Option
        , fieldStatus : FieldStatus.Status
        , id : String
        , isOpen : Bool
        , name : String
        , options : List Option
        , selectedValue : Maybe String
        , validation : context -> Maybe String -> Result String parsedValue
        }


{-| Initialize the select internal state. This belongs to your app's `Model`.
-}
init : String -> Maybe String -> (context -> Maybe String -> Result String parsedValue) -> Model context parsedValue
init name initialValue validation =
    Model
        { activeOption = Nothing
        , fieldStatus = FieldStatus.Untouched
        , id = "id-" ++ name
        , isOpen = False
        , name = name
        , options = []
        , selectedValue = initialValue
        , validation = validation
        }


{-| A type representing a `<select>` option
-}
type Option
    = Option OptionData


type alias OptionData =
    { id : String
    , index : Int
    , label : String
    , value : String
    }


{-| Create an Option
-}
option : { value : String, label : String } -> Option
option { value, label } =
    Option { value = value, label = label, id = "id-" ++ String.toLower label, index = 0 }


{-| Represents the Select view configuration.
-}
type Config
    = Config
        { additionalContent : Maybe (Html Never)
        , classList : List ( String, Bool )
        , hint : Maybe Hint.Config
        , isDisabled : Bool
        , isMobile : Bool
        , isSubmitted : Bool
        , label : Maybe Label.Config
        , placeholder : Maybe String
        , size : Size
        , strategy : Strategy
        }


{-| Creates the Select view configuration.
-}
config : Bool -> Config
config isMobile =
    Config
        { additionalContent = Nothing
        , classList = []
        , hint = Nothing
        , isDisabled = False
        , isMobile = isMobile
        , isSubmitted = False
        , label = Nothing
        , placeholder = Nothing
        , size = Medium
        , strategy = Strategy.onBlur
        }


{-| Select size
-}
type Size
    = Small
    | Medium


{-| Select size small
-}
small : Size
small =
    Small


{-| Select size medium
-}
medium : Size
medium =
    Medium


{-| Append an additional custom html.
-}
withAdditionalContent : Html Never -> Config -> Config
withAdditionalContent additionalContent (Config configuration) =
    Config { configuration | additionalContent = Just additionalContent }


{-| Set the classes of the <select> element
Note that

                select
                |> Select.withClassList ["a", True]
                |> Select.withClassList ["b", True]

Only has the "b" class

_WARNING_: this function is considered unstable and should be used only as an emergency escape hatch

-}
withClassList : List ( String, Bool ) -> Config -> Config
withClassList classList (Config select) =
    Config { select | classList = classList }


{-| Set the disabled attribute
-}
withDisabled : Bool -> Config -> Config
withDisabled isDisabled (Config select) =
    Config { select | isDisabled = isDisabled }


{-| Sets the component label
-}
withLabel : Label.Config -> Config -> Config
withLabel label (Config configData) =
    Config { configData | label = Just label }


{-| Adds the hint to the Select.
-}
withHint : String -> Config -> Config
withHint hintMessage (Config configuration) =
    Config
        { configuration
            | hint =
                Hint.config hintMessage
                    |> Just
        }


{-| Sets whether the form was submitted
-}
withIsSubmitted : Bool -> Config -> Config
withIsSubmitted isSubmitted (Config configuration) =
    Config { configuration | isSubmitted = isSubmitted }


{-| Set the text visible when no option is selected
Note: this is not a native placeholder attribute
-}
withPlaceholder : String -> Config -> Config
withPlaceholder placeholder (Config select) =
    Config { select | placeholder = Just placeholder }


{-| Set the select size
-}
withSize : Size -> Config -> Config
withSize size (Config select) =
    Config { select | size = size }


{-| Sets the validation strategy (when to show the error, if present)
-}
withStrategy : Strategy -> Config -> Config
withStrategy strategy (Config configuration) =
    Config { configuration | strategy = strategy }


{-| Internal.
-}
renderOptions : Model context parsedValue -> List (Html Msg)
renderOptions (Model { selectedValue, activeOption, options }) =
    let
        isActive : String -> Bool
        isActive value =
            activeOption
                |> Maybe.map (pickOptionData >> .value >> (==) value)
                |> Maybe.withDefault False
    in
    options
        |> List.map
            (\((Option { value, label, id }) as option_) ->
                Html.div
                    [ Html.Attributes.classList
                        [ ( "form-dropdown__item", True )
                        , ( "form-dropdown__item--hover", isActive value )
                        ]
                    , Html.Attributes.id id
                    , CommonsAttributes.role "option"
                    , CommonsAttributes.ariaSelected (CommonsString.fromBool (Just value == selectedValue))
                    , CommonsEvents.alwaysStopPropagationOn "click" (OnClick (DropdownOption option_))
                    , Html.Attributes.tabindex 0
                    , KeyDown.onKeyDownPreventDefaultOn (handleKeydown (DropdownOption option_))
                    ]
                    [ Html.text label ]
            )


renderNativeOptions : Config -> Model context parsedValue -> List (Html msg)
renderNativeOptions (Config { placeholder }) (Model { selectedValue, options }) =
    options
        |> List.map
            (\(Option { value, label }) ->
                Html.option
                    [ Html.Attributes.value value
                    , Html.Attributes.selected (Just value == selectedValue)
                    ]
                    [ Html.text label ]
            )
        |> (::)
            (Html.option
                [ Html.Attributes.hidden True
                , Html.Attributes.disabled True
                , Html.Attributes.selected True
                ]
                [ placeholder
                    |> Maybe.map Html.text
                    |> CommonsRender.renderMaybe
                ]
            )


renderAddon : Html msg
renderAddon =
    Html.div [ Html.Attributes.class "form-field__addon" ]
        [ IconSet.ChevronDown
            |> Icon.config
            |> Icon.render
        ]


{-| Render the html
-}
render : (Msg -> msg) -> context -> Model context parsedValue -> Config -> Html.Html msg
render tagger context ((Model modelData) as model) ((Config configData) as configuration) =
    let
        validationResult : Result String ()
        validationResult =
            StrategyInternal.getValidationResult
                modelData.fieldStatus
                (modelData.validation context modelData.selectedValue)
                configData.isSubmitted
                configData.strategy
    in
    Html.div
        [ Html.Attributes.classList
            [ ( "form-field", True )
            , ( "form-field--with-select-dropdown", not configData.isMobile )
            , ( "form-field--with-opened-dropdown", not configData.isMobile && modelData.isOpen )
            , ( "form-field--error", Result.Extra.error validationResult /= Nothing )
            , ( "form-field--disabled", configData.isDisabled )
            ]
        ]
        [ Html.label
            [ Html.Attributes.class "form-field__wrapper"
            , Html.Events.onClick (OnClick Label)
            ]
            [ Html.select
                [ Html.Attributes.classList
                    [ ( "form-field__select", True )
                    , ( "form-field__select--filled", modelData.selectedValue /= Nothing )
                    , ( "form-field__select--small", Small == configData.size )
                    ]
                , Html.Attributes.classList configData.classList
                , Html.Attributes.name modelData.name
                , Html.Attributes.id modelData.id
                , CommonsAttributes.testId modelData.id
                , Html.Attributes.disabled configData.isDisabled
                , Html.Events.onInput OnSelect
                , Html.Events.onFocus OnFocus
                , Html.Events.onBlur OnBlur
                , CommonsAttributes.renderIf (not configData.isMobile) (KeyDown.onKeyDownPreventDefaultOn (handleKeydown Select))
                ]
                (renderNativeOptions configuration model)
            , renderAddon
            ]
        , Html.div
            [ Html.Attributes.class "form-dropdown-wrapper"
            ]
            [ Html.div
                [ Html.Attributes.class "form-dropdown"
                , Html.Attributes.id "form-dropdown"
                , CommonsAttributes.role "listbox"
                ]
                (renderOptions model)
            ]
        ]
        |> FormItem.config
            { id = modelData.id
            , hint = Maybe.map (Hint.withFieldId modelData.id) configData.hint
            }
        |> FormItem.withAdditionalContent configData.additionalContent
        |> FormItem.withLabel (getLabelConfig configuration)
        |> FormItem.render validationResult
        |> Html.map tagger


getLabelConfig : Config -> Maybe Label.Config
getLabelConfig (Config configData) =
    Maybe.map (configData.size |> mapLabelSize |> Label.withSize) configData.label


mapLabelSize : Size -> Label.Size
mapLabelSize size =
    case size of
        Small ->
            Label.small

        Medium ->
            Label.medium


{-| Update the internal state of the Select component
-}
update : Msg -> Model ctx parsedValue -> ( Model ctx parsedValue, Cmd Msg )
update msg ((Model modelData) as model) =
    case msg of
        OnSelect value ->
            Model { modelData | selectedValue = Just value, isOpen = False }
                |> mapFieldStatus FieldStatus.onInput
                |> PrimaUpdate.withoutCmds

        OnClick Label ->
            Model { modelData | isOpen = True }
                |> PrimaUpdate.withoutCmds

        OnClick (DropdownOption (Option { value })) ->
            Model { modelData | selectedValue = Just value, isOpen = False }
                |> PrimaUpdate.withoutCmds

        OnClick _ ->
            model
                |> PrimaUpdate.withoutCmds

        OnKeyDown Select event ->
            Model
                { modelData
                    | isOpen =
                        if KeyDown.isArrowDown event || KeyDown.isSpace event then
                            True

                        else
                            modelData.isOpen
                }
                |> updateOnSelectKeyEvent event

        OnKeyDown (DropdownOption option_) event ->
            model
                |> updateOnOptionKeyEvent option_ event
                |> focusOnActiveOption

        OnKeyDown _ _ ->
            model
                |> PrimaUpdate.withoutCmds

        OnBlur ->
            model
                |> mapFieldStatus FieldStatus.onBlur
                |> PrimaUpdate.withoutCmds

        OnFocus ->
            model
                |> mapFieldStatus FieldStatus.onFocus
                |> PrimaUpdate.withoutCmds

        NoOp ->
            model
                |> PrimaUpdate.withoutCmds


focusOnActiveOption : Model context parsedValue -> PrimaUpdate.PrimaUpdate (Model context parsedValue) Msg
focusOnActiveOption ((Model modelData) as model) =
    model
        |> PrimaUpdate.withCmds
            [ modelData.activeOption
                |> Maybe.map (pickOptionData >> .id >> Dom.focus >> Task.attempt (always NoOp))
                |> Maybe.withDefault (Dom.focus modelData.id |> Task.attempt (always NoOp))
            ]


updateOnSelectKeyEvent : KeyDown.Event -> Model ctx value -> ( Model ctx value, Cmd Msg )
updateOnSelectKeyEvent event model =
    if KeyDown.isArrowDown event || KeyDown.isSpace event then
        model
            |> updateActiveOption 1 Nothing
            |> PrimaUpdate.withCmdsMap
                [ \(Model { options }) ->
                    options
                        |> List.head
                        |> Maybe.map (pickOptionData >> .id >> Dom.focus >> Task.attempt (always NoOp))
                        |> Maybe.withDefault Cmd.none
                ]

    else if KeyDown.isEsc event then
        model
            |> setDropdownClosed
            |> PrimaUpdate.withoutCmds

    else
        model
            |> PrimaUpdate.withoutCmds


updateOnOptionKeyEvent : Option -> KeyDown.Event -> Model ctx value -> Model ctx value
updateOnOptionKeyEvent option_ event ((Model modelData) as model) =
    if KeyDown.isArrowDown event then
        updateActiveOption 1 (Just option_) model

    else if KeyDown.isArrowUp event then
        updateActiveOption -1 (Just option_) model

    else if KeyDown.isEsc event then
        setDropdownClosed model

    else if KeyDown.isEnter event || KeyDown.isSpace event then
        modelData.activeOption
            |> Maybe.map (pickOptionData >> .value >> PrimaFunction.flip updateSelectedValue model)
            |> Maybe.withDefault model
            |> setDropdownClosed

    else
        model


{-| Internal.
-}
updateSelectedValue : String -> Model ctx value -> Model ctx value
updateSelectedValue value (Model modelData) =
    Model { modelData | selectedValue = Just value }


updateActiveOption : Int -> Maybe Option -> Model ctx value -> Model ctx value
updateActiveOption moveByPositions currentOption (Model modelData) =
    let
        newActiveOptionIndex : Int
        newActiveOptionIndex =
            currentOption
                |> Maybe.map (\(Option { index }) -> index)
                |> Maybe.withDefault -1
                |> (+) moveByPositions
    in
    Model
        { modelData
            | activeOption =
                if newActiveOptionIndex < 0 then
                    Nothing

                else if newActiveOptionIndex >= List.length modelData.options then
                    modelData.options
                        |> Array.fromList
                        |> Array.get 0

                else
                    modelData.options
                        |> Array.fromList
                        |> Array.get newActiveOptionIndex
        }


{-| Update the Autocomplete Model closing the dropdown
-}
setDropdownClosed : Model ctx value -> Model ctx value
setDropdownClosed (Model modelData) =
    Model { modelData | isOpen = False, activeOption = Nothing }


{-| Set the select options
-}
setOptions : List Option -> Model context parsedValue -> Model context parsedValue
setOptions options (Model modelData) =
    Model
        { modelData
            | options =
                List.indexedMap
                    (\index (Option { value, label, id }) ->
                        Option
                            { value = value
                            , label = label
                            , index = index
                            , id = id
                            }
                    )
                    options
        }


{-| Set the id attribute
-}
setId : String -> Model context msg -> Model context msg
setId id (Model modelData) =
    Model { modelData | id = id }


{-| Internal.
-}
setValue : String -> Model ctx parsedValue -> Model ctx parsedValue
setValue selectedValue (Model model) =
    Model { model | selectedValue = Just selectedValue }


{-| Returns the current native value of the Select
-}
getValue : Model ctx parsedValue -> Maybe String
getValue (Model { selectedValue }) =
    selectedValue


{-| Internal
-}
handleKeydown : Target -> KeyDown.Event -> ( Msg, Bool )
handleKeydown target key =
    ( OnKeyDown target key
    , List.any
        (\check -> check key)
        [ KeyDown.isArrowUp, KeyDown.isArrowDown, KeyDown.isEnter, KeyDown.isSpace ]
    )


{-| Returns the validated value of the select
-}
validate : ctx -> Model ctx parsedValue -> Result String parsedValue
validate ctx (Model { selectedValue, validation }) =
    validation ctx selectedValue


{-| Internal.
-}
pickOptionData : Option -> OptionData
pickOptionData (Option optionData) =
    optionData


{-| Internal.
-}
mapFieldStatus : (FieldStatus.Status -> FieldStatus.Status) -> Model ctx parsedValue -> Model ctx parsedValue
mapFieldStatus f (Model model) =
    Model { model | fieldStatus = f model.fieldStatus }
