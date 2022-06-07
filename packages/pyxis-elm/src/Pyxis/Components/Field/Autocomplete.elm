module Pyxis.Components.Field.Autocomplete exposing
    ( Model
    , init
    , setOnBlur
    , setOnFocus
    , setOnReset
    , setOnInput
    , setOnSelect
    , Config
    , config
    , withAdditionalContent
    , withDisabled
    , withHint
    , withIsSubmitted
    , withLabel
    , withNoResultsFoundMessage
    , withPlaceholder
    , withStrategy
    , withId
    , Size
    , small
    , medium
    , withSize
    , withAddonAction
    , withAddonHeader
    , withAddonSuggestion
    , Msg
    , setDropdownClosed
    , setOptions
    , update
    , validate
    , getValue
    , getFilter
    , render
    )

{-|


# Autocomplete

@docs Model
@docs init
@docs setOnBlur
@docs setOnFocus
@docs setOnReset
@docs setOnInput
@docs setOnSelect


## Configuration

@docs Config
@docs config


## Generics

@docs withAdditionalContent
@docs withDisabled
@docs withHint
@docs withIsSubmitted
@docs withLabel

@docs withNoResultsFoundMessage
@docs withPlaceholder
@docs withStrategy
@docs withId


## Size

@docs Size
@docs small
@docs medium
@docs withSize


## Suggestions Addon

@docs withAddonAction
@docs withAddonHeader
@docs withAddonSuggestion


## Update

@docs Msg
@docs setDropdownClosed
@docs setOptions
@docs update
@docs validate


## Readers

@docs getValue
@docs getFilter


## Rendering

@docs render

-}

import Array
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Maybe.Extra
import PrimaFunction
import PrimaUpdate
import Pyxis.Commons.Attributes as CommonsAttributes
import Pyxis.Commons.Commands as Commands
import Pyxis.Commons.Events.KeyDown as KeyDown
import Pyxis.Commons.Render as CommonsRender
import Pyxis.Components.Field.Error as Error
import Pyxis.Components.Field.Error.Strategy as Strategy exposing (Strategy)
import Pyxis.Components.Field.Error.Strategy.Internal as StrategyInternal
import Pyxis.Components.Field.Hint as Hint
import Pyxis.Components.Field.Label as Label
import Pyxis.Components.Field.Status as Status
import Pyxis.Components.Form.Dropdown as FormDropdown
import Pyxis.Components.Form.FormItem as FormItem
import Pyxis.Components.Icon as Icon
import Pyxis.Components.IconSet as IconSet
import RemoteData exposing (RemoteData)
import Result.Extra


{-| Represents the Autocomplete state.
-}
type Model ctx value msg
    = Model
        { activeOption : Maybe (Option value)
        , isDropdownOpen : Bool
        , fieldStatus : Status.Status
        , filter : String
        , isFiltering : Bool
        , optionsFilter : String -> value -> Bool
        , values : RemoteData () (List value)
        , validation : ctx -> Maybe value -> Result String value
        , value : Maybe value
        , valueToString : value -> String
        , onBlur : Maybe msg
        , onFocus : Maybe msg
        , onInput : Maybe msg
        , onReset : Maybe msg
        , onSelect : Maybe msg
        }


{-| Initializes the Autocomplete state.
-}
init :
    Maybe value
    -> (value -> String)
    -> (String -> value -> Bool)
    -> (ctx -> Maybe value -> Result String value)
    -> Model ctx value msg
init value valueToString optionsFilter validation =
    Model
        { activeOption = Nothing
        , isDropdownOpen = False
        , fieldStatus = Status.Untouched
        , filter = ""
        , isFiltering = False
        , optionsFilter = optionsFilter
        , values = RemoteData.NotAsked
        , validation = validation
        , value = value
        , valueToString = valueToString
        , onBlur = Nothing
        , onFocus = Nothing
        , onInput = Nothing
        , onReset = Nothing
        , onSelect = Nothing
        }


type alias Option value =
    { id : String
    , value : value
    , index : Int
    }


{-| Allow to updates the options list.
-}
setOptions : RemoteData err (List value) -> Model ctx value msg -> Model ctx value msg
setOptions optionsRemoteData (Model modelData) =
    Model { modelData | values = RemoteData.mapError (always ()) optionsRemoteData, isDropdownOpen = True }


{-| Represents the Autocomplete message.
-}
type Msg value
    = OnFocus
    | OnInput String
    | OnReset
    | OnSelect value
    | OnKeyDown KeyDown.Event


{-| Updates the Autocomplete.
-}
update : Msg value -> Model ctx value msg -> ( Model ctx value msg, Cmd msg )
update msg ((Model modelData) as model) =
    case msg of
        OnFocus ->
            Model { modelData | isDropdownOpen = True }
                |> mapFieldStatus Status.onFocus
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onFocus
                    ]

        OnInput value ->
            Model { modelData | filter = value, isFiltering = True }
                |> mapFieldStatus Status.onInput
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onInput
                    ]

        OnReset ->
            modelData.validation
                |> init Nothing modelData.valueToString modelData.optionsFilter
                |> mapFieldStatus Status.onInput
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onReset
                    ]

        OnSelect value ->
            model
                |> updateSelectedValue value
                |> setDropdownClosed
                |> mapFieldStatus Status.onInput
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onSelect
                    ]

        OnKeyDown event ->
            model
                |> updateOnKeyEvent event
                |> PrimaUpdate.withoutCmds


updateOnKeyEvent : KeyDown.Event -> Model ctx value msg -> Model ctx value msg
updateOnKeyEvent event ((Model modelData) as model) =
    if KeyDown.isArrowDown event then
        updateActiveOption 1 model

    else if KeyDown.isArrowUp event then
        updateActiveOption -1 model

    else if KeyDown.isEsc event then
        setDropdownClosed model

    else if KeyDown.isEnter event then
        modelData.activeOption
            |> Maybe.map (.value >> PrimaFunction.flip updateSelectedValue model)
            |> Maybe.withDefault model
            |> setDropdownClosed

    else
        model


{-| Sets an OnBlur side effect.
-}
setOnBlur : msg -> Model ctx value msg -> Model ctx value msg
setOnBlur msg (Model configuration) =
    Model { configuration | onBlur = Just msg }


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


{-| Update the Autocomplete Model closing the dropdown
-}
setDropdownClosed : Model ctx value msg -> Model ctx value msg
setDropdownClosed (Model modelData) =
    Model { modelData | isFiltering = False, isDropdownOpen = False, activeOption = Nothing }


{-| Internal.
-}
updateSelectedValue : value -> Model ctx value msg -> Model ctx value msg
updateSelectedValue value (Model modelData) =
    Model { modelData | value = Just value }


updateActiveOption : Int -> Model ctx value msg -> Model ctx value msg
updateActiveOption moveByPositions ((Model modelData) as model) =
    let
        newActiveOptionIndex : Int
        newActiveOptionIndex =
            modelData.activeOption
                |> Maybe.map .index
                |> Maybe.withDefault -1
                |> (+) moveByPositions
    in
    Model
        { modelData
            | activeOption =
                if newActiveOptionIndex < 0 then
                    Nothing

                else if newActiveOptionIndex >= getValuesLength model then
                    getOptions model
                        |> Array.fromList
                        |> Array.get 0

                else
                    getOptions model
                        |> Array.fromList
                        |> Array.get newActiveOptionIndex
        }


getValuesLength : Model ctx value msg -> Int
getValuesLength (Model modelData) =
    modelData.values
        |> RemoteData.withDefault []
        |> List.filter (modelData.optionsFilter modelData.filter)
        |> List.length


{-| Return the input value
-}
getValue : Model ctx value msg -> Maybe value
getValue (Model { value }) =
    value


{-| Return the input value
-}
getFilter : Model ctx value msg -> String
getFilter (Model { filter }) =
    filter


{-| Returns the validated value by running the function you gave to the init.
-}
validate : ctx -> Model ctx value msg -> Result String value
validate ctx (Model { validation, value }) =
    validation ctx value


{-| Internal.
-}
mapFieldStatus : (Status.Status -> Status.Status) -> Model ctx value msg -> Model ctx value msg
mapFieldStatus mapper (Model modelData) =
    Model { modelData | fieldStatus = mapper modelData.fieldStatus }


{-| Internal.
-}
getOptions : Model ctx value msg -> List (Option value)
getOptions (Model modelData) =
    modelData.values
        |> RemoteData.toMaybe
        |> Maybe.withDefault []
        |> List.filter (modelData.optionsFilter modelData.filter)
        |> List.indexedMap (\index value -> { id = "id-" ++ modelData.valueToString value, value = value, index = index })


{-| Autocomplete size
-}
type Size
    = Small
    | Medium


{-| Autocomplete size small
-}
small : Size
small =
    Small


{-| Autocomplete size medium
-}
medium : Size
medium =
    Medium


{-| Represents the Autocomplete view configuration.
-}
type Config value msg
    = Config
        { additionalContent : Maybe (Html Never)
        , disabled : Bool
        , addonHeader : Maybe String
        , hint : Maybe Hint.Config
        , id : String
        , isSubmitted : Bool
        , label : Maybe Label.Config
        , name : String
        , noResultsFoundMessage : String
        , addonAction : Maybe (Html msg)
        , addonSuggestion : Maybe FormDropdown.SuggestionData
        , placeholder : String
        , size : Size
        , strategy : Strategy
        }


{-| Creates the Autocomplete view configuration.
-}
config : String -> Config value msg
config name =
    Config
        { additionalContent = Nothing
        , disabled = False
        , addonHeader = Nothing
        , hint = Nothing
        , id = "id-" ++ name
        , isSubmitted = False
        , label = Nothing
        , name = name
        , noResultsFoundMessage = "No results found."
        , addonAction = Nothing
        , addonSuggestion = Nothing
        , placeholder = ""
        , strategy = Strategy.onBlur
        , size = Medium
        }


{-| Add an addon which suggest or help the user during search.
Will be prepended to options.
-}
withAddonHeader : String -> Config value msg -> Config value msg
withAddonHeader addonHeader (Config configData) =
    Config { configData | addonHeader = Just addonHeader }


{-| Add an addon with a call to action to be shown when no options are found.
-}
withAddonAction : Html msg -> Config value msg -> Config value msg
withAddonAction addonAction (Config configData) =
    Config { configData | addonAction = Just addonAction }


{-| Add an addon which suggest or help the user during search.
Will be appended to options.
-}
withAddonSuggestion : FormDropdown.SuggestionData -> Config value msg -> Config value msg
withAddonSuggestion addonSuggestion (Config configData) =
    Config { configData | addonSuggestion = Just addonSuggestion }


{-| Append an additional custom html.
-}
withAdditionalContent : Html Never -> Config value msg -> Config value msg
withAdditionalContent additionalContent (Config configuration) =
    Config { configuration | additionalContent = Just additionalContent }


{-| Sets whether the Autocomplete is disabled.
-}
withDisabled : Bool -> Config value msg -> Config value msg
withDisabled disabled (Config configuration) =
    Config { configuration | disabled = disabled }


{-| Sets the Autocomplete hint.
-}
withHint : String -> Config value msg -> Config value msg
withHint hintMessage (Config configuration) =
    Config
        { configuration
            | hint =
                hintMessage
                    |> Hint.config
                    |> Hint.withFieldId configuration.id
                    |> Just
        }


{-| Sets whether the form was submitted.
-}
withIsSubmitted : Bool -> Config value msg -> Config value msg
withIsSubmitted isSubmitted (Config configuration) =
    Config { configuration | isSubmitted = isSubmitted }


{-| Adds a label to the Autocomplete.
-}
withLabel : Label.Config -> Config value msg -> Config value msg
withLabel label (Config configData) =
    Config { configData | label = Just label }


{-| Adds an id to the Autocomplete.
-}
withId : String -> Config value msg -> Config value msg
withId id (Config configData) =
    Config { configData | id = id }


{-| Adds custom message instead of the default "No results found".
-}
withNoResultsFoundMessage : String -> Config value msg -> Config value msg
withNoResultsFoundMessage message (Config configuration) =
    Config { configuration | noResultsFoundMessage = message }


{-| Sets the Autocomplete placeholder.
-}
withPlaceholder : String -> Config value msg -> Config value msg
withPlaceholder placeholder (Config configuration) =
    Config { configuration | placeholder = placeholder }


{-| Sets the Autocomplete size.
-}
withSize : Size -> Config value msg -> Config value msg
withSize size (Config configuration) =
    Config { configuration | size = size }


{-| Sets the validation strategy (when to show the error, if present).
-}
withStrategy : Strategy -> Config value msg -> Config value msg
withStrategy strategy (Config configuration) =
    Config { configuration | strategy = strategy }


getValidationResult : Model ctx value msg -> Config a msg -> ctx -> Result String ()
getValidationResult (Model modelData) (Config configData) ctx =
    StrategyInternal.getValidationResult
        modelData.fieldStatus
        (modelData.validation ctx modelData.value)
        configData.isSubmitted
        configData.strategy


{-| Renders the Autocomplete.
-}
render : (Msg value -> msg) -> ctx -> Model ctx value msg -> Config value msg -> Html msg
render msgMapper ctx ((Model modelData) as model) ((Config configData) as configuration) =
    let
        validationResult : Result String ()
        validationResult =
            getValidationResult model configuration ctx

        dropdown : Maybe (Html msg)
        dropdown =
            renderDropdown msgMapper model configuration
    in
    Html.div
        [ Html.Attributes.classList
            [ ( "form-field", True )
            , ( "form-field--with-opened-dropdown", modelData.isDropdownOpen && Maybe.Extra.isJust dropdown )
            , ( "form-field--error", Result.Extra.isErr validationResult )
            , ( "form-field--disabled", configData.disabled )
            ]
        ]
        [ renderField validationResult msgMapper model configuration
        , CommonsRender.renderMaybe dropdown
        ]
        |> FormItem.config configData
        |> FormItem.withLabel configData.label
        |> FormItem.withAdditionalContent configData.additionalContent
        |> FormItem.render validationResult


{-| Internal
-}
handleSelectKeydown : KeyDown.Event -> ( Msg value, Bool )
handleSelectKeydown key =
    ( OnKeyDown key
    , List.any
        (\check -> check key)
        [ KeyDown.isArrowUp, KeyDown.isArrowDown, KeyDown.isEnter ]
    )


{-| Internal.
-}
renderField : Result String () -> (Msg value -> msg) -> Model ctx value msg -> Config value msg -> Html msg
renderField validationResult msgMapper ((Model modelData) as model) (Config configData) =
    let
        activeOptionId : String
        activeOptionId =
            case modelData.activeOption of
                Just activeOption ->
                    getOptions model
                        |> Array.fromList
                        |> Array.get activeOption.index
                        |> Maybe.map .id
                        |> Maybe.withDefault ""

                Nothing ->
                    ""
    in
    Html.label
        [ Html.Attributes.class "form-field__wrapper" ]
        [ Html.input
            [ Html.Attributes.classList
                [ ( "form-field__autocomplete", True )
                , ( "form-field__autocomplete--small", Small == configData.size )
                , ( "form-field__autocomplete--filled", Maybe.Extra.isJust modelData.value )
                ]
            , KeyDown.onKeyDownPreventDefaultOn handleSelectKeydown
            , Html.Events.onFocus OnFocus
            , Html.Events.onInput OnInput
            , Html.Attributes.id configData.id
            , Html.Attributes.name configData.name
            , CommonsAttributes.ariaAutocomplete "both"
            , CommonsAttributes.renderIf modelData.isDropdownOpen (CommonsAttributes.ariaExpanded "true")
            , CommonsAttributes.role "combobox"
            , CommonsAttributes.ariaOwns (configData.id ++ "-dropdown-list")
            , CommonsAttributes.ariaActiveDescendant activeOptionId
            , Html.Attributes.autocomplete False
            , Html.Attributes.disabled configData.disabled
            , Html.Attributes.placeholder configData.placeholder
            , Html.Attributes.type_ "text"
            , CommonsAttributes.testId configData.id
            , modelData.value
                |> Maybe.map modelData.valueToString
                |> Maybe.withDefault modelData.filter
                |> Html.Attributes.value
                |> CommonsAttributes.renderIf (not modelData.isFiltering)
            , modelData.filter
                |> Html.Attributes.value
                |> CommonsAttributes.renderIf modelData.isFiltering
            , validationResult
                |> Error.fromResult
                |> Maybe.map (always (Error.toId configData.id))
                |> CommonsAttributes.ariaDescribedByErrorOrHint
                    (Maybe.map (always (Hint.toId configData.id)) configData.hint)
            ]
            []
        , renderFieldIconAddon model
        ]
        |> Html.map msgMapper


{-| Internal.
-}
renderFieldIconAddon : Model ctx value msg -> Html (Msg value)
renderFieldIconAddon ((Model modelData) as model) =
    Html.div
        [ Html.Attributes.class "form-field__addon"
        ]
        [ model
            |> getFieldAddonIcon
            |> Icon.withSize Icon.small
            |> Icon.render
            |> CommonsRender.renderIf (Maybe.Extra.isNothing modelData.value)
        , Html.button
            [ Html.Attributes.class "form-field__addon__reset"
            , Html.Events.onClick OnReset
            , CommonsAttributes.ariaLabel "reset"
            ]
            [ model
                |> getFieldAddonIcon
                |> Icon.withSize Icon.small
                |> Icon.render
            ]
            |> CommonsRender.renderIf (Maybe.Extra.isJust modelData.value)
        ]


{-| Internal.
-}
getFieldAddonIcon : Model ctx value msg -> Icon.Config
getFieldAddonIcon (Model modelData) =
    if RemoteData.isLoading modelData.values then
        IconSet.Loader
            |> Icon.config
            |> Icon.withSpinner True

    else if Maybe.Extra.isJust modelData.value then
        Icon.config IconSet.Close

    else
        Icon.config IconSet.Search


{-| Internal.
-}
renderDropdown : (Msg value -> msg) -> Model ctx value msg -> Config value msg -> Maybe (Html msg)
renderDropdown msgMapper ((Model modelData) as model) (Config configData) =
    let
        renderedOptions : List (Html msg)
        renderedOptions =
            model
                |> getOptions
                |> List.indexedMap (renderOptionsItem msgMapper model)

        noAvailableOptions : Bool
        noAvailableOptions =
            List.length (getOptions model) == 0 && RemoteData.isSuccess modelData.values
    in
    if String.isEmpty modelData.filter && List.isEmpty renderedOptions then
        configData.addonSuggestion
            |> Maybe.map FormDropdown.suggestion
            |> Maybe.map (FormDropdown.render configData.id (mapDropdownSize configData.size))

    else if Status.hasFocus modelData.fieldStatus then
        FormDropdown.render
            configData.id
            (mapDropdownSize configData.size)
            (if noAvailableOptions then
                FormDropdown.noResult
                    { label = configData.noResultsFoundMessage
                    , action = configData.addonAction
                    }

             else
                case
                    ( configData.addonHeader
                    , configData.addonSuggestion
                    )
                of
                    ( Just headerLabel, _ ) ->
                        FormDropdown.headerAndOptions
                            { header = Html.text headerLabel
                            , options = renderedOptions
                            }

                    ( Nothing, Just suggestionConfig ) ->
                        if not (RemoteData.isSuccess modelData.values) && String.isEmpty modelData.filter then
                            FormDropdown.suggestion suggestionConfig

                        else
                            FormDropdown.options renderedOptions

                    ( Nothing, Nothing ) ->
                        FormDropdown.options renderedOptions
            )
            |> Just

    else
        Nothing


{-| Internal.
-}
renderOptionsItem : (Msg value -> msg) -> Model ctx value msg -> Int -> Option value -> Html msg
renderOptionsItem msgMapper (Model modelData) index { id, value } =
    let
        isActive : Bool
        isActive =
            modelData.activeOption
                |> Maybe.map (.index >> (==) index)
                |> Maybe.withDefault False
    in
    Html.div
        [ Html.Attributes.class "form-dropdown__item"
        , Html.Attributes.classList
            [ ( "form-dropdown__item--active", modelData.value == Just value )
            , ( "form-dropdown__item--hover", isActive )
            ]
        , Html.Attributes.id id
        , CommonsAttributes.role "option"
        , value
            |> OnSelect
            |> msgMapper
            |> Html.Events.onClick
        ]
        [ value
            |> modelData.valueToString
            |> String.trim
            |> renderOptionText modelData.filter
            |> Html.span []
        ]


{-| Internal.
-}
renderOptionText : String -> String -> List (Html msg)
renderOptionText filter label =
    let
        matchStartIndex : Int
        matchStartIndex =
            label
                |> String.toLower
                |> String.indexes (String.toLower filter)
                |> List.head
                |> Maybe.withDefault 0

        matchEndIndex : Int
        matchEndIndex =
            matchStartIndex + String.length filter

        labelStart : String
        labelStart =
            String.slice 0 matchStartIndex label

        labelCenter : String
        labelCenter =
            String.slice matchStartIndex matchEndIndex label

        labelEnd : String
        labelEnd =
            String.slice matchEndIndex (String.length label) label
    in
    [ Html.strong [ Html.Attributes.class "text-m-bold" ] [ Html.text labelStart ]
    , Html.text labelCenter
    , Html.strong [ Html.Attributes.class "text-m-bold" ] [ Html.text labelEnd ]
    ]


mapDropdownSize : Size -> FormDropdown.Size
mapDropdownSize size =
    case size of
        Small ->
            FormDropdown.small

        Medium ->
            FormDropdown.medium
