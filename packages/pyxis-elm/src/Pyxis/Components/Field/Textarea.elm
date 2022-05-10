module Pyxis.Components.Field.Textarea exposing
    ( Model
    , init
    , Config
    , config
    , Size
    , medium
    , small
    , withSize
    , withAdditionalContent
    , withClassList
    , withDisabled
    , withHint
    , withIsSubmitted
    , withLabel
    , withId
    , withPlaceholder
    , withStrategy
    , withValueMapper
    , Msg
    , isOnBlur
    , isOnFocus
    , isOnInput
    , update
    , updateValue
    , getValue
    , validate
    , render
    )

{-|


# Textarea component

@docs Model
@docs init


## Config

@docs Config
@docs config


## Size

@docs Size
@docs medium
@docs small
@docs withSize


## Generics

@docs withAdditionalContent
@docs withClassList
@docs withDisabled
@docs withHint
@docs withIsSubmitted
@docs withLabel
@docs withId
@docs withPlaceholder
@docs withStrategy
@docs withValueMapper


## Update

@docs Msg
@docs isOnBlur
@docs isOnFocus
@docs isOnInput
@docs update
@docs updateValue


## Readers

@docs getValue
@docs validate


## Rendering

@docs render

-}

import Html exposing (Html)
import Html.Attributes
import Html.Events
import Pyxis.Commons.Attributes as CommonsAttributes
import Pyxis.Components.Field.Error as Error
import Pyxis.Components.Field.Error.Strategy as Strategy exposing (Strategy)
import Pyxis.Components.Field.Error.Strategy.Internal as StrategyInternal
import Pyxis.Components.Field.Hint as Hint
import Pyxis.Components.Field.Label as Label
import Pyxis.Components.Field.Status as FieldStatus
import Pyxis.Components.Form.FormItem as FormItem
import Result.Extra


{-| The Textarea model.
-}
type Model ctx
    = Model (ModelData ctx)


{-| Internal.
-}
type alias ModelData ctx =
    { value : String
    , validation : ctx -> String -> Result String String
    , fieldStatus : FieldStatus.Status
    }


{-| Initializes the Textarea model.
-}
init : String -> (ctx -> String -> Result String String) -> Model ctx
init initialValue validation =
    Model
        { value = initialValue
        , validation = validation
        , fieldStatus = FieldStatus.Untouched
        }


{-| Textarea size
-}
type Size
    = Small
    | Medium


{-| Textarea size small
-}
small : Size
small =
    Small


{-| Textarea size medium
-}
medium : Size
medium =
    Medium


{-| The view configuration.
-}
type Config
    = Config ConfigData


{-| Internal.
-}
type alias ConfigData =
    { additionalContent : Maybe (Html Never)
    , classList : List ( String, Bool )
    , disabled : Bool
    , hint : Maybe Hint.Config
    , id : String
    , name : String
    , placeholder : Maybe String
    , size : Size
    , label : Maybe Label.Config
    , strategy : Strategy
    , isSubmitted : Bool
    , valueMapper : String -> String
    }


{-| Creates a Textarea.
-}
config : String -> Config
config name =
    Config
        { additionalContent = Nothing
        , classList = []
        , disabled = False
        , hint = Nothing
        , id = "id-" ++ name
        , name = name
        , placeholder = Nothing
        , size = Medium
        , label = Nothing
        , strategy = Strategy.onBlur
        , isSubmitted = False
        , valueMapper = identity
        }


{-| Adds a Label to the Textarea.
-}
withLabel : Label.Config -> Config -> Config
withLabel label (Config configuration) =
    Config { configuration | label = Just label }


{-| Sets the Textarea as disabled
-}
withDisabled : Bool -> Config -> Config
withDisabled isDisabled (Config configuration) =
    Config { configuration | disabled = isDisabled }


{-| Adds the hint to the TextArea.
-}
withHint : String -> Config -> Config
withHint hintMessage (Config configuration) =
    Config
        { configuration
            | hint =
                Hint.config hintMessage
                    |> Hint.withFieldId configuration.id
                    |> Just
        }


{-| Sets the validation strategy (when to show the error, if present)
-}
withStrategy : Strategy -> Config -> Config
withStrategy strategy (Config configuration) =
    Config { configuration | strategy = strategy }


{-| Maps the inputted string before the update

    Textarea.config "id"
        |> Textarea.withValueMapper String.toUppercase
        |> Textarea.render Tagger formData model.textareaModel

In this example, if the user inputs "abc", the actual inputted text is "ABC".
This applies to both the user UI and the `getValue`/`validate` functions

-}
withValueMapper : (String -> String) -> Config -> Config
withValueMapper mapper (Config configData) =
    Config { configData | valueMapper = mapper }


{-| Sets whether the form was submitted
-}
withIsSubmitted : Bool -> Config -> Config
withIsSubmitted isSubmitted (Config configuration) =
    Config { configuration | isSubmitted = isSubmitted }


{-| Sets a Size to the Textarea
-}
withSize : Size -> Config -> Config
withSize size (Config configuration) =
    Config { configuration | size = size }


{-| Sets a ClassList to the Textarea
-}
withClassList : List ( String, Bool ) -> Config -> Config
withClassList classes (Config configuration) =
    Config { configuration | classList = classes }


{-| Sets a id to the Textarea
-}
withId : String -> Config -> Config
withId id (Config configuration) =
    Config { configuration | id = id }


{-| Sets a Placeholder to the Textarea
-}
withPlaceholder : String -> Config -> Config
withPlaceholder placeholder (Config configuration) =
    Config { configuration | placeholder = Just placeholder }


{-| Append an additional custom html.
-}
withAdditionalContent : Html Never -> Config -> Config
withAdditionalContent additionalContent (Config configuration) =
    Config { configuration | additionalContent = Just additionalContent }


{-| Represent the messages which the Textarea can handle.
-}
type Msg
    = OnInput String
    | OnFocus
    | OnBlur


{-| Returns True if the message is triggered by `Html.Events.onInput`
-}
isOnInput : Msg -> Bool
isOnInput msg =
    case msg of
        OnInput _ ->
            True

        _ ->
            False


{-| Returns True if the message is triggered by `Html.Events.onFocus`
-}
isOnFocus : Msg -> Bool
isOnFocus msg =
    case msg of
        OnFocus ->
            True

        _ ->
            False


{-| Returns True if the message is triggered by `Html.Events.onBlur`
-}
isOnBlur : Msg -> Bool
isOnBlur msg =
    case msg of
        OnBlur ->
            True

        _ ->
            False


{-| The update function.
-}
update : Msg -> Model ctx -> Model ctx
update msg model =
    case msg of
        OnBlur ->
            model
                |> mapFieldStatus FieldStatus.onBlur

        OnFocus ->
            model
                |> mapFieldStatus FieldStatus.onFocus

        OnInput value ->
            model
                |> setValue value
                |> mapFieldStatus FieldStatus.onInput


{-| Update the field value.
-}
updateValue : String -> Model ctx -> Model ctx
updateValue value =
    update (OnInput value)


{-| Internal.
-}
setValue : String -> Model ctx -> Model ctx
setValue value (Model data) =
    Model { data | value = value }


{-| Validate and update the internal model.
-}
validate : ctx -> Model ctx -> Result String String
validate ctx (Model { validation, value }) =
    validation ctx value


{-| Returns the current value of the Textarea.
-}
getValue : Model ctx -> String
getValue (Model { value }) =
    value


{-| Renders the Textarea.
-}
render : (Msg -> msg) -> ctx -> Model ctx -> Config -> Html msg
render tagger ctx ((Model modelData) as model) ((Config configData) as configuration) =
    let
        customizedLabel : Maybe Label.Config
        customizedLabel =
            Maybe.map (configData.size |> mapLabelSize |> Label.withSize) configData.label

        shownValidation : Result String ()
        shownValidation =
            StrategyInternal.getShownValidation
                modelData.fieldStatus
                (modelData.validation ctx modelData.value)
                configData.isSubmitted
                configData.strategy
    in
    configuration
        |> renderTextarea shownValidation model
        |> Html.map tagger
        |> FormItem.config configData
        |> FormItem.withLabel customizedLabel
        |> FormItem.withAdditionalContent configData.additionalContent
        |> FormItem.render shownValidation


{-| Internal.
-}
renderTextarea : Result String value -> Model ctx -> Config -> Html Msg
renderTextarea validationResult (Model modelData) (Config configData) =
    Html.div
        [ Html.Attributes.classList
            [ ( "form-field", True )
            , ( "form-field--error", Result.Extra.isErr validationResult )
            , ( "form-field--disabled", configData.disabled )
            ]
        ]
        [ Html.textarea
            [ Html.Attributes.id configData.id
            , Html.Attributes.classList
                [ ( "form-field__textarea", True )
                , ( "form-field__textarea--small", Small == configData.size )
                ]
            , Html.Attributes.classList configData.classList
            , Html.Attributes.disabled configData.disabled
            , Html.Attributes.value modelData.value
            , CommonsAttributes.testId configData.id
            , Html.Attributes.name configData.name
            , CommonsAttributes.maybe Html.Attributes.placeholder configData.placeholder
            , validationResult
                |> Error.fromResult
                |> Maybe.map (always (Error.toId configData.id))
                |> CommonsAttributes.ariaDescribedByErrorOrHint
                    (Maybe.map (always (Hint.toId configData.id)) configData.hint)
            , Html.Events.onInput (configData.valueMapper >> OnInput)
            , Html.Events.onFocus OnFocus
            , Html.Events.onBlur OnBlur
            ]
            []
        ]


{-| Internal
-}
mapFieldStatus : (FieldStatus.Status -> FieldStatus.Status) -> Model ctx -> Model ctx
mapFieldStatus mapper (Model model) =
    Model { model | fieldStatus = mapper model.fieldStatus }


mapLabelSize : Size -> Label.Size
mapLabelSize size =
    case size of
        Small ->
            Label.small

        Medium ->
            Label.medium
