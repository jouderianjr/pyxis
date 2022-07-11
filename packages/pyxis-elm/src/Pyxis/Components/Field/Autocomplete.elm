module Pyxis.Components.Field.Autocomplete exposing
    ( Model
    , init
    , resetValue
    , setOnBlur
    , setOnFocus
    , setOnInput
    , setOnReset
    , setOnSelect
    , setValue
    , Config
    , config
    , withAdditionalContent
    , withDisabled
    , withHint
    , withId
    , withLabel
    , withNoResultsFoundMessage
    , withPlaceholder
    , withValidationOnBlur
    , withValidationOnInput
    , withValidationOnSubmit
    , Size
    , small
    , medium
    , withSize
    , withNoResultFoundAction
    , withHeaderText
    , withSuggestion
    , Msg
    , setDropdownClosed
    , setOptions
    , update
    , getValue
    , getFilter
    , render
    )

{-|


# Autocomplete

@docs Model
@docs init
@docs resetValue
@docs setOnBlur
@docs setOnFocus
@docs setOnInput
@docs setOnReset
@docs setOnSelect
@docs setValue


## Configuration

@docs Config
@docs config


## Generics

@docs withAdditionalContent
@docs withDisabled
@docs withHint
@docs withId
@docs withLabel
@docs withNoResultsFoundMessage
@docs withPlaceholder
@docs withValidationOnBlur
@docs withValidationOnInput
@docs withValidationOnSubmit


## Size

@docs Size
@docs small
@docs medium
@docs withSize


## Suggestions Addon

@docs withNoResultFoundAction
@docs withHeaderText
@docs withSuggestion


## Update

@docs Msg
@docs setDropdownClosed
@docs setOptions
@docs update


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
import Pyxis.Commons.Alias as CommonsAlias
import Pyxis.Commons.Attributes as CommonsAttributes
import Pyxis.Commons.Commands as Commands
import Pyxis.Commons.Events.KeyDown as KeyDown
import Pyxis.Commons.Render as CommonsRender
import Pyxis.Components.Field.Error as Error
import Pyxis.Components.Field.FieldStatus as FieldStatus exposing (FieldStatus)
import Pyxis.Components.Field.Hint as Hint
import Pyxis.Components.Field.Label as Label
import Pyxis.Components.Form.Dropdown as FormDropdown
import Pyxis.Components.Form.FormItem as FormItem
import Pyxis.Components.Icon as Icon
import Pyxis.Components.IconSet as IconSet
import RemoteData exposing (RemoteData)


{-| Represents the Autocomplete state.
-}
type Model value msg
    = Model
        { activeOption : Maybe (Option value)
        , isDropdownOpen : Bool
        , fieldStatus : FieldStatus
        , filter : String
        , isFiltering : Bool
        , hasFocus : Bool
        , optionsFilter : String -> value -> Bool
        , values : RemoteData () (List value)
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
    (value -> String)
    -> (String -> value -> Bool)
    -> Model value msg
init valueToString optionsFilter =
    Model
        { activeOption = Nothing
        , isDropdownOpen = False
        , fieldStatus = FieldStatus.init
        , filter = ""
        , isFiltering = False
        , hasFocus = False
        , optionsFilter = optionsFilter
        , values = RemoteData.NotAsked
        , value = Nothing
        , valueToString = valueToString
        , onBlur = Nothing
        , onFocus = Nothing
        , onInput = Nothing
        , onReset = Nothing
        , onSelect = Nothing
        }


type alias Option value =
    { id : CommonsAlias.Id
    , value : value
    , index : Int
    }


{-| Allow to updates the options list.
-}
setOptions : RemoteData err (List value) -> Model value msg -> Model value msg
setOptions optionsRemoteData (Model modelData) =
    Model { modelData | values = RemoteData.mapError (always ()) optionsRemoteData, isDropdownOpen = RemoteData.isSuccess optionsRemoteData }


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
update : Msg value -> Model value msg -> ( Model value msg, Cmd msg )
update msg ((Model modelData) as model) =
    case msg of
        OnFocus ->
            Model { modelData | isDropdownOpen = True }
                |> setHasFocus True
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onFocus
                    ]

        OnInput value ->
            Model { modelData | filter = value, isFiltering = True }
                |> mapFieldStatus (FieldStatus.setIsDirty True)
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onInput
                    ]

        OnReset ->
            Model { modelData | filter = "", isFiltering = False, value = Nothing, activeOption = Nothing }
                |> mapFieldStatus (FieldStatus.setIsDirty False)
                |> mapFieldStatus (FieldStatus.setIsBlurred False)
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onReset
                    ]

        OnSelect value ->
            model
                |> updateSelectedValue value
                |> setDropdownClosed
                |> mapFieldStatus (FieldStatus.setIsDirty True)
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onSelect
                    ]

        OnKeyDown event ->
            model
                |> updateOnKeyEvent event
                |> PrimaUpdate.withCmd
                    (if KeyDown.isEnter event && modelData.activeOption /= Nothing then
                        Commands.dispatchFromMaybe modelData.onSelect

                     else
                        Cmd.none
                    )


updateOnKeyEvent : KeyDown.Event -> Model value msg -> Model value msg
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
setOnBlur : msg -> Model value msg -> Model value msg
setOnBlur msg (Model configuration) =
    Model { configuration | onBlur = Just msg }


{-| Sets an OnFocus side effect.
-}
setOnFocus : msg -> Model value msg -> Model value msg
setOnFocus msg (Model configuration) =
    Model { configuration | onFocus = Just msg }


{-| Sets an OnReset side effect.
-}
setOnReset : msg -> Model value msg -> Model value msg
setOnReset msg (Model configuration) =
    Model { configuration | onReset = Just msg }


{-| Sets an OnInput side effect.
-}
setOnInput : msg -> Model value msg -> Model value msg
setOnInput msg (Model configuration) =
    Model { configuration | onInput = Just msg }


{-| Sets an OnSelect side effect.
-}
setOnSelect : msg -> Model value msg -> Model value msg
setOnSelect msg (Model configuration) =
    Model { configuration | onSelect = Just msg }


{-| Update the Autocomplete Model closing the dropdown
-}
setDropdownClosed : Model value msg -> Model value msg
setDropdownClosed (Model modelData) =
    Model
        { modelData
            | isFiltering = False
            , isDropdownOpen = False
            , activeOption = Nothing
            , hasFocus = False
        }


{-| Internal.
-}
setHasFocus : Bool -> Model value msg -> Model value msg
setHasFocus hasFocus (Model modelData) =
    Model { modelData | hasFocus = hasFocus }


{-| Set the field value
-}
setValue : value -> Model value msg -> Model value msg
setValue value (Model modelData) =
    Model { modelData | value = Just value }


{-| Reset the field value
-}
resetValue : Model value msg -> Model value msg
resetValue (Model modelData) =
    Model { modelData | value = Nothing }


{-| Internal.
-}
updateSelectedValue : value -> Model value msg -> Model value msg
updateSelectedValue value (Model modelData) =
    Model { modelData | value = Just value }


updateActiveOption : Int -> Model value msg -> Model value msg
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


getValuesLength : Model value msg -> Int
getValuesLength (Model modelData) =
    modelData.values
        |> RemoteData.withDefault []
        |> List.filter (modelData.optionsFilter modelData.filter)
        |> List.length


{-| Return the input value
-}
getValue : Model value msg -> Maybe value
getValue (Model { value }) =
    value


{-| Return the input value
-}
getFilter : Model value msg -> String
getFilter (Model { filter }) =
    filter


{-| Internal.
-}
mapFieldStatus : (FieldStatus -> FieldStatus) -> Model value msg -> Model value msg
mapFieldStatus mapper (Model modelData) =
    Model { modelData | fieldStatus = mapper modelData.fieldStatus }


{-| Internal.
-}
getOptions : Model value msg -> List (Option value)
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
type Config validationData value parsedValue msg
    = Config
        { additionalContent : Maybe (Html Never)
        , disabled : Bool
        , footerAction : Maybe (Html msg)
        , headerText : Maybe String
        , hint : Maybe Hint.Config
        , id : String
        , isSubmitted : CommonsAlias.IsSubmitted
        , label : Maybe Label.Config
        , name : CommonsAlias.Name
        , noResultsFoundMessage : String
        , placeholder : String
        , size : Size
        , errorShowingStrategy : Maybe Error.ShowingStrategy
        , suggestion : Maybe FormDropdown.SuggestionData
        , validation : Maybe (CommonsAlias.Validation validationData (Maybe value) parsedValue)
        }


{-| Creates the Autocomplete view configuration.
-}
config : CommonsAlias.Name -> Config validationData value parsedValue msg
config name =
    Config
        { additionalContent = Nothing
        , disabled = False
        , footerAction = Nothing
        , headerText = Nothing
        , hint = Nothing
        , id = "id-" ++ name
        , isSubmitted = False
        , label = Nothing
        , name = name
        , noResultsFoundMessage = "No results found."
        , placeholder = ""
        , size = Medium
        , errorShowingStrategy = Nothing
        , suggestion = Nothing
        , validation = Nothing
        }


{-| Add an addon which suggest or help the user during search.
Will be prepended to options.
-}
withHeaderText :
    String
    -> Config validationData value parsedValue msg
    -> Config validationData value parsedValue msg
withHeaderText text (Config configData) =
    Config { configData | headerText = Just text }


{-| Add an addon with a call to action to be shown when no options are found.
-}
withNoResultFoundAction :
    Html msg
    -> Config validationData value parsedValue msg
    -> Config validationData value parsedValue msg
withNoResultFoundAction action (Config configData) =
    Config { configData | footerAction = Just action }


{-| Add an addon which suggest or help the user during search.
Will be appended to options.
-}
withSuggestion :
    FormDropdown.SuggestionData
    -> Config validationData value parsedValue msg
    -> Config validationData value parsedValue msg
withSuggestion suggestion (Config configData) =
    Config { configData | suggestion = Just suggestion }


{-| Append an additional custom html.
-}
withAdditionalContent :
    Html Never
    -> Config validationData value parsedValue msg
    -> Config validationData value parsedValue msg
withAdditionalContent additionalContent (Config configuration) =
    Config { configuration | additionalContent = Just additionalContent }


{-| Sets whether the Autocomplete is disabled.
-}
withDisabled : Bool -> Config validationData value parsedValue msg -> Config validationData value parsedValue msg
withDisabled disabled (Config configuration) =
    Config { configuration | disabled = disabled }


{-| Sets the Autocomplete hint.
-}
withHint : String -> Config validationData value parsedValue msg -> Config validationData value parsedValue msg
withHint hintMessage (Config configuration) =
    Config
        { configuration
            | hint =
                hintMessage
                    |> Hint.config
                    |> Hint.withFieldId configuration.id
                    |> Just
        }


{-| Adds a label to the Autocomplete.
-}
withLabel :
    Label.Config
    -> Config validationData value parsedValue msg
    -> Config validationData value parsedValue msg
withLabel label (Config configData) =
    Config { configData | label = Just label }


{-| Adds an id to the Autocomplete.
-}
withId : CommonsAlias.Id -> Config validationData value parsedValue msg -> Config validationData value parsedValue msg
withId id (Config configData) =
    Config { configData | id = id }


{-| Adds custom message instead of the default "No results found".
-}
withNoResultsFoundMessage :
    String
    -> Config validationData value parsedValue msg
    -> Config validationData value parsedValue msg
withNoResultsFoundMessage message (Config configuration) =
    Config { configuration | noResultsFoundMessage = message }


{-| Sets the Autocomplete placeholder.
-}
withPlaceholder :
    String
    -> Config validationData value parsedValue msg
    -> Config validationData value parsedValue msg
withPlaceholder placeholder (Config configuration) =
    Config { configuration | placeholder = placeholder }


{-| Sets the Autocomplete size.
-}
withSize : Size -> Config validationData value parsedValue msg -> Config validationData value parsedValue msg
withSize size (Config configuration) =
    Config { configuration | size = size }


{-| Sets the showing error strategy to `OnSubmit` (The error will be shown only after the form submission)
-}
withValidationOnSubmit :
    CommonsAlias.Validation validationData (Maybe value) parsedValue
    -> CommonsAlias.IsSubmitted
    -> Config validationData value parsedValue msg
    -> Config validationData value parsedValue msg
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
    -> Config validationData value parsedValue msg
    -> Config validationData value parsedValue msg
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
    -> Config validationData value parsedValue msg
    -> Config validationData value parsedValue msg
withValidationOnBlur validation isSubmitted (Config configuration) =
    Config
        { configuration
            | isSubmitted = isSubmitted
            , validation = Just validation
            , errorShowingStrategy = Error.onBlur |> Just
        }


{-| Renders the Autocomplete.
-}
render :
    (Msg value -> msg)
    -> validationData
    -> Model value msg
    -> Config validationData value parsedValue msg
    -> Html msg
render msgMapper validationData ((Model modelData) as model) ((Config configData) as config_) =
    let
        dropdown : Maybe (Html msg)
        dropdown =
            renderDropdown msgMapper model config_

        error : Maybe (Error.Config parsedValue)
        error =
            generateErrorConfig validationData model config_
    in
    Html.div
        [ Html.Attributes.classList
            [ ( "form-field", True )
            , ( "form-field--with-opened-dropdown", modelData.isDropdownOpen && Maybe.Extra.isJust dropdown && RemoteData.isSuccess modelData.values )
            , ( "form-field--error", Error.isVisible error )
            , ( "form-field--disabled", configData.disabled )
            ]
        ]
        [ renderField error msgMapper model config_
        , CommonsRender.renderMaybe dropdown
        ]
        |> FormItem.config configData
        |> FormItem.withLabel configData.label
        |> FormItem.withAdditionalContent configData.additionalContent
        |> FormItem.render error


{-| Internal
-}
generateErrorConfig : validationData -> Model value msg -> Config validationData value parsedValue msg -> Maybe (Error.Config parsedValue)
generateErrorConfig validationData (Model { fieldStatus, value }) (Config { id, isSubmitted, validation, errorShowingStrategy }) =
    let
        getErrorConfig : Result CommonsAlias.ErrorMessage parsedValue -> Error.ShowingStrategy -> Error.Config parsedValue
        getErrorConfig validationResult =
            Error.config id validationResult
                >> Error.withIsDirty fieldStatus.isDirty
                >> Error.withIsBlurred fieldStatus.isBlurred
                >> Error.withIsSubmitted isSubmitted
    in
    Maybe.map2 getErrorConfig
        (Maybe.map (\v -> v validationData value) validation)
        errorShowingStrategy


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
renderField :
    Maybe (Error.Config parsedValue)
    -> (Msg value -> msg)
    -> Model value msg
    -> Config validationData value parsedValue msg
    -> Html msg
renderField error msgMapper ((Model modelData) as model) (Config configData) =
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
            , CommonsAttributes.ariaDescribedByErrorOrHint
                (Maybe.map (always (Error.idFromFieldId configData.id)) error)
                (Maybe.map (always (Hint.toId configData.id)) configData.hint)
            , CommonsAttributes.ariaDescribedByErrorOrHint
                (Maybe.map (always (Error.idFromFieldId configData.id)) error)
                (Maybe.map (always (Hint.toId configData.id)) configData.hint)
            ]
            []
        , renderFieldIconAddon model
        ]
        |> Html.map msgMapper


{-| Internal.
-}
renderFieldIconAddon : Model value msg -> Html (Msg value)
renderFieldIconAddon ((Model modelData) as model) =
    Html.div
        [ Html.Attributes.classList
            [ ( "form-field__addon", True )
            , ( "form-field__addon--loading", RemoteData.isLoading modelData.values )
            ]
        ]
        [ model
            |> getFieldAddonIcon
            |> Icon.withSize Icon.small
            |> Icon.render
            |> CommonsRender.renderIf (Maybe.Extra.isNothing modelData.value)
        , Html.button
            [ Html.Attributes.class "form-field__addon__reset"
            , Html.Attributes.type_ "button"
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
getFieldAddonIcon : Model value msg -> Icon.Config
getFieldAddonIcon (Model modelData) =
    if Maybe.Extra.isJust modelData.value then
        Icon.config IconSet.Close

    else
        Icon.config IconSet.Search


{-| Internal.
-}
renderDropdown : (Msg value -> msg) -> Model value msg -> Config validationData value parsedValue msg -> Maybe (Html msg)
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
        configData.suggestion
            |> Maybe.map FormDropdown.suggestion
            |> Maybe.map (FormDropdown.render configData.id (mapDropdownSize configData.size))

    else if modelData.hasFocus then
        FormDropdown.render
            configData.id
            (mapDropdownSize configData.size)
            (if noAvailableOptions then
                FormDropdown.noResult
                    { label = configData.noResultsFoundMessage
                    , action = configData.footerAction
                    }

             else
                case
                    ( configData.headerText
                    , configData.suggestion
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
renderOptionsItem : (Msg value -> msg) -> Model value msg -> Int -> Option value -> Html msg
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
