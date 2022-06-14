module Pyxis.Components.Field.Select exposing
    ( Model
    , init
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
    , withId
    , withIsSubmitted
    , withLabel
    , withPlaceholder
    , withStrategy
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


# Select component

@docs Model
@docs init


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
@docs withId
@docs withIsSubmitted
@docs withLabel
@docs withPlaceholder
@docs withStrategy


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

import Browser.Dom
import Html exposing (Html)
import Html.Attributes
import Html.Events
import PrimaUpdate
import Process
import Pyxis.Commons.Attributes as CommonsAttributes
import Pyxis.Commons.Events as CommonsEvents
import Pyxis.Commons.Events.KeyDown as KeyDown
import Pyxis.Commons.List as CommonsList
import Pyxis.Commons.Render as CommonsRender
import Pyxis.Components.Field.Error as Error
import Pyxis.Components.Field.Error.Strategy as Strategy exposing (Strategy)
import Pyxis.Components.Field.Error.Strategy.Internal as StrategyInternal
import Pyxis.Components.Field.Hint as Hint
import Pyxis.Components.Field.Label as Label
import Pyxis.Components.Field.Status as FieldStatus
import Pyxis.Components.Form.FormItem as FormItem
import Pyxis.Components.Icon as Icon
import Pyxis.Components.IconSet as IconSet
import Result.Extra
import Task exposing (Task)


{-| A type representing the internal component `Msg`
-}
type Msg
    = Selected String
    | Blurred String -- The id of the select
    | ClickedLabel String (Maybe CommonsEvents.PointerType)
    | HoveredOption String
    | FocusedItem (Result Browser.Dom.Error ())
    | FocusedSelect
    | SelectKeyDown { id : String, options : List Option } KeyDown.Event
    | DropdownWrapperItemKeydown
        { id : String
        , previous : ( Int, Option )
        , next : ( Int, Option )
        }
        KeyDown.Event
    | DropdownItemMouseDown
    | Noop


{-| Internal
-}
type DropDownState
    = Open (Maybe String)
    | Closed


{-| Internal.
-}
type alias ModelData ctx parsedValue =
    { isBlurringInternally : Bool
    , dropDownState : DropDownState
    , validation : ctx -> Maybe String -> Result String parsedValue
    , value : Maybe String
    , fieldStatus : FieldStatus.Status
    }


{-| A type representing the select field internal state
-}
type Model ctx parsedValue
    = Model (ModelData ctx parsedValue)


{-| Initialize the select internal state. This belongs to your app's `Model`.
Takes a validation function as argument.
-}
init : Maybe String -> (ctx -> Maybe String -> Result String parsedValue) -> Model ctx parsedValue
init initialValue validation =
    Model
        { dropDownState = Closed
        , validation = validation
        , value = initialValue
        , isBlurringInternally = False
        , fieldStatus = FieldStatus.Untouched
        }


{-| Returns the current native value of the Select
-}
getValue : Model ctx parsedValue -> String
getValue (Model { value }) =
    Maybe.withDefault "" value


{-| Returns the validated value of the select
-}
validate : ctx -> Model ctx parsedValue -> Result String parsedValue
validate ctx (Model { value, validation }) =
    validation ctx value


{-| Internal.
-}
focusSelect : String -> Cmd Msg
focusSelect =
    Browser.Dom.focus >> Task.attempt (always FocusedSelect)


{-| Update the internal state of the Select component
-}
update : Msg -> Model ctx parsedValue -> ( Model ctx parsedValue, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            model
                |> PrimaUpdate.withoutCmds

        DropdownItemMouseDown ->
            model
                |> setIsBlurringInternally True
                |> PrimaUpdate.withoutCmds

        FocusedItem _ ->
            model
                |> setIsBlurringInternally False
                |> PrimaUpdate.withoutCmds

        ClickedLabel id pointerEvent ->
            setClickedLabel id pointerEvent model

        Selected value ->
            model
                |> setValue value
                |> setIsOpen False
                |> setIsBlurringInternally False
                |> mapFieldStatus FieldStatus.onInput
                |> PrimaUpdate.withoutCmds

        Blurred id ->
            model
                |> mapFieldStatus FieldStatus.onBlur
                |> setIsBlurred id

        HoveredOption optionValue ->
            model
                |> setKeyboardHoveredValue optionValue
                |> PrimaUpdate.withoutCmds

        DropdownWrapperItemKeydown viewData keyCode ->
            setDropdownWrapperItemKeydown viewData keyCode model

        SelectKeyDown configData keyCode ->
            setSelectKeydown configData keyCode model

        FocusedSelect ->
            model
                |> mapFieldStatus FieldStatus.onFocus
                |> PrimaUpdate.withoutCmds


{-| Update the field value.
-}
updateValue : String -> Model ctx parsedValue -> ( Model ctx parsedValue, Cmd Msg )
updateValue value =
    update (Selected value)


{-| Internal.
-}
setClickedLabel : String -> Maybe CommonsEvents.PointerType -> Model ctx b -> PrimaUpdate.PrimaUpdate (Model ctx b) Msg
setClickedLabel id pointerType ((Model { dropDownState }) as model) =
    case dropDownState of
        Open _ ->
            model
                |> setIsOpen False
                |> PrimaUpdate.withoutCmds

        Closed ->
            model
                |> setClickedClosedLabel pointerType
                |> PrimaUpdate.withCmds [ focusSelect id ]


{-| Internal.
-}
setClickedClosedLabel : Maybe CommonsEvents.PointerType -> Model ctx parsedValue -> Model ctx parsedValue
setClickedClosedLabel pointerType ((Model modelData) as model) =
    case ( Maybe.withDefault CommonsEvents.Mouse pointerType, modelData.dropDownState ) of
        ( CommonsEvents.Mouse, Closed ) ->
            setIsOpen True model

        _ ->
            model


{-| Internal.
-}
setIsBlurred : String -> Model ctx parsedValue -> PrimaUpdate.PrimaUpdate (Model ctx parsedValue) Msg
setIsBlurred id ((Model modelData) as model) =
    case ( modelData.isBlurringInternally, modelData.dropDownState ) of
        ( False, Open _ ) ->
            model
                |> setIsOpen False
                |> PrimaUpdate.withCmd (focusSelect id)

        _ ->
            model
                |> setIsBlurringInternally False
                |> PrimaUpdate.withoutCmds


{-| Internal.
-}
setDropdownWrapperItemKeydown :
    { id : String
    , previous : ( Int, Option )
    , next : ( Int, Option )
    }
    -> KeyDown.Event
    -> Model ctx b
    -> ( Model ctx b, Cmd Msg )
setDropdownWrapperItemKeydown { id, next, previous } keyCode ((Model modelData) as model) =
    case modelData.dropDownState of
        Open open ->
            if KeyDown.isArrowDown keyCode then
                handleVerticalArrowDropdownItem id next model

            else if KeyDown.isArrowUp keyCode then
                handleVerticalArrowDropdownItem id previous model

            else if KeyDown.isSpace keyCode || KeyDown.isEnter keyCode then
                model
                    |> setIsOpen False
                    |> setSelectedValueWhenJust open
                    |> PrimaUpdate.withCmd (focusSelect id)

            else if KeyDown.isEsc keyCode then
                model
                    |> setIsOpen False
                    |> PrimaUpdate.withCmd (focusSelect id)

            else
                model
                    |> PrimaUpdate.withoutCmds

        _ ->
            model
                |> PrimaUpdate.withoutCmds


{-| Internal.
-}
setSelectKeydown : { a | id : String, options : List Option } -> KeyDown.Event -> Model ctx parsedValue -> PrimaUpdate.PrimaUpdate (Model ctx parsedValue) Msg
setSelectKeydown configData keyCode ((Model modelData) as model) =
    case modelData.dropDownState of
        Open open ->
            if KeyDown.isSpace keyCode || KeyDown.isEnter keyCode then
                model
                    |> setIsOpen False
                    |> setSelectedValueWhenJust open
                    |> PrimaUpdate.withCmd (focusSelect configData.id)

            else if KeyDown.isArrowDown keyCode || KeyDown.isArrowUp keyCode then
                hoverFirstDropdownItem
                    { delayed = False
                    , id = configData.id
                    , options = configData.options
                    }
                    model

            else if KeyDown.isEsc keyCode then
                model
                    |> setIsOpen False
                    |> PrimaUpdate.withoutCmds

            else
                model
                    |> PrimaUpdate.withoutCmds

        Closed ->
            if KeyDown.isSpace keyCode || KeyDown.isArrowDown keyCode || KeyDown.isArrowUp keyCode then
                hoverFirstDropdownItem
                    { options = configData.options
                    , id = configData.id
                    , delayed = True
                    }
                    model

            else
                model
                    |> PrimaUpdate.withoutCmds


{-| Internal.
-}
getHoveredValueAndIndex : List Option -> String -> Maybe ( Int, String )
getHoveredValueAndIndex options target =
    options
        |> List.indexedMap Tuple.pair
        |> CommonsList.find (\( _, Option { value } ) -> value == target)
        |> Maybe.map (\( index, Option { value } ) -> ( index, value ))


{-| Internal.
-}
getSelectedValueAndIndex : List Option -> Maybe String -> Maybe ( Int, String )
getSelectedValueAndIndex options =
    Maybe.andThen (getHoveredValueAndIndex options)


{-| Internal.
-}
hoverFirstDropdownItem :
    { options : List Option, id : String, delayed : Bool }
    -> Model ctx value
    -> PrimaUpdate.PrimaUpdate (Model ctx value) Msg
hoverFirstDropdownItem { options, id, delayed } ((Model modelData) as model) =
    case ( getSelectedValueAndIndex options modelData.value, options ) of
        ( Just ( index, value ), _ ) ->
            model
                |> setIsOpen True
                |> hoverDropdownItem
                    { selectId = id
                    , index = index
                    , value = value
                    , delayed = delayed
                    }

        ( _, [] ) ->
            model
                |> setIsOpen True
                |> PrimaUpdate.withoutCmds

        ( _, (Option { value }) :: _ ) ->
            model
                |> setIsOpen True
                |> hoverDropdownItem
                    { selectId = id
                    , index = 0
                    , value = value
                    , delayed = delayed
                    }



-- View config


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


{-| Internal.
-}
type alias ConfigData =
    { additionalContent : Maybe (Html Never)
    , classList : List ( String, Bool )
    , disabled : Bool
    , hint : Maybe Hint.Config
    , id : String
    , isMobile : Bool
    , name : String
    , options : List Option
    , placeholder : Maybe String
    , size : Size
    , label : Maybe Label.Config
    , strategy : Strategy
    , isSubmitted : Bool
    }


{-| A type representing the select rendering options.
This should not belong to the app `Model`
-}
type Config msg
    = Config ConfigData


{-| Create a [`Select.Config`](Select#Config) with the default options applied.
You can apply different options with the `withX` modifiers
-}
config : Bool -> String -> Config msg
config isMobile name =
    Config
        { additionalContent = Nothing
        , classList = []
        , disabled = False
        , hint = Nothing
        , id = "id-" ++ name
        , isMobile = isMobile
        , name = name
        , options = []
        , placeholder = Nothing
        , size = Medium
        , label = Nothing
        , strategy = Strategy.onBlur
        , isSubmitted = False
        }


{-| A type representing a `<select>` option
-}
type Option
    = Option
        { value : String
        , label : String
        }


{-| Create an Option
-}
option : { value : String, label : String } -> Option
option =
    Option


{-| Sets the validation strategy (when to show the error, if present)
-}
withStrategy : Strategy -> Config msg -> Config msg
withStrategy strategy (Config configuration) =
    Config { configuration | strategy = strategy }


{-| Sets whether the form was submitted
-}
withIsSubmitted : Bool -> Config msg -> Config msg
withIsSubmitted isSubmitted (Config configuration) =
    Config { configuration | isSubmitted = isSubmitted }


{-| Set the select options
-}
withOptions : List Option -> Config msg -> Config msg
withOptions options (Config select) =
    Config { select | options = options }


{-| Set the text visible when no option is selected
Note: this is not a native placeholder attribute
-}
withPlaceholder : String -> Config msg -> Config msg
withPlaceholder placeholder (Config select) =
    Config { select | placeholder = Just placeholder }


{-| Set the disabled attribute
-}
withDisabled : Bool -> Config msg -> Config msg
withDisabled disabled (Config select) =
    Config { select | disabled = disabled }


{-| Adds the hint to the Select.
-}
withHint : String -> Config msg -> Config msg
withHint hintMessage (Config configuration) =
    Config
        { configuration
            | hint =
                Hint.config hintMessage
                    |> Hint.withFieldId configuration.id
                    |> Just
        }


{-| Set the id attribute
-}
withId : String -> Config msg -> Config msg
withId id (Config select) =
    Config { select | id = id }


{-| Set the select size
-}
withSize : Size -> Config msg -> Config msg
withSize size (Config select) =
    Config { select | size = size }


{-| Sets the component label
-}
withLabel : Label.Config -> Config msg -> Config msg
withLabel label (Config select) =
    Config { select | label = Just label }


{-| Set the classes of the <select> element
Note that

                select
                |> Select.withClassList ["a", True]
                |> Select.withClassList ["b", True]

Only has the "b" class

_WARNING_: this function is considered unstable and should be used only as an emergency escape hatch

-}
withClassList : List ( String, Bool ) -> Config msg -> Config msg
withClassList classList (Config select) =
    Config { select | classList = classList }


{-| Append an additional custom html.
-}
withAdditionalContent : Html Never -> Config msg -> Config msg
withAdditionalContent additionalContent (Config configuration) =
    Config { configuration | additionalContent = Just additionalContent }



-- Render


{-| Internal

Returns true if the event should call preventDefault()

-}
shouldKeydownPreventDefault : KeyDown.Event -> Bool
shouldKeydownPreventDefault keydownEvent =
    List.any ((|>) keydownEvent)
        [ KeyDown.isSpace
        , KeyDown.isEnter
        , KeyDown.isArrowUp
        , KeyDown.isArrowDown
        , KeyDown.isEsc
        ]


{-| Internal
-}
handleSelectKeydown : ConfigData -> KeyDown.Event -> ( Msg, Bool )
handleSelectKeydown configData key =
    ( SelectKeyDown { id = configData.id, options = configData.options } key
    , shouldKeydownPreventDefault key && not configData.isMobile
    )


{-| Render the html
-}
render : (Msg -> msg) -> ctx -> Model ctx parsedValue -> Config msg -> Html msg
render tagger ctx ((Model modelData) as model) ((Config configData) as configuration) =
    let
        shownValidation : Result String ()
        shownValidation =
            StrategyInternal.getShownValidation
                modelData.fieldStatus
                (modelData.validation ctx modelData.value)
                configData.isSubmitted
                configData.strategy

        customizedLabel : Maybe Label.Config
        customizedLabel =
            Maybe.map (configData.size |> mapLabelSize |> Label.withSize) configData.label
    in
    renderField shownValidation model configuration
        |> FormItem.config configData
        |> FormItem.withLabel customizedLabel
        |> FormItem.render shownValidation
        |> Html.map tagger


renderField : Result String () -> Model ctx value -> Config msg -> Html Msg
renderField shownValidation ((Model modelData) as model) (Config configData) =
    Html.div
        [ Html.Attributes.classList
            [ ( "form-field", True )
            , ( "form-field--with-select-dropdown", not configData.isMobile )
            , ( "form-field--with-opened-dropdown", not configData.isMobile && isDropDownOpen model )
            , ( "form-field--error", Result.Extra.error shownValidation /= Nothing )
            , ( "form-field--disabled", configData.disabled )
            ]
        ]
        [ Html.label
            [ Html.Attributes.class "form-field__wrapper"
            , ClickedLabel configData.id
                |> CommonsEvents.onClickPreventDefault
                |> CommonsAttributes.renderIf (not configData.isMobile && not configData.disabled)
            ]
            [ Html.select
                [ Html.Attributes.classList
                    [ ( "form-field__select", True )
                    , ( "form-field__select--filled", modelData.value /= Nothing )
                    , ( "form-field__select--small", Small == configData.size )
                    ]
                , Html.Attributes.id configData.id
                , CommonsAttributes.testId configData.id
                , Html.Attributes.classList configData.classList
                , Html.Attributes.disabled configData.disabled
                , shownValidation
                    |> Error.fromResult
                    |> Maybe.map (always (Error.toId configData.id))
                    |> CommonsAttributes.ariaDescribedByErrorOrHint
                        (Maybe.map (always (Hint.toId configData.id)) configData.hint)

                -- Conditional attributes
                , CommonsAttributes.maybe Html.Attributes.value modelData.value
                , Html.Attributes.name configData.name

                -- Events
                , Html.Events.onInput Selected
                , Html.Events.onBlur (Blurred configData.id)
                , KeyDown.onKeyDownPreventDefaultOn (handleSelectKeydown configData)
                , CommonsEvents.alwaysStopPropagationOn "click" Noop
                ]
                (Html.option
                    [ Html.Attributes.hidden True
                    , Html.Attributes.disabled True
                    , Html.Attributes.selected True
                    ]
                    [ configData.placeholder
                        |> Maybe.map Html.text
                        |> CommonsRender.renderMaybe
                    ]
                    :: List.map (renderNativeOption modelData.value) configData.options
                )
            , Html.div
                [ Html.Attributes.class "form-field__addon" ]
                [ IconSet.ChevronDown
                    |> Icon.config
                    |> Icon.render
                ]
            ]
        , renderDropdownWrapper model (Config configData)
        ]


{-| Internal.
-}
renderDropdownWrapper : Model ctx parsedValue -> Config msg -> Html Msg
renderDropdownWrapper (Model model) (Config select) =
    -- Currently not using renderIf for performance reasons
    if select.isMobile then
        Html.text ""

    else
        Html.div
            [ Html.Attributes.classList
                [ ( "form-dropdown-wrapper", True )
                , ( "form-dropdown-wrapper--small", Small == select.size )
                ]
            ]
            [ Html.div [ Html.Attributes.class "form-dropdown" ]
                (select.options
                    |> List.indexedMap Tuple.pair
                    |> CommonsList.withPreviousAndNext
                    |> List.map (renderDropdownItem model (Config select))
                )
            ]


{-| Internal.
-}
getHoveredValue : DropDownState -> Maybe String
getHoveredValue dropDownState =
    case dropDownState of
        Open hoveredValue ->
            hoveredValue

        _ ->
            Nothing


{-| Internal.
-}
getDropDownItemId : String -> Int -> String
getDropDownItemId id index =
    id ++ "-dropdown-item-" ++ String.fromInt index


{-| Internal.
-}
renderDropdownItem :
    ModelData ctx parsed
    -> Config msg
    -> ( ( Int, Option ), ( Int, Option ), ( Int, Option ) )
    -> Html Msg
renderDropdownItem { dropDownState, value } (Config configData) ( previous, ( index, Option option_ ), next ) =
    let
        handleKeydown : KeyDown.Event -> ( Msg, Bool )
        handleKeydown keydownEvent =
            ( DropdownWrapperItemKeydown
                { id = configData.id
                , previous = previous
                , next = next
                }
                keydownEvent
            , KeyDown.isTab keydownEvent || shouldKeydownPreventDefault keydownEvent
            )

        isItemSelected : Bool
        isItemSelected =
            getHoveredValue dropDownState == Just option_.value
    in
    Html.div
        [ Html.Attributes.classList
            [ ( "form-dropdown__item", True )
            , ( "form-dropdown__item--hover", isItemSelected )
            , ( "form-dropdown__item--active", value == Just option_.value )
            ]
        , Html.Events.onBlur (Blurred configData.id)
        , Html.Attributes.attribute "role" "button"
        , Html.Attributes.tabindex -1
        , Html.Attributes.id (getDropDownItemId configData.id index)
        , Html.Events.onClick (Selected option_.value)
        , Html.Events.onMouseDown DropdownItemMouseDown
        , Html.Events.onMouseOver (HoveredOption option_.value)
        , CommonsAttributes.renderIf isItemSelected (KeyDown.onKeyDownPreventDefaultOn handleKeydown)
        ]
        [ Html.text option_.label
        ]


{-| Internal.
-}
renderNativeOption : Maybe String -> Option -> Html msg
renderNativeOption selectedValue (Option { value, label }) =
    Html.option
        [ Html.Attributes.value value
        , Html.Attributes.selected (Just value == selectedValue)
        ]
        [ Html.text label ]


{-| Internal

The delay is needed for the focus to work, when the element to focus is not visible yet

-}
hoverDropdownItem :
    { selectId : String
    , value : String
    , index : Int
    , delayed : Bool
    }
    -> Model ctx value
    -> ( Model ctx value, Cmd Msg )
hoverDropdownItem { selectId, value, index, delayed } model =
    model
        |> setIsBlurringInternally True
        |> setHoveredValue (Just value)
        |> PrimaUpdate.withCmd (focusDropDownItem delayed selectId index)


{-| Internal
-}
handleVerticalArrowDropdownItem : String -> ( Int, Option ) -> Model ctx value -> ( Model ctx value, Cmd Msg )
handleVerticalArrowDropdownItem id ( index, Option { value } ) =
    hoverDropdownItem
        { index = index
        , selectId = id
        , value = value
        , delayed = False
        }



-- Getters boilerplate


{-| Internal
-}
animationDuration : Float
animationDuration =
    -- A future improvement might be to use transitionEnd event
    75


{-| Internal
-}
maybeDelay : Bool -> Task x ()
maybeDelay delay =
    if delay then
        Process.sleep animationDuration

    else
        Task.succeed ()


{-| Internal
-}
focusDropDownItem : Bool -> String -> Int -> Cmd Msg
focusDropDownItem delay value index =
    delay
        |> maybeDelay
        |> Task.andThen (\() -> Browser.Dom.focus (getDropDownItemId value index))
        |> Task.attempt FocusedItem


{-| Internal
-}
setKeyboardHoveredValue : String -> Model ctx parsedValue -> Model ctx parsedValue
setKeyboardHoveredValue value (Model model) =
    case model.dropDownState of
        Closed ->
            Model model

        Open _ ->
            Model { model | dropDownState = Open (Just value) }


{-| Internal
-}
isDropDownOpen : Model ctx parsedValue -> Bool
isDropDownOpen (Model model) =
    case model.dropDownState of
        Open _ ->
            True

        Closed ->
            False


{-| Internal.
-}
setIsOpen : Bool -> Model ctx parsedValue -> Model ctx parsedValue
setIsOpen condition (Model model) =
    if condition then
        Model { model | dropDownState = Open model.value }

    else
        Model { model | dropDownState = Closed }


{-| Internal.
-}
setIsBlurringInternally : Bool -> Model ctx parsedValue -> Model ctx parsedValue
setIsBlurringInternally isBlurringInternally (Model model) =
    Model { model | isBlurringInternally = isBlurringInternally }


{-| Internal.
-}
setHoveredValue : Maybe String -> Model ctx parsedValue -> Model ctx parsedValue
setHoveredValue hoveredValue (Model model) =
    Model { model | dropDownState = Open hoveredValue }


{-| Internal.
Acts as identity when maybeValue == Nothing
-}
setSelectedValueWhenJust : Maybe String -> Model ctx parsedValue -> Model ctx parsedValue
setSelectedValueWhenJust =
    Maybe.map setValue >> Maybe.withDefault identity


{-| Internal.
-}
setValue : String -> Model ctx parsedValue -> Model ctx parsedValue
setValue value (Model model) =
    Model { model | value = Just value }


{-| Internal.
-}
mapFieldStatus : (FieldStatus.Status -> FieldStatus.Status) -> Model ctx parsedValue -> Model ctx parsedValue
mapFieldStatus f (Model model) =
    Model { model | fieldStatus = f model.fieldStatus }


mapLabelSize : Size -> Label.Size
mapLabelSize size =
    case size of
        Small ->
            Label.small

        Medium ->
            Label.medium
