module Pyxis.Components.Field.Select exposing
    ( Model
    , init
    , getValue
    , setDropdownClosed
    , setId
    , setOnFocus
    , setOnReset
    , setOnInput
    , setOnSelect
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
@docs setOnFocus
@docs setOnReset
@docs setOnInput
@docs setOnSelect
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
import List.Extra
import Maybe.Extra
import PrimaFunction
import PrimaUpdate
import Pyxis.Commons.Attributes as CommonsAttributes
import Pyxis.Commons.Commands as Commands
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
    | OnClick Target
    | OnFocus
    | OnKeyDown Target KeyDown.Event
    | OnSelect String


type Target
    = Select
    | DropdownOption Option


{-| A type representing the select field internal state
-}
type Model ctx value msg
    = Model
        { activeOption : Maybe Option
        , fieldStatus : FieldStatus.Status
        , id : String
        , isOpen : Bool
        , name : String
        , onBlur : Maybe msg
        , onFocus : Maybe msg
        , onReset : Maybe msg
        , onInput : Maybe msg
        , onSelect : Maybe msg
        , options : List Option
        , selectedValue : Maybe String
        , validation : ctx -> Maybe String -> Result String value
        }


{-| Initialize the select internal state. This belongs to your app's `Model`.
-}
init : String -> Maybe String -> (ctx -> Maybe String -> Result String value) -> Model ctx value msg
init name initialValue validation =
    Model
        { activeOption = Nothing
        , fieldStatus = FieldStatus.Untouched
        , id = "id-" ++ name
        , isOpen = False
        , name = name
        , options = []
        , onBlur = Nothing
        , onFocus = Nothing
        , onInput = Nothing
        , onReset = Nothing
        , onSelect = Nothing
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
renderOptions : Model ctx value msg -> Config -> List (Html Msg)
renderOptions (Model { selectedValue, activeOption, options }) (Config { isDisabled }) =
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
                        , ( "form-dropdown__item--active", selectedValue == Just value )
                        ]
                    , Html.Attributes.id id
                    , CommonsAttributes.role "option"
                    , CommonsAttributes.ariaSelected (CommonsString.fromBool (Just value == selectedValue))
                    , CommonsEvents.alwaysStopPropagationOn "click" (OnClick (DropdownOption option_))
                    , Html.Attributes.tabindex 0
                    , CommonsAttributes.renderIf
                        (not isDisabled)
                        (KeyDown.onKeyDownPreventDefaultOn (handleKeydown (DropdownOption option_)))
                    ]
                    [ Html.text label ]
            )


renderNativeOptions : Config -> Model ctx value msg -> List (Html Msg)
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
render : (Msg -> msg) -> ctx -> Model ctx value msg -> Config -> Html.Html msg
render tagger ctx ((Model modelData) as model) ((Config configData) as configuration) =
    let
        validationResult : Result String ()
        validationResult =
            StrategyInternal.getValidationResult
                modelData.fieldStatus
                (modelData.validation ctx modelData.selectedValue)
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
                , CommonsAttributes.renderIf (not configData.isDisabled) (Html.Events.onInput OnSelect)
                , CommonsAttributes.renderIf (not configData.isDisabled) (Html.Events.onFocus OnFocus)
                , CommonsAttributes.renderIf (not configData.isDisabled) (CommonsEvents.alwaysStopPropagationOn "click" (OnClick Select))
                , CommonsAttributes.renderIf
                    (not configData.isMobile && not configData.isDisabled)
                    (KeyDown.onKeyDownPreventDefaultOn (handleKeydown Select))
                ]
                (renderNativeOptions configuration model)
            , renderAddon
            ]
        , Html.div
            [ Html.Attributes.classList
                [ ( "form-dropdown-wrapper", True )
                , ( "form-dropdown-wrapper--small", configData.size == Small )
                ]
            ]
            [ Html.div
                [ Html.Attributes.class "form-dropdown"
                , Html.Attributes.id "form-dropdown"
                , CommonsAttributes.role "listbox"
                ]
                (renderOptions model configuration)
            ]
        ]
        |> FormItem.config
            { id = modelData.id
            , hint = Maybe.map (Hint.withFieldId modelData.id) configData.hint
            }
        |> FormItem.withAdditionalContent configData.additionalContent
        |> FormItem.withLabel (getLabelConfig configuration model)
        |> FormItem.render validationResult
        |> Html.map tagger


getLabelConfig : Config -> Model ctx value msg -> Maybe Label.Config
getLabelConfig (Config configData) (Model { id }) =
    configData.label
        |> Maybe.map (configData.size |> mapLabelSize |> Label.withSize)
        |> Maybe.map (Label.withFor id)


mapLabelSize : Size -> Label.Size
mapLabelSize size =
    case size of
        Small ->
            Label.small

        Medium ->
            Label.medium


{-| Update the internal state of the Select component
-}
update : (Msg -> msg) -> Msg -> Model ctx value msg -> ( Model ctx value msg, Cmd msg )
update tagger msg ((Model modelData) as model) =
    case msg of
        OnSelect value ->
            model
                |> updateSelectedValue value
                |> updateIsOpen False
                |> resetActiveOption
                |> mapFieldStatus FieldStatus.onInput
                |> PrimaUpdate.withCmds [ Commands.dispatchFromMaybe modelData.onSelect ]

        OnClick (DropdownOption (Option { value })) ->
            model
                |> updateSelectedValue value
                |> updateIsOpen False
                |> resetActiveOption
                |> PrimaUpdate.withCmds [ Commands.dispatchFromMaybe modelData.onSelect ]

        OnClick Select ->
            model
                |> updateIsOpen (not modelData.isOpen)
                |> resetActiveOption
                |> mapFieldStatus FieldStatus.onFocus
                |> PrimaUpdate.withCmdsMap
                    [ \((Model { isOpen }) as model_) ->
                        if isOpen then
                            focusOnActiveOption tagger model_

                        else
                            Cmd.none
                    ]

        OnKeyDown Select event ->
            model
                |> updateIsOpen (KeyDown.isArrowDown event || KeyDown.isSpace event || modelData.isOpen)
                |> updateOnSelectKeyEvent tagger event

        OnKeyDown (DropdownOption _) event ->
            model
                |> updateOnOptionKeyEvent event
                |> PrimaUpdate.withCmdsMap [ focusOnActiveOption tagger ]

        OnFocus ->
            model
                |> mapFieldStatus FieldStatus.onFocus
                |> PrimaUpdate.withCmds [ Commands.dispatchFromMaybe modelData.onFocus ]

        NoOp ->
            model
                |> PrimaUpdate.withoutCmds


focusOnActiveOption : (Msg -> msg) -> Model ctx value msg -> Cmd msg
focusOnActiveOption tagger ((Model modelData) as model) =
    model
        |> getSelectedOption
        |> Maybe.Extra.or modelData.activeOption
        |> Maybe.map (pickOptionData >> .id >> Dom.focus >> Task.attempt (always NoOp))
        |> Maybe.withDefault (Dom.focus modelData.id |> Task.attempt (always NoOp))
        |> Cmd.map tagger


{-| Internal.
-}
updateOnSelectKeyEvent : (Msg -> msg) -> KeyDown.Event -> Model ctx value msg -> ( Model ctx value msg, Cmd msg )
updateOnSelectKeyEvent tagger event ((Model { onSelect, isOpen }) as model) =
    if KeyDown.isArrowDown event || (KeyDown.isSpace event && not isOpen) then
        model
            |> updateActiveOption 1
            |> PrimaUpdate.withCmdsMap [ focusOnActiveOption tagger ]

    else if KeyDown.isArrowUp event && isOpen then
        model
            |> updateActiveOption -1
            |> PrimaUpdate.withCmdsMap [ focusOnActiveOption tagger ]

    else if KeyDown.isEsc event then
        model
            |> setDropdownClosed
            |> PrimaUpdate.withoutCmds

    else if KeyDown.isSpace event || KeyDown.isEnter event then
        model
            |> PrimaUpdate.withCmds [ Commands.dispatchFromMaybe onSelect ]

    else
        model
            |> PrimaUpdate.withoutCmds


updateOnOptionKeyEvent : KeyDown.Event -> Model ctx value msg -> Model ctx value msg
updateOnOptionKeyEvent event ((Model modelData) as model) =
    if KeyDown.isArrowDown event then
        updateActiveOption 1 model

    else if KeyDown.isArrowUp event && Maybe.Extra.isJust (getActiveOption model) then
        updateActiveOption -1 model

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
updateSelectedValue : String -> Model ctx value msg -> Model ctx value msg
updateSelectedValue value (Model modelData) =
    Model { modelData | selectedValue = Just value }


{-| Internal.
-}
updateIsOpen : Bool -> Model ctx value msg -> Model ctx value msg
updateIsOpen isOpen (Model modelData) =
    Model { modelData | isOpen = isOpen }


{-| Internal.
-}
resetActiveOption : Model ctx value msg -> Model ctx value msg
resetActiveOption ((Model modelData) as model) =
    Model { modelData | activeOption = getSelectedOption model }


getActiveOption : Model ctx value msg -> Maybe Option
getActiveOption ((Model { activeOption }) as model) =
    Maybe.Extra.or activeOption (getSelectedOption model)


getNewActiveOption : Int -> Model ctx value msg -> Maybe Option
getNewActiveOption moveByPositions (Model { options, activeOption }) =
    let
        newOptionIndex : Int
        newOptionIndex =
            activeOption
                |> Maybe.map (\(Option { index }) -> index)
                |> Maybe.withDefault -1
                |> (+) moveByPositions
    in
    if newOptionIndex < 0 then
        List.head options

    else if newOptionIndex >= List.length options then
        options
            |> List.reverse
            |> List.head

    else
        options
            |> Array.fromList
            |> Array.get newOptionIndex


{-| Internal.
-}
updateActiveOption : Int -> Model ctx value msg -> Model ctx value msg
updateActiveOption moveByPositions ((Model modelData) as model) =
    Model { modelData | activeOption = getNewActiveOption moveByPositions model }


{-| Update the Autocomplete Model closing the dropdown
-}
setDropdownClosed : Model ctx value msg -> Model ctx value msg
setDropdownClosed (Model modelData) =
    Model { modelData | isOpen = False }
        |> resetActiveOption
        |> mapFieldStatus FieldStatus.onInput


{-| Set the select options
-}
setOptions : List Option -> Model ctx value msg -> Model ctx value msg
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
                            , id = id ++ "-" ++ modelData.name
                            }
                    )
                    options
        }


{-| Set the id attribute
-}
setId : String -> Model ctx value msg -> Model ctx value msg
setId id (Model modelData) =
    Model { modelData | id = id }


{-| Internal.
-}
setValue : String -> Model ctx value msg -> Model ctx value msg
setValue selectedValue (Model model) =
    Model { model | selectedValue = Just selectedValue }


{-| Sets an OnFocus side effect.
-}
setOnFocus : msg -> Model ctx value msg -> Model ctx value msg
setOnFocus msg (Model configuration) =
    Model { configuration | onFocus = Just msg }


{-| Sets an OnReset side effect.
-}
setOnReset : msg -> Model ctx value msg -> Model ctx value msg
setOnReset msg (Model configuration) =
    Model { configuration | onReset = Just msg }


{-| Sets an OnInput side effect.
-}
setOnInput : msg -> Model ctx value msg -> Model ctx value msg
setOnInput msg (Model configuration) =
    Model { configuration | onInput = Just msg }


{-| Sets an OnSelect side effect.
-}
setOnSelect : msg -> Model ctx value msg -> Model ctx value msg
setOnSelect msg (Model configuration) =
    Model { configuration | onSelect = Just msg }


{-| Returns the current native value of the Select
-}
getValue : Model ctx value msg -> Maybe String
getValue (Model { selectedValue }) =
    selectedValue


getSelectedOption : Model ctx value msg -> Maybe Option
getSelectedOption (Model { selectedValue, options }) =
    List.Extra.find (\(Option { value }) -> Just value == selectedValue) options


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
validate : ctx -> Model ctx value msg -> Result String value
validate ctx (Model { selectedValue, validation }) =
    validation ctx selectedValue


{-| Internal.
-}
pickOptionData : Option -> OptionData
pickOptionData (Option optionData) =
    optionData


{-| Internal.
-}
mapFieldStatus : (FieldStatus.Status -> FieldStatus.Status) -> Model ctx value msg -> Model ctx value msg
mapFieldStatus f (Model model) =
    Model { model | fieldStatus = f model.fieldStatus }
