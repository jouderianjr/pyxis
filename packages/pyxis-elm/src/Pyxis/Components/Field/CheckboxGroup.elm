module Pyxis.Components.Field.CheckboxGroup exposing
    ( Model
    , init
    , resetValue
    , setOnBlur
    , setOnCheck
    , setOnFocus
    , setValue
    , Config
    , config
    , Layout(..)
    , horizontal
    , vertical
    , withLayout
    , withAdditionalContent
    , withClassList
    , withId
    , withLabel
    , withValidationOnBlur
    , withValidationOnInput
    , withValidationOnSubmit
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


# CheckboxGroup component

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


## Layout

@docs Layout
@docs horizontal
@docs vertical
@docs withLayout


## Generics

@docs withAdditionalContent
@docs withClassList
@docs withId
@docs withLabel
@docs withValidationOnBlur
@docs withValidationOnInput
@docs withValidationOnSubmit


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
import Html.Attributes
import Html.Events
import PrimaFunction
import PrimaUpdate
import Pyxis.Commons.Alias as CommonsAlias
import Pyxis.Commons.Attributes as CommonsAttributes
import Pyxis.Commons.Commands as Commands
import Pyxis.Components.Field.Error as Error
import Pyxis.Components.Field.FieldStatus as FieldStatus exposing (FieldStatus)
import Pyxis.Components.Field.Hint as Hint
import Pyxis.Components.Field.Label as Label
import Pyxis.Components.Form.FormItem as FormItem


{-| A type representing the CheckboxGroup field internal state.
-}
type Model value msg
    = Model
        { checkedValues : List value
        , fieldStatus : FieldStatus
        , onBlur : Maybe msg
        , onFocus : Maybe msg
        , onCheck : Maybe msg
        }


{-| Initialize the CheckboxGroup internal state.
Takes a validation function as argument
-}
init : Model value msg
init =
    Model
        { checkedValues = []
        , fieldStatus = FieldStatus.init
        , onBlur = Nothing
        , onFocus = Nothing
        , onCheck = Nothing
        }


{-| A type representing the internal component `Msg`
-}
type Msg value
    = OnCheck value Bool
    | OnFocus
    | OnBlur


{-| Update the internal state of the CheckboxGroup component
-}
update : Msg value -> Model value msg -> ( Model value msg, Cmd msg )
update msg ((Model modelData) as model) =
    case msg of
        OnBlur ->
            model
                |> mapFieldStatus (FieldStatus.setIsBlurred True)
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onBlur ]

        OnFocus ->
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


{-| Add the value to the checked list
-}
checkValue : value -> Model value msg -> Model value msg
checkValue value =
    mapCheckedValues ((::) value)


{-| Remove the value to the checked list
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


{-| Set the field value
-}
setValue : List value -> Model value msg -> Model value msg
setValue checkedValues (Model modelData) =
    Model { modelData | checkedValues = checkedValues }


{-| Reset the field value
-}
resetValue : Model value msg -> Model value msg
resetValue (Model modelData) =
    Model { modelData | checkedValues = [] }


{-| A type representing a single checkbox option
-}
type Option value msg
    = Option
        { label : Html msg
        , value : value
        , disabled : Bool
        }


{-| Create a single Checkbox
-}
option : { label : Html msg, value : value } -> Option value msg
option { label, value } =
    Option
        { label = label
        , value = value
        , disabled = False
        }


{-| Append an additional custom html.
-}
withAdditionalContent : Html Never -> Config validationData value parsedValue msg -> Config validationData value parsedValue msg
withAdditionalContent additionalContent (Config configData) =
    Config { configData | additionalContent = Just additionalContent }


{-| Sets the disabled attribute on option
-}
withDisabledOption : Bool -> Option value msg -> Option value msg
withDisabledOption disabled (Option optionData) =
    Option { optionData | disabled = disabled }


{-| Set the CheckboxGroup checkboxes options
-}
withOptions : List (Option value msg) -> Config validationData value parsedValue msg -> Config validationData value parsedValue msg
withOptions options (Config configData) =
    Config { configData | options = options }


{-| Sets the label attribute
-}
withLabel : Label.Config -> Config validationData value parsedValue msg -> Config validationData value parsedValue msg
withLabel label (Config configData) =
    Config { configData | label = Just label }


{-| Sets the classList attribute
-}
withClassList : List ( String, Bool ) -> Config validationData value parsedValue msg -> Config validationData value parsedValue msg
withClassList classList (Config configData) =
    Config { configData | classList = classList }


{-| Sets the id attribute
-}
withId : CommonsAlias.Id -> Config validationData value parsedValue msg -> Config validationData value parsedValue msg
withId id (Config configData) =
    Config { configData | id = id }


{-| Represent the layout of the group.
-}
type Layout
    = Horizontal
    | Vertical


{-| Sets the CheckboxGroup layout
-}
withLayout : Layout -> Config validationData value parsedValue msg -> Config validationData value parsedValue msg
withLayout layout (Config configData) =
    Config { configData | layout = layout }


{-| Horizontal layout.
-}
horizontal : Layout
horizontal =
    Horizontal


{-| Vertical layout.
-}
vertical : Layout
vertical =
    Vertical


{-| Sets the showing error strategy to `OnSubmit` (The error will be shown only after the form submission)
-}
withValidationOnSubmit :
    CommonsAlias.Validation validationData (List value) parsedValue
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
    CommonsAlias.Validation validationData (List value) parsedValue
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
    CommonsAlias.Validation validationData (List value) parsedValue
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


{-| Internal
-}
type alias ConfigData validationData value parsedValue msg =
    { additionalContent : Maybe (Html Never)
    , ariaLabelledBy : Maybe String
    , classList : List ( String, Bool )
    , hint : Maybe Hint.Config
    , id : CommonsAlias.Id
    , label : Maybe Label.Config
    , layout : Layout
    , name : CommonsAlias.Name
    , options : List (Option value msg)
    , errorShowingStrategy : Maybe Error.ShowingStrategy
    , isSubmitted : CommonsAlias.IsSubmitted
    , validation : Maybe (CommonsAlias.Validation validationData (List value) parsedValue)
    }


{-| A type representing the select rendering options.
This should not belong to the app `Model`
-}
type Config validationData value parsedValue msg
    = Config (ConfigData validationData value parsedValue msg)


{-| Create a default [`CheckboxGroup.Config`](CheckboxGroup#Config)
-}
config : CommonsAlias.Name -> Config validationData value parsedValue msg
config name =
    Config
        { additionalContent = Nothing
        , ariaLabelledBy = Nothing
        , classList = []
        , hint = Nothing
        , id = "id-" ++ name
        , label = Nothing
        , layout = Horizontal
        , name = name
        , options = []
        , errorShowingStrategy = Nothing
        , isSubmitted = False
        , validation = Nothing
        }


{-| Render the CheckboxGroup
-}
render : (Msg value -> msg) -> validationData -> Model value msg -> Config validationData value parsedValue msg -> Html msg
render tagger validationData ((Model { checkedValues }) as model) ((Config configData) as config_) =
    let
        error : Maybe (Error.Config parsedValue)
        error =
            generateErrorConfig validationData model config_

        renderCheckbox_ : Option value msg -> Html msg
        renderCheckbox_ =
            renderCheckbox tagger
                { hasError = Error.isVisible error
                , checkedValues = checkedValues
                }
                configData
    in
    configData.options
        |> List.map renderCheckbox_
        |> renderControlGroup configData
        |> FormItem.config configData
        |> FormItem.withLabel configData.label
        |> FormItem.withAdditionalContent configData.additionalContent
        |> FormItem.render error


{-| Internal
-}
generateErrorConfig :
    validationData
    -> Model value msg
    -> Config validationData value parsedValue msg
    -> Maybe (Error.Config parsedValue)
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


{-| Internal.
Handles the single input / input group markup difference
-}
renderControlGroup : ConfigData validationData value parsedValue msg -> List (Html msg) -> Html msg
renderControlGroup configData children =
    case children of
        [ child ] ->
            child

        _ ->
            Html.div
                [ Html.Attributes.classList
                    [ ( "form-control-group", True )
                    , ( "form-control-group--column", configData.layout == Vertical )
                    ]
                , Html.Attributes.classList configData.classList
                , Html.Attributes.id configData.id
                , CommonsAttributes.testId configData.id
                , Html.Attributes.attribute "role" "group"
                , CommonsAttributes.maybe CommonsAttributes.ariaLabelledbyBy configData.ariaLabelledBy
                ]
                children


{-| Get the checked options **without** passing through the validation
-}
getValue : Model value msg -> List value
getValue (Model modelData) =
    modelData.checkedValues


{-| Internal
-}
renderCheckbox : (Msg value -> msg) -> { hasError : Bool, checkedValues : List value } -> { r | name : CommonsAlias.Name } -> Option value msg -> Html msg
renderCheckbox tagger { hasError, checkedValues } configData (Option optionData) =
    Html.label
        [ Html.Attributes.classList
            [ ( "form-control", True )
            , ( "form-control--error", hasError )
            ]
        ]
        [ Html.input
            [ Html.Attributes.type_ "checkbox"
            , Html.Attributes.classList
                [ ( "form-control__checkbox", True )
                , ( "form-control--disabled", optionData.disabled )
                ]
            , Html.Attributes.checked (List.member optionData.value checkedValues)
            , Html.Attributes.disabled optionData.disabled
            , Html.Attributes.name configData.name
            , Html.Events.onCheck (OnCheck optionData.value >> tagger)
            , Html.Events.onFocus (tagger OnFocus)
            , Html.Events.onBlur (tagger OnBlur)
            ]
            []
        , Html.span
            [ Html.Attributes.class "form-control__text" ]
            [ optionData.label ]
        ]


mapCheckedValues : (List value -> List value) -> Model value msg -> Model value msg
mapCheckedValues mapper (Model modelData) =
    Model { modelData | checkedValues = mapper modelData.checkedValues }


{-| Internal
-}
mapFieldStatus : (FieldStatus -> FieldStatus) -> Model value msg -> Model value msg
mapFieldStatus mapper (Model model) =
    Model { model | fieldStatus = mapper model.fieldStatus }
