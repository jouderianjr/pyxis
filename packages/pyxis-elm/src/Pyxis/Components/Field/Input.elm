module Pyxis.Components.Field.Input exposing
    ( Model
    , init
    , resetValue
    , setOnBlur
    , setOnFocus
    , setOnInput
    , setValue
    , date
    , DateConfig
    , email
    , EmailConfig
    , number
    , NumberConfig
    , password
    , PasswordConfig
    , text
    , TextConfig
    , withTextPrepend
    , withTextAppend
    , withIconPrepend
    , withIconAppend
    , small
    , medium
    , Size
    , withSize
    , withAdditionalContent
    , withClassList
    , withDisabled
    , withHint
    , withId
    , withLabel
    , withMax
    , withMin
    , withPlaceholder
    , withStep
    , withValidationOnBlur
    , withValidationOnInput
    , withValidationOnSubmit
    , withValueMapper
    , Msg
    , update
    , updateValue
    , getValue
    , render
    )

{-|


# Input component

@docs Model
@docs init
@docs resetValue
@docs setOnBlur
@docs setOnFocus
@docs setOnInput
@docs setValue


## Config

@docs date
@docs DateConfig
@docs email
@docs EmailConfig
@docs number
@docs NumberConfig
@docs password
@docs PasswordConfig
@docs text
@docs TextConfig


## Addon

@docs withTextPrepend
@docs withTextAppend
@docs withIconPrepend
@docs withIconAppend


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
@docs withLabel
@docs withMax
@docs withMin
@docs withPlaceholder
@docs withStep
@docs withValidationOnBlur
@docs withValidationOnInput
@docs withValidationOnSubmit
@docs withValueMapper


## Update

@docs Msg
@docs update
@docs updateValue


## Readers

@docs getValue


## Rendering

@docs render

-}

import Date
import Html exposing (Html)
import Html.Attributes
import Html.Events
import PrimaUpdate
import Pyxis.Commons.Alias as CommonsAlias
import Pyxis.Commons.Attributes as CommonsAttributes
import Pyxis.Commons.Commands as Commands
import Pyxis.Commons.Constraints as CommonsConstraints
import Pyxis.Commons.Render as CommonsRender
import Pyxis.Components.Field.Error as Error
import Pyxis.Components.Field.FieldStatus as FieldStatus exposing (FieldStatus)
import Pyxis.Components.Field.Hint as Hint
import Pyxis.Components.Field.Label as Label
import Pyxis.Components.Form.FormItem as FormItem
import Pyxis.Components.Icon as Icon
import Pyxis.Components.IconSet as IconSet
import Result.Extra


{-| Represent the messages the Input Text can handle.
-}
type Msg
    = OnInput String
    | OnFocus
    | OnBlur


{-| The Input model.
-}
type Model msg
    = Model
        { value : String
        , fieldStatus : FieldStatus
        , onFocus : Maybe msg
        , onBlur : Maybe msg
        , onInput : Maybe msg
        }


{-| Inits the Input model.
-}
init : Model msg
init =
    Model
        { value = ""
        , fieldStatus = FieldStatus.init
        , onFocus = Nothing
        , onBlur = Nothing
        , onInput = Nothing
        }


{-| Update the input internal model
-}
update : Msg -> Model msg -> ( Model msg, Cmd msg )
update msg ((Model modelData) as model) =
    case msg of
        OnBlur ->
            model
                |> mapFieldStatus (FieldStatus.setIsBlurred True)
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onBlur
                    ]

        OnFocus ->
            model
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onFocus
                    ]

        OnInput value ->
            Model { modelData | value = value }
                |> mapFieldStatus (FieldStatus.setIsDirty True)
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onInput
                    ]


{-| Update the field value.
-}
updateValue : String -> Model msg -> ( Model msg, Cmd msg )
updateValue value =
    update (OnInput value)


{-| Internal
-}
mapFieldStatus : (FieldStatus -> FieldStatus) -> Model msg -> Model msg
mapFieldStatus mapper (Model model) =
    Model { model | fieldStatus = mapper model.fieldStatus }


{-| Sets an OnBlur side effect.
-}
setOnBlur : msg -> Model msg -> Model msg
setOnBlur msg (Model configuration) =
    Model { configuration | onBlur = Just msg }


{-| Sets an OnFocus side effect.
-}
setOnFocus : msg -> Model msg -> Model msg
setOnFocus msg (Model configuration) =
    Model { configuration | onFocus = Just msg }


{-| Sets an OnInput side effect.
-}
setOnInput : msg -> Model msg -> Model msg
setOnInput msg (Model configuration) =
    Model { configuration | onInput = Just msg }


{-| Set the field value
-}
setValue : String -> Model msg -> Model msg
setValue value (Model modelData) =
    Model { modelData | value = value }


{-| Reset the field value
-}
resetValue : Model msg -> Model msg
resetValue (Model modelData) =
    Model { modelData | value = "" }


{-| Return the input value.
-}
getValue : Model msg -> String
getValue (Model { value }) =
    value


{-| Input size.
-}
type Size
    = Small
    | Medium


{-| Input size small.
-}
small : Size
small =
    Small


{-| Input size medium.
-}
medium : Size
medium =
    Medium


{-| The view config.
-}
type Config validationData parsedValue constraints
    = Config
        { additionalContent : Maybe (Html Never)
        , addon : Maybe Addon
        , classList : List ( String, Bool )
        , disabled : Bool
        , hint : Maybe Hint.Config
        , id : CommonsAlias.Id
        , isSubmitted : CommonsAlias.IsSubmitted
        , label : Maybe Label.Config
        , min : Maybe String
        , max : Maybe String
        , name : CommonsAlias.Name
        , placeholder : Maybe String
        , size : Size
        , errorShowingStrategy : Maybe Error.ShowingStrategy
        , step : Maybe String
        , type_ : Type
        , valueMapper : String -> String
        , validation : Maybe (CommonsAlias.Validation validationData String parsedValue)
        }


{-| Common constraints.
-}
type alias CommonConstraints specificConstraints =
    { specificConstraints
        | additionalContent : CommonsConstraints.Allowed
        , classList : CommonsConstraints.Allowed
        , disabled : CommonsConstraints.Allowed
        , hint : CommonsConstraints.Allowed
        , id : CommonsConstraints.Allowed
        , isSubmitted : CommonsConstraints.Allowed
        , label : CommonsConstraints.Allowed
        , size : CommonsConstraints.Allowed
        , validation : CommonsConstraints.Allowed
        , valueMapper : CommonsConstraints.Allowed
    }


{-| Date constraints.
-}
type alias DateConstraints =
    CommonConstraints
        { min : CommonsConstraints.Allowed
        , max : CommonsConstraints.Allowed
        , step : CommonsConstraints.Allowed
        }


{-| Email constraints.
-}
type alias EmailConstraints =
    CommonConstraints
        { addon : CommonsConstraints.Allowed
        , placeholder : CommonsConstraints.Allowed
        }


{-| Number constraints.
-}
type alias NumberConstraints =
    CommonConstraints
        { addon : CommonsConstraints.Allowed
        , placeholder : CommonsConstraints.Allowed
        , min : CommonsConstraints.Allowed
        , max : CommonsConstraints.Allowed
        , step : CommonsConstraints.Allowed
        }


{-| Password constraints.
-}
type alias PasswordConstraints =
    CommonConstraints
        { addon : CommonsConstraints.Allowed
        , placeholder : CommonsConstraints.Allowed
        }


{-| Text constraints.
-}
type alias TextConstraints =
    CommonConstraints
        { addon : CommonsConstraints.Allowed
        , placeholder : CommonsConstraints.Allowed
        }


{-| Internal. Creates an Input field.
-}
config : Type -> CommonsAlias.Name -> Config validationData parsedValue constraints
config inputType name =
    Config
        { additionalContent = Nothing
        , addon = Nothing
        , classList = []
        , disabled = False
        , hint = Nothing
        , id = "id-" ++ name
        , isSubmitted = False
        , label = Nothing
        , max = Nothing
        , min = Nothing
        , name = name
        , placeholder = Nothing
        , size = Medium
        , step = Nothing
        , errorShowingStrategy = Nothing
        , type_ = inputType
        , valueMapper = identity
        , validation = Nothing
        }


{-| Represent the Type(s) an Input could be.
-}
type Type
    = Date
    | Email
    | Number
    | Password
    | Text


{-| Date configuration.
-}
type alias DateConfig validationData value =
    Config validationData value DateConstraints


{-| Email configuration.
-}
type alias EmailConfig validationData value =
    Config validationData value EmailConstraints


{-| Number configuration.
-}
type alias NumberConfig validationData value =
    Config validationData value NumberConstraints


{-| Password configuration.
-}
type alias PasswordConfig validationData value =
    Config validationData value PasswordConstraints


{-| Text configuration.
-}
type alias TextConfig validationData value =
    Config validationData value TextConstraints


{-| Creates an input with [type="email"].
-}
email : String -> EmailConfig validationData value
email =
    config Email


{-| Creates an input with [type="date"].
-}
date : String -> DateConfig validationData value
date =
    config Date


{-| Creates an input with [type="number"].
-}
number : String -> NumberConfig validationData value
number =
    config Number


{-| Creates an input with [type="text"].
-}
text : String -> TextConfig validationData value
text =
    config Text


{-| Creates an input with [type="password"].
-}
password : String -> PasswordConfig validationData value
password =
    config Password


{-| Internal.
-}
typeToAttribute : Type -> Html.Attribute msg
typeToAttribute a =
    case a of
        Date ->
            Html.Attributes.type_ "date"

        Email ->
            Html.Attributes.type_ "email"

        Number ->
            Html.Attributes.type_ "number"

        Password ->
            Html.Attributes.type_ "password"

        Text ->
            Html.Attributes.type_ "text"


{-| Addon types.
-}
type AddonType
    = IconAddon IconSet.Icon
    | TextAddon String


{-| Addon configuration.
-}
type alias Addon =
    { placement : AddonPlacement
    , type_ : AddonType
    }


{-| Addon placement
-}
type AddonPlacement
    = Prepend
    | Append


{-| Internal
-}
isPrepend : AddonPlacement -> Bool
isPrepend placement =
    case placement of
        Prepend ->
            True

        _ ->
            False


{-| Internal
-}
isAppend : AddonPlacement -> Bool
isAppend placement =
    case placement of
        Append ->
            True

        _ ->
            False


{-| Internal
-}
placementToString : AddonPlacement -> String
placementToString placement =
    case placement of
        Prepend ->
            "prepend"

        Append ->
            "append"


{-| Internal
-}
addonTypeToString : AddonType -> String
addonTypeToString addonType =
    case addonType of
        IconAddon _ ->
            "icon"

        TextAddon _ ->
            "text"


{-| Internal.
-}
addonToAttribute : Addon -> Html.Attribute msg
addonToAttribute { type_, placement } =
    [ "form-field--with"
    , placementToString placement
    , addonTypeToString type_
    ]
        |> String.join "-"
        |> Html.Attributes.class


{-| Maps the inputted string before the update

    Text.config "id"
        |> Input.withValueMapper String.toUppercase
        |> Input.render Tagger formData model.textModel

In this example, if the user inputs "abc", the actual inputted text is "ABC".
This applies to both the user UI and the `getValue`/`validate` functions

-}
withValueMapper :
    (String -> String)
    -> Config validationData value { c | valueMapper : CommonsConstraints.Allowed }
    -> Config validationData value { c | valueMapper : CommonsConstraints.Denied }
withValueMapper mapper (Config configData) =
    Config { configData | valueMapper = mapper }


{-| Sets a Text Addon prepended to the Input.
-}
withTextPrepend :
    String
    -> Config validationData value { c | addon : CommonsConstraints.Allowed }
    -> Config validationData value { c | addon : CommonsConstraints.Denied }
withTextPrepend text_ (Config configuration) =
    Config { configuration | addon = Just { placement = Prepend, type_ = TextAddon text_ } }


{-| Sets a Text Addon appended to the Input.
-}
withTextAppend :
    String
    -> Config validationData value { c | addon : CommonsConstraints.Allowed }
    -> Config validationData value { c | addon : CommonsConstraints.Denied }
withTextAppend text_ (Config configuration) =
    Config { configuration | addon = Just { placement = Append, type_ = TextAddon text_ } }


{-| Sets an Icon Addon prepended to the Input.
-}
withIconPrepend :
    IconSet.Icon
    -> Config validationData value { c | addon : CommonsConstraints.Allowed }
    -> Config validationData value { c | addon : CommonsConstraints.Denied }
withIconPrepend icon (Config configuration) =
    Config { configuration | addon = Just { placement = Prepend, type_ = IconAddon icon } }


{-| Sets an Icon Addon appended to the Input.
-}
withIconAppend :
    IconSet.Icon
    -> Config validationData value { c | addon : CommonsConstraints.Allowed }
    -> Config validationData value { c | addon : CommonsConstraints.Denied }
withIconAppend icon (Config configuration) =
    Config { configuration | addon = Just { placement = Append, type_ = IconAddon icon } }


{-| Adds a Label to the Input.
-}
withLabel :
    Label.Config
    -> Config validationData value { c | label : CommonsConstraints.Allowed }
    -> Config validationData value { c | label : CommonsConstraints.Denied }
withLabel a (Config configuration) =
    Config { configuration | label = Just a }


{-| Sets the input as disabled
-}
withDisabled :
    Bool
    -> Config validationData value { c | disabled : CommonsConstraints.Allowed }
    -> Config validationData value { c | disabled : CommonsConstraints.Denied }
withDisabled isDisabled (Config configuration) =
    Config { configuration | disabled = isDisabled }


{-| Sets the input hint
-}
withHint :
    String
    -> Config validationData value { c | hint : CommonsConstraints.Allowed }
    -> Config validationData value { c | hint : CommonsConstraints.Denied }
withHint hintMessage (Config configuration) =
    Config
        { configuration
            | hint =
                Hint.config hintMessage
                    |> Hint.withFieldId configuration.id
                    |> Just
        }


{-| Sets a Size to the Input.
-}
withSize :
    Size
    -> Config validationData value { c | size : CommonsConstraints.Allowed }
    -> Config validationData value { c | size : CommonsConstraints.Denied }
withSize size (Config configuration) =
    Config { configuration | size = size }


{-| Sets a ClassList to the Input.
-}
withClassList :
    List ( String, Bool )
    -> Config validationData value { c | classList : CommonsConstraints.Allowed }
    -> Config validationData value { c | classList : CommonsConstraints.Denied }
withClassList classes (Config configuration) =
    Config { configuration | classList = classes }


{-| Sets a Max attribute to the Input.
-}
withMax :
    String
    -> Config validationData value { c | max : CommonsConstraints.Allowed }
    -> Config validationData value { c | max : CommonsConstraints.Denied }
withMax max (Config configuration) =
    Config { configuration | max = Just max }


{-| Sets a Min attribute to the Input.
-}
withMin :
    String
    -> Config validationData value { c | min : CommonsConstraints.Allowed }
    -> Config validationData value { c | min : CommonsConstraints.Denied }
withMin min (Config configuration) =
    Config { configuration | min = Just min }


{-| Sets a Name to the Input.
-}
withId :
    CommonsAlias.Id
    -> Config validationData value { c | id : CommonsConstraints.Allowed }
    -> Config validationData value { c | id : CommonsConstraints.Denied }
withId id (Config configuration) =
    Config { configuration | id = id }


{-| Sets a Step to the Input.
-}
withStep :
    String
    -> Config validationData value { c | step : CommonsConstraints.Allowed }
    -> Config validationData value { c | step : CommonsConstraints.Denied }
withStep step (Config configuration) =
    Config { configuration | step = Just step }


{-| Sets a Placeholder to the Input.
-}
withPlaceholder :
    String
    -> Config validationData value { c | placeholder : CommonsConstraints.Allowed }
    -> Config validationData value { c | placeholder : CommonsConstraints.Denied }
withPlaceholder placeholder (Config configuration) =
    Config { configuration | placeholder = Just placeholder }


{-| Append an additional custom html.
-}
withAdditionalContent :
    Html Never
    -> Config validationData value { c | additionalContent : CommonsConstraints.Allowed }
    -> Config validationData value { c | additionalContent : CommonsConstraints.Denied }
withAdditionalContent additionalContent (Config configuration) =
    Config { configuration | additionalContent = Just additionalContent }


{-| Sets the showing error strategy to `OnSubmit` (The error will be shown only after the form submission)
-}
withValidationOnSubmit :
    CommonsAlias.Validation validationData String value
    -> CommonsAlias.IsSubmitted
    -> Config validationData value { c | validation : CommonsConstraints.Allowed }
    -> Config validationData value { c | validation : CommonsConstraints.Denied }
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
    CommonsAlias.Validation validationData String value
    -> CommonsAlias.IsSubmitted
    -> Config validationData value { c | validation : CommonsConstraints.Allowed }
    -> Config validationData value { c | validation : CommonsConstraints.Denied }
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
    CommonsAlias.Validation validationData String value
    -> CommonsAlias.IsSubmitted
    -> Config validationData value { c | validation : CommonsConstraints.Allowed }
    -> Config validationData value { c | validation : CommonsConstraints.Denied }
withValidationOnBlur validation isSubmitted (Config configuration) =
    Config
        { configuration
            | isSubmitted = isSubmitted
            , validation = Just validation
            , errorShowingStrategy = Error.onBlur |> Just
        }


{-| Internal
-}
addIconCalendarToDateField : Config validationData parsedValue constraints -> Config validationData parsedValue constraints
addIconCalendarToDateField ((Config configData) as config_) =
    case configData.type_ of
        Date ->
            Config { configData | addon = Just { placement = Prepend, type_ = IconAddon IconSet.Calendar } }

        _ ->
            config_


{-| Renders the Input.Stories/Chapters/DateField.elm
-}
render : (Msg -> msg) -> validationData -> Model msg -> Config validationData parsedValue constraints -> Html msg
render tagger validationData model ((Config configData) as config_) =
    let
        error : Maybe (Error.Config parsedValue)
        error =
            generateErrorConfig validationData model config_
    in
    config_
        |> addIconCalendarToDateField
        |> renderField error model
        |> Html.map tagger
        |> FormItem.config configData
        |> FormItem.withLabel configData.label
        |> FormItem.withAdditionalContent configData.additionalContent
        |> FormItem.render error


{-| Internal
-}
generateErrorConfig : validationData -> Model msg -> Config validationData parsedValue constraints -> Maybe (Error.Config parsedValue)
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


{-| Internal.
-}
renderField : Maybe (Error.Config value) -> Model msg -> Config validationData parsedValue constraints -> Html Msg
renderField error model ((Config { disabled, addon }) as configuration) =
    Html.div
        [ Html.Attributes.classList
            [ ( "form-field", True )
            , ( "form-field--error", Error.isVisible error )
            , ( "form-field--disabled", disabled )
            ]
        , CommonsAttributes.maybe addonToAttribute addon
        ]
        [ addon
            |> Maybe.map (renderAddon error model configuration)
            |> Maybe.withDefault (renderInput error model configuration)
        ]


{-| Internal.
-}
renderAddon : Maybe (Error.Config value) -> Model msg -> Config validationData parsedValue constraints -> Addon -> Html Msg
renderAddon error model configuration addon =
    Html.label
        [ Html.Attributes.class "form-field__wrapper" ]
        [ CommonsRender.renderIf (isPrepend addon.placement) (renderAddonByType addon.type_)
        , renderInput error model configuration
        , CommonsRender.renderIf (isAppend addon.placement) (renderAddonByType addon.type_)
        ]


{-| Internal.
-}
renderAddonByType : AddonType -> Html msg
renderAddonByType type_ =
    case type_ of
        IconAddon icon ->
            Html.div
                [ Html.Attributes.class "form-field__addon" ]
                [ icon
                    |> Icon.config
                    |> Icon.render
                ]

        TextAddon str ->
            Html.span
                [ Html.Attributes.class "form-field__addon" ]
                [ Html.text str ]


{-| Internal.
-}
renderInput : Maybe (Error.Config value) -> Model msg -> Config validationData parsedValue constraints -> Html Msg
renderInput error (Model modelData) (Config configData) =
    Html.input
        [ Html.Attributes.id configData.id
        , Html.Attributes.classList
            [ ( "form-field__date", configData.type_ == Date )
            , ( "form-field__date--filled", configData.type_ == Date && Result.Extra.isOk (Date.fromIsoString modelData.value) )
            , ( "form-field__text", configData.type_ == Text )
            , ( "form-field__text", configData.type_ == Number )
            , ( "form-field__text", configData.type_ == Password )
            , ( "form-field__text", configData.type_ == Email )
            , ( "form-field__text--small", configData.type_ /= Date && Small == configData.size )
            , ( "form-field__date--small", configData.type_ == Date && Small == configData.size )
            ]
        , Html.Attributes.classList configData.classList
        , Html.Attributes.disabled configData.disabled
        , Html.Attributes.value modelData.value
        , typeToAttribute configData.type_
        , CommonsAttributes.testId configData.id
        , Html.Attributes.name configData.name
        , CommonsAttributes.maybe Html.Attributes.placeholder configData.placeholder
        , CommonsAttributes.maybe Html.Attributes.min configData.min
        , CommonsAttributes.maybe Html.Attributes.max configData.max
        , CommonsAttributes.maybe Html.Attributes.step configData.step
        , CommonsAttributes.ariaDescribedByErrorOrHint
            (Maybe.map (always (Error.idFromFieldId configData.id)) error)
            (Maybe.map (always (Hint.toId configData.id)) configData.hint)
        , Html.Events.onInput (configData.valueMapper >> OnInput)
        , Html.Events.onFocus OnFocus
        , Html.Events.onBlur OnBlur
        ]
        []
