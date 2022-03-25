module Components.Field.Select exposing
    ( Model
    , init
    , Config
    , config
    , withSize
    , withAdditionalContent
    , withClassList
    , withDisabled
    , withHint
    , withIsSubmitted
    , withLabel
    , withName
    , withPlaceholder
    , withStrategy
    , Msg
    , update
    , validate
    , getValue
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

@docs withSize


## Generics

@docs withAdditionalContent
@docs withClassList
@docs withDisabled
@docs withHint
@docs withIsSubmitted
@docs withLabel
@docs withName
@docs withPlaceholder
@docs withStrategy


## Update

@docs Msg
@docs update
@docs validate


## Readers

@docs getValue


## Options

@docs Option
@docs option
@docs withOptions


## Rendering

@docs render

-}

import Browser.Dom
import Commons.Attributes
import Commons.Events
import Commons.Events.KeyDown as KeyDown
import Commons.List
import Commons.Properties.Size as Size exposing (Size)
import Commons.Render
import Components.Field.Error as Error
import Components.Field.Error.Strategy as Strategy exposing (Strategy)
import Components.Field.Error.Strategy.Internal as StrategyInternal
import Components.Field.FormItem as FormItem
import Components.Field.Hint as Hint
import Components.Field.Label as Label
import Components.Field.Status as FieldStatus
import Components.Icon as Icon
import Components.IconSet as IconSet
import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events
import PrimaUpdate
import Process
import Result.Extra
import Task exposing (Task)


{-| A type representing the internal component `Msg`
-}
type Msg
    = Selected String
    | Blurred String -- The id of the select
    | ClickedLabel String Commons.Events.PointerEvent
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
    = Open { hoveredValue : Maybe String }
    | Closed


{-| Internal.
-}
type alias ModelData ctx parsed =
    { isBlurringInternally : Bool
    , dropDownState : DropDownState
    , validation : ctx -> Maybe String -> Result String parsed
    , value : Maybe String
    , fieldStatus : FieldStatus.Status
    }


{-| A type representing the select field internal state
-}
type Model ctx parsed
    = Model (ModelData ctx parsed)


{-| Initialize the select internal state. This belongs to your app's `Model`
Takes a validation function as argument
-}
init : Maybe String -> (ctx -> Maybe String -> Result String parsed) -> Model ctx parsed
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
getValue : Model ctx parsed -> String
getValue (Model { value }) =
    Maybe.withDefault "" value


{-| Returns the validated value of the select
-}
validate : ctx -> Model ctx parsed -> Result String parsed
validate ctx (Model { value, validation }) =
    validation ctx value


{-| Internal.
-}
focusSelect : String -> Cmd Msg
focusSelect =
    Browser.Dom.focus >> Task.attempt (always FocusedSelect)


{-| Update the internal state of the Select component
-}
update : Msg -> Model ctx parsed -> ( Model ctx parsed, Cmd Msg )
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
                |> setSelectedValue value
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


{-| Internal.
-}
setClickedLabel : String -> Commons.Events.PointerEvent -> Model ctx b -> PrimaUpdate.PrimaUpdate (Model ctx b) Msg
setClickedLabel id pointerEvent ((Model { dropDownState }) as model) =
    case dropDownState of
        Open _ ->
            model
                |> setIsOpen False
                |> PrimaUpdate.withoutCmds

        Closed ->
            model
                |> setClickedClosedLabel pointerEvent.pointerType
                |> PrimaUpdate.withCmds [ focusSelect id ]


{-| Internal.
-}
setClickedClosedLabel : Maybe Commons.Events.PointerType -> Model ctx parsed -> Model ctx parsed
setClickedClosedLabel pointerType ((Model modelData) as model) =
    case ( Maybe.withDefault Commons.Events.Mouse pointerType, modelData.dropDownState ) of
        ( Commons.Events.Mouse, Closed ) ->
            setIsOpen True model

        _ ->
            model


{-| Internal.
-}
setIsBlurred : String -> Model ctx parsed -> PrimaUpdate.PrimaUpdate (Model ctx parsed) Msg
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
                    |> setSelectedValueWhenJust open.hoveredValue
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
setSelectKeydown : { a | id : String, options : List Option } -> KeyDown.Event -> Model ctx parsed -> PrimaUpdate.PrimaUpdate (Model ctx parsed) Msg
setSelectKeydown configData keyCode ((Model modelData) as model) =
    case modelData.dropDownState of
        Open open ->
            if KeyDown.isSpace keyCode || KeyDown.isEnter keyCode then
                model
                    |> setIsOpen False
                    |> setSelectedValueWhenJust open.hoveredValue
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
        |> Commons.List.find (\( _, Option { value } ) -> value == target)
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


{-| Internal.
-}
type alias ConfigData =
    { additionalContent : Maybe (Html Never)
    , classList : List ( String, Bool )
    , disabled : Bool
    , hint : Maybe Hint.Config
    , id : String
    , isMobile : Bool
    , name : Maybe String
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
config isMobile id =
    Config
        { additionalContent = Nothing
        , classList = []
        , disabled = False
        , hint = Nothing
        , id = id
        , isMobile = isMobile
        , name = Nothing
        , options = []
        , placeholder = Nothing
        , size = Size.medium
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


{-| Set the name attribute
-}
withName : String -> Config msg -> Config msg
withName name (Config select) =
    Config { select | name = Just name }


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
render : (Msg -> msg) -> ctx -> Model ctx parsed -> Config msg -> Html msg
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
            Maybe.map (Label.withSize configData.size) configData.label
    in
    renderField shownValidation model configuration
        |> FormItem.config configData
        |> FormItem.withLabel customizedLabel
        |> FormItem.render shownValidation
        |> Html.map tagger


renderField : Result String () -> Model ctx value -> Config msg -> Html Msg
renderField shownValidation ((Model modelData) as model) (Config configData) =
    Html.div
        [ Attributes.classList
            [ ( "form-field", True )
            , ( "form-field--with-select-dropdown", not configData.isMobile )
            , ( "form-field--with-opened-dropdown", not configData.isMobile && isDropDownOpen model )
            , ( "form-field--error", Result.Extra.error shownValidation /= Nothing )
            , ( "form-field--disabled", configData.disabled )
            ]
        ]
        [ Html.label
            [ Attributes.class "form-field__wrapper"
            , ClickedLabel configData.id
                |> Commons.Events.onClickPreventDefault
                |> Commons.Attributes.renderIf (not configData.isMobile && not configData.disabled)
            ]
            [ Html.select
                [ Attributes.classList
                    [ ( "form-field__select", True )
                    , ( "form-field__select--filled", modelData.value /= Nothing )
                    , ( "form-field__select--small", Size.isSmall configData.size )
                    ]
                , Attributes.id configData.id
                , Commons.Attributes.testId configData.id
                , Attributes.classList configData.classList
                , Attributes.disabled configData.disabled
                , shownValidation
                    |> Error.fromResult
                    |> Maybe.map (always (Error.toId configData.id))
                    |> Commons.Attributes.ariaDescribedByErrorOrHint
                        (Maybe.map (always (Hint.toId configData.id)) configData.hint)

                -- Conditional attributes
                , Commons.Attributes.maybe Attributes.value modelData.value
                , Commons.Attributes.maybe Attributes.name configData.name

                -- Events
                , Html.Events.onInput Selected
                , Html.Events.onBlur (Blurred configData.id)
                , KeyDown.onKeyDownPreventDefaultOn (handleSelectKeydown configData)
                , Commons.Events.alwaysStopPropagationOn "click" Noop
                ]
                (Html.option
                    [ Attributes.hidden True
                    , Attributes.disabled True
                    , Attributes.selected True
                    ]
                    [ configData.placeholder
                        |> Maybe.map Html.text
                        |> Commons.Render.renderMaybe
                    ]
                    :: List.map renderNativeOption configData.options
                )
            , Html.div [ Attributes.class "form-field__addon" ]
                [ IconSet.ChevronDown
                    |> Icon.create
                    |> Icon.render
                ]
            ]
        , renderDropdownWrapper model (Config configData)
        ]


{-| Internal.
-}
renderDropdownWrapper : Model ctx parsed -> Config msg -> Html Msg
renderDropdownWrapper (Model model) (Config select) =
    -- Currently not using renderIf for performance reasons
    if select.isMobile then
        Html.text ""

    else
        Html.div
            [ Attributes.classList
                [ ( "form-dropdown-wrapper", True )
                , ( "form-dropdown-wrapper--small", Size.isSmall select.size )
                ]
            ]
            [ Html.div [ Attributes.class "form-dropdown" ]
                (select.options
                    |> List.indexedMap Tuple.pair
                    |> Commons.List.withPreviousAndNext
                    |> List.map (renderDropdownItem model (Config select))
                )
            ]


{-| Internal.
-}
getHoveredValue : DropDownState -> Maybe String
getHoveredValue dropDownState =
    case dropDownState of
        Open { hoveredValue } ->
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
        [ Attributes.classList
            [ ( "form-dropdown__item", True )
            , ( "form-dropdown__item--hover", isItemSelected )
            , ( "form-dropdown__item--active", value == Just option_.value )
            ]
        , Html.Events.onBlur (Blurred configData.id)
        , Attributes.attribute "role" "button"
        , Attributes.tabindex -1
        , Attributes.id (getDropDownItemId configData.id index)
        , Html.Events.onClick (Selected option_.value)
        , Html.Events.onMouseDown DropdownItemMouseDown
        , Html.Events.onMouseOver (HoveredOption option_.value)
        , Commons.Attributes.renderIf isItemSelected (KeyDown.onKeyDownPreventDefaultOn handleKeydown)
        ]
        [ Html.text option_.label
        ]


{-| Internal.
-}
renderNativeOption : Option -> Html msg
renderNativeOption (Option { value, label }) =
    Html.option
        [ Attributes.value value
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
setKeyboardHoveredValue : String -> Model ctx parsed -> Model ctx parsed
setKeyboardHoveredValue value (Model model) =
    case model.dropDownState of
        Closed ->
            Model model

        Open _ ->
            Model { model | dropDownState = Open { hoveredValue = Just value } }


{-| Internal
-}
isDropDownOpen : Model ctx parsed -> Bool
isDropDownOpen (Model model) =
    case model.dropDownState of
        Open _ ->
            True

        Closed ->
            False


{-| Internal.
-}
setIsOpen : Bool -> Model ctx parsed -> Model ctx parsed
setIsOpen condition (Model model) =
    if condition then
        Model { model | dropDownState = Open { hoveredValue = model.value } }

    else
        Model { model | dropDownState = Closed }


{-| Internal.
-}
setIsBlurringInternally : Bool -> Model ctx parsed -> Model ctx parsed
setIsBlurringInternally isBlurringInternally (Model model) =
    Model { model | isBlurringInternally = isBlurringInternally }


{-| Internal.
-}
setHoveredValue : Maybe String -> Model ctx parsed -> Model ctx parsed
setHoveredValue hoveredValue (Model model) =
    Model { model | dropDownState = Open { hoveredValue = hoveredValue } }


{-| Internal.
Acts as identity when maybeValue == Nothing
-}
setSelectedValueWhenJust : Maybe String -> Model ctx parsed -> Model ctx parsed
setSelectedValueWhenJust =
    Maybe.map setSelectedValue >> Maybe.withDefault identity


{-| Internal.
-}
setSelectedValue : String -> Model ctx parsed -> Model ctx parsed
setSelectedValue value (Model model) =
    Model { model | value = Just value }


{-| Internal.
-}
mapFieldStatus : (FieldStatus.Status -> FieldStatus.Status) -> Model ctx parsed -> Model ctx parsed
mapFieldStatus f (Model model) =
    Model { model | fieldStatus = f model.fieldStatus }
