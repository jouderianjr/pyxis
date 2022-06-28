module Pyxis.Components.Field.CheckboxGroup exposing
    ( Model
    , init
    , setOnBlur
    , setOnFocus
    , setOnCheck
    , Config
    , config
    , Layout(..)
    , horizontal
    , vertical
    , withLayout
    , withAdditionalContent
    , withClassList
    , withId
    , withIsSubmitted
    , withLabel
    , withStrategy
    , Msg
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


# CheckboxGroup component

@docs Model
@docs init
@docs setOnBlur
@docs setOnFocus
@docs setOnCheck


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
@docs withIsSubmitted
@docs withLabel
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
@docs withDisabledOption


## Rendering

@docs render

-}

import Html exposing (Html)
import Html.Attributes
import Html.Events
import PrimaFunction
import PrimaUpdate
import Pyxis.Commons.Attributes as CommonsAttributes
import Pyxis.Commons.Commands as Commands
import Pyxis.Components.Field.Error.Strategy as Strategy exposing (Strategy)
import Pyxis.Components.Field.Error.Strategy.Internal as InternalStrategy
import Pyxis.Components.Field.Hint as Hint
import Pyxis.Components.Field.Label as Label
import Pyxis.Components.Field.Status as FieldStatus
import Pyxis.Components.Form.FormItem as FormItem
import Result.Extra


{-| A type representing the CheckboxGroup field internal state.
-}
type Model ctx value msg
    = Model
        { checkedValues : List value
        , validation : ctx -> List value -> Result String (List value)
        , fieldStatus : FieldStatus.Status
        , onBlur : Maybe msg
        , onFocus : Maybe msg
        , onCheck : Maybe msg
        }


{-| Initialize the CheckboxGroup internal state.
Takes a validation function as argument
-}
init : List value -> (ctx -> List value -> Result String (List value)) -> Model ctx value msg
init initialValues validation =
    Model
        { checkedValues = initialValues
        , validation = validation
        , fieldStatus = FieldStatus.Untouched
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
update : Msg value -> Model ctx value msg -> ( Model ctx value msg, Cmd msg )
update msg ((Model modelData) as model) =
    case msg of
        OnBlur ->
            model
                |> mapFieldStatus FieldStatus.onBlur
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onBlur ]

        OnFocus ->
            model
                |> mapFieldStatus FieldStatus.onFocus
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onFocus ]

        OnCheck value check ->
            model
                |> PrimaFunction.ifThenElseMap (always check)
                    (checkValue value)
                    (uncheckValue value)
                |> mapFieldStatus FieldStatus.onChange
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onCheck ]


{-| Update the field value.
-}
updateValue : value -> Bool -> Model ctx value msg -> ( Model ctx value msg, Cmd msg )
updateValue value checked =
    update (OnCheck value checked)


{-| Add the value to the checked list
-}
checkValue : value -> Model ctx value msg -> Model ctx value msg
checkValue value =
    mapCheckedValues ((::) value)


{-| Remove the value to the checked list
-}
uncheckValue : value -> Model ctx value msg -> Model ctx value msg
uncheckValue value =
    mapCheckedValues (List.filter ((/=) value))


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


{-| Sets an OnCheck side effect.
-}
setOnCheck : msg -> Model ctx value msg -> Model ctx value msg
setOnCheck msg (Model configuration) =
    Model { configuration | onCheck = Just msg }


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
withAdditionalContent : Html Never -> Config value msg -> Config value msg
withAdditionalContent additionalContent (Config configData) =
    Config { configData | additionalContent = Just additionalContent }


{-| Sets the disabled attribute on option
-}
withDisabledOption : Bool -> Option value msg -> Option value msg
withDisabledOption disabled (Option optionData) =
    Option { optionData | disabled = disabled }


{-| Set the CheckboxGroup checkboxes options
-}
withOptions : List (Option value msg) -> Config value msg -> Config value msg
withOptions options (Config configData) =
    Config { configData | options = options }


{-| Sets the label attribute
-}
withLabel : Label.Config -> Config value msg -> Config value msg
withLabel label (Config configData) =
    Config { configData | label = Just label }


{-| Sets the classList attribute
-}
withClassList : List ( String, Bool ) -> Config value msg -> Config value msg
withClassList classList (Config configData) =
    Config { configData | classList = classList }


{-| Sets the id attribute
-}
withId : String -> Config value msg -> Config value msg
withId id (Config configData) =
    Config { configData | id = id }


{-| Sets the validation strategy (when to show the error, if present)
-}
withStrategy : Strategy -> Config value msg -> Config value msg
withStrategy strategy (Config configuration) =
    Config { configuration | strategy = strategy }


{-| Sets whether the form was submitted
-}
withIsSubmitted : Bool -> Config value msg -> Config value msg
withIsSubmitted isSubmitted (Config configuration) =
    Config { configuration | isSubmitted = isSubmitted }


{-| Represent the layout of the group.
-}
type Layout
    = Horizontal
    | Vertical


{-| Sets the CheckboxGroup layout
-}
withLayout : Layout -> Config value msg -> Config value msg
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


{-| Internal
-}
type alias ConfigData value msg =
    { additionalContent : Maybe (Html Never)
    , ariaLabelledBy : Maybe String
    , classList : List ( String, Bool )
    , hint : Maybe Hint.Config
    , id : String
    , label : Maybe Label.Config
    , layout : Layout
    , name : String
    , options : List (Option value msg)
    , strategy : Strategy
    , isSubmitted : Bool
    }


{-| A type representing the select rendering options.
This should not belong to the app `Model`
-}
type Config value msg
    = Config (ConfigData value msg)


{-| Create a default [`CheckboxGroup.Config`](CheckboxGroup#Config)
-}
config : String -> Config value msg
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
        , strategy = Strategy.onBlur
        , isSubmitted = False
        }


{-| Render the CheckboxGroup
-}
render : (Msg value -> msg) -> ctx -> Model ctx value msg -> Config value msg -> Html msg
render tagger ctx (Model modelData) (Config configData) =
    let
        shownValidation : Result String ()
        shownValidation =
            InternalStrategy.getValidationResult
                modelData.fieldStatus
                (modelData.validation ctx modelData.checkedValues)
                configData.isSubmitted
                configData.strategy

        renderCheckbox_ : Option value msg -> Html msg
        renderCheckbox_ =
            renderCheckbox tagger
                { hasError = Result.Extra.isErr shownValidation
                , checkedValues = modelData.checkedValues
                }
                configData
    in
    configData.options
        |> List.map renderCheckbox_
        |> renderControlGroup configData
        |> FormItem.config configData
        |> FormItem.withLabel configData.label
        |> FormItem.withAdditionalContent configData.additionalContent
        |> FormItem.render shownValidation


{-| Internal.
Handles the single input / input group markup difference
-}
renderControlGroup : ConfigData value msg -> List (Html msg) -> Html msg
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


{-| Get the parsed value
-}
validate : ctx -> Model ctx value msg -> Result String (List value)
validate ctx (Model modelData) =
    modelData.validation ctx modelData.checkedValues


{-| Get the checked options **without** passing through the validation
-}
getValue : Model ctx value msg -> List value
getValue (Model modelData) =
    modelData.checkedValues


{-| Internal
-}
renderCheckbox : (Msg value -> msg) -> { hasError : Bool, checkedValues : List value } -> { r | name : String } -> Option value msg -> Html msg
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



-- Getters/Setters boilerplate


mapCheckedValues : (List value -> List value) -> Model ctx value msg -> Model ctx value msg
mapCheckedValues f (Model modelData) =
    Model { modelData | checkedValues = f modelData.checkedValues }


{-| Internal
-}
mapFieldStatus : (FieldStatus.Status -> FieldStatus.Status) -> Model ctx value msg -> Model ctx value msg
mapFieldStatus f (Model model) =
    Model { model | fieldStatus = f model.fieldStatus }
