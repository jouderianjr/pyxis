module Pyxis.Components.Field.Input exposing
    ( Model
    , init
    , setOnBlur
    , setOnFocus
    , setOnInput
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
    , Addon
    , AddonType
    , iconAddon
    , textAddon
    , withAddon
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
    , withMax
    , withMin
    , withPlaceholder
    , withStep
    , withStrategy
    , withValueMapper
    , Msg
    , update
    , updateValue
    , getValue
    , validate
    , render
    )

{-|


# Input component

@docs Model
@docs init
@docs setOnBlur
@docs setOnFocus
@docs setOnInput


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

@docs Addon
@docs AddonType
@docs iconAddon
@docs textAddon
@docs withAddon


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
@docs withMax
@docs withMin
@docs withPlaceholder
@docs withStep
@docs withStrategy
@docs withValueMapper


## Update

@docs Msg
@docs update
@docs updateValue


## Readers

@docs getValue
@docs validate


## Rendering

@docs render

-}

import Date
import Html exposing (Html)
import Html.Attributes
import Html.Events
import PrimaUpdate
import Pyxis.Commons.Attributes as CommonsAttributes
import Pyxis.Commons.Commands as Commands
import Pyxis.Commons.Constraints as CommonsConstraints
import Pyxis.Commons.Properties.Placement as Placement exposing (Placement)
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


{-| Represent the messages the Input Text can handle.
-}
type Msg
    = OnInput String
    | OnFocus
    | OnBlur


{-| The Input model.
-}
type Model ctx value msg
    = Model
        { validation : ctx -> String -> Result String value
        , value : String
        , fieldStatus : FieldStatus.Status
        , onFocus : Maybe msg
        , onBlur : Maybe msg
        , onInput : Maybe msg
        }


{-| Inits the Input model.
-}
init : String -> (ctx -> String -> Result String value) -> Model ctx value msg
init initialValue validation =
    Model
        { validation = validation
        , value = initialValue
        , fieldStatus = FieldStatus.Untouched
        , onFocus = Nothing
        , onBlur = Nothing
        , onInput = Nothing
        }


{-| Update the input internal model
-}
update : Msg -> Model ctx value msg -> ( Model ctx value msg, Cmd msg )
update msg ((Model modelData) as model) =
    case msg of
        OnBlur ->
            model
                |> mapFieldStatus FieldStatus.onBlur
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onBlur
                    ]

        OnFocus ->
            model
                |> mapFieldStatus FieldStatus.onFocus
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onFocus
                    ]

        OnInput value ->
            Model { modelData | value = value }
                |> mapFieldStatus FieldStatus.onInput
                |> PrimaUpdate.withCmds
                    [ Commands.dispatchFromMaybe modelData.onInput
                    ]


{-| Update the field value.
-}
updateValue : String -> Model ctx value msg -> ( Model ctx value msg, Cmd msg )
updateValue value =
    update (OnInput value)


{-| Internal
-}
mapFieldStatus : (FieldStatus.Status -> FieldStatus.Status) -> Model ctx value msg -> Model ctx value msg
mapFieldStatus mapper (Model model) =
    Model { model | fieldStatus = mapper model.fieldStatus }


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


{-| Sets an OnInput side effect.
-}
setOnInput : msg -> Model ctx value msg -> Model ctx value msg
setOnInput msg (Model configuration) =
    Model { configuration | onInput = Just msg }


{-| Return the input value.
-}
getValue : Model ctx value msg -> String
getValue (Model { value }) =
    value


{-| Returns the validated value by running the function you gave to the init.
-}
validate : ctx -> Model ctx value msg -> Result String value
validate ctx (Model { value, validation }) =
    validation ctx value


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
type Config constraints
    = Config
        { additionalContent : Maybe (Html Never)
        , addon : Maybe Addon
        , classList : List ( String, Bool )
        , disabled : Bool
        , hint : Maybe Hint.Config
        , id : String
        , isSubmitted : Bool
        , label : Maybe Label.Config
        , min : Maybe String
        , max : Maybe String
        , name : String
        , placeholder : Maybe String
        , size : Size
        , strategy : Strategy
        , step : Maybe String
        , type_ : Type
        , valueMapper : String -> String
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
        , strategy : CommonsConstraints.Allowed
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
config : Type -> String -> Config constraints
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
        , strategy = Strategy.onBlur
        , type_ = inputType
        , valueMapper = identity
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
type alias DateConfig =
    Config DateConstraints


{-| Email configuration.
-}
type alias EmailConfig =
    Config EmailConstraints


{-| Number configuration.
-}
type alias NumberConfig =
    Config NumberConstraints


{-| Password configuration.
-}
type alias PasswordConfig =
    Config PasswordConstraints


{-| Text configuration.
-}
type alias TextConfig =
    Config TextConstraints


{-| Creates an input with [type="email"].
-}
email : String -> EmailConfig
email =
    config Email


{-| Creates an input with [type="date"].
-}
date : String -> DateConfig
date =
    config Date


{-| Creates an input with [type="number"].
-}
number : String -> NumberConfig
number =
    config Number


{-| Creates an input with [type="text"].
-}
text : String -> TextConfig
text =
    config Text


{-| Creates an input with [type="password"].
-}
password : String -> PasswordConfig
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
    { placement : Placement
    , type_ : AddonType
    }


{-| Internal
-}
addonTypeToString : AddonType -> String
addonTypeToString addonType =
    case addonType of
        IconAddon _ ->
            "icon"

        TextAddon _ ->
            "text"


{-| Creates an Addon with an Icon from our IconSet.
-}
iconAddon : IconSet.Icon -> AddonType
iconAddon =
    IconAddon


{-| Creates an Addon with a String content.
-}
textAddon : String -> AddonType
textAddon =
    TextAddon


{-| Internal.
-}
addonToAttribute : Addon -> Html.Attribute msg
addonToAttribute { type_, placement } =
    [ "form-field--with"
    , Placement.toString placement
    , addonTypeToString type_
    ]
        |> String.join "-"
        |> Html.Attributes.class


{-| Sets the validation strategy (when to show the error, if present)
-}
withStrategy :
    Strategy
    -> Config { c | strategy : CommonsConstraints.Allowed }
    -> Config { c | strategy : CommonsConstraints.Denied }
withStrategy strategy (Config configuration) =
    Config { configuration | strategy = strategy }


{-| Maps the inputted string before the update

    Text.config "id"
        |> Input.withValueMapper String.toUppercase
        |> Input.render Tagger formData model.textModel

In this example, if the user inputs "abc", the actual inputted text is "ABC".
This applies to both the user UI and the `getValue`/`validate` functions

-}
withValueMapper :
    (String -> String)
    -> Config { c | valueMapper : CommonsConstraints.Allowed }
    -> Config { c | valueMapper : CommonsConstraints.Denied }
withValueMapper mapper (Config configData) =
    Config { configData | valueMapper = mapper }


{-| Sets whether the form was submitted
-}
withIsSubmitted :
    Bool
    -> Config { c | isSubmitted : CommonsConstraints.Allowed }
    -> Config { c | isSubmitted : CommonsConstraints.Denied }
withIsSubmitted isSubmitted (Config configuration) =
    Config { configuration | isSubmitted = isSubmitted }


{-| Sets an Addon to the Input.
-}
withAddon :
    Placement
    -> AddonType
    -> Config { c | addon : CommonsConstraints.Allowed }
    -> Config { c | addon : CommonsConstraints.Denied }
withAddon placement type_ (Config configuration) =
    Config { configuration | addon = Just { placement = placement, type_ = type_ } }


{-| Adds a Label to the Input.
-}
withLabel :
    Label.Config
    -> Config { c | label : CommonsConstraints.Allowed }
    -> Config { c | label : CommonsConstraints.Denied }
withLabel a (Config configuration) =
    Config { configuration | label = Just a }


{-| Sets the input as disabled
-}
withDisabled :
    Bool
    -> Config { c | disabled : CommonsConstraints.Allowed }
    -> Config { c | disabled : CommonsConstraints.Denied }
withDisabled isDisabled (Config configuration) =
    Config { configuration | disabled = isDisabled }


{-| Sets the input hint
-}
withHint :
    String
    -> Config { c | hint : CommonsConstraints.Allowed }
    -> Config { c | hint : CommonsConstraints.Denied }
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
    -> Config { c | size : CommonsConstraints.Allowed }
    -> Config { c | size : CommonsConstraints.Denied }
withSize size (Config configuration) =
    Config { configuration | size = size }


{-| Sets a ClassList to the Input.
-}
withClassList :
    List ( String, Bool )
    -> Config { c | classList : CommonsConstraints.Allowed }
    -> Config { c | classList : CommonsConstraints.Denied }
withClassList classes (Config configuration) =
    Config { configuration | classList = classes }


{-| Sets a Max attribute to the Input.
-}
withMax :
    String
    -> Config { c | max : CommonsConstraints.Allowed }
    -> Config { c | max : CommonsConstraints.Denied }
withMax max (Config configuration) =
    Config { configuration | max = Just max }


{-| Sets a Min attribute to the Input.
-}
withMin :
    String
    -> Config { c | min : CommonsConstraints.Allowed }
    -> Config { c | min : CommonsConstraints.Denied }
withMin min (Config configuration) =
    Config { configuration | min = Just min }


{-| Sets a Name to the Input.
-}
withId :
    String
    -> Config { c | id : CommonsConstraints.Allowed }
    -> Config { c | id : CommonsConstraints.Denied }
withId id (Config configuration) =
    Config { configuration | id = id }


{-| Sets a Step to the Input.
-}
withStep :
    String
    -> Config { c | step : CommonsConstraints.Allowed }
    -> Config { c | step : CommonsConstraints.Denied }
withStep step (Config configuration) =
    Config { configuration | step = Just step }


{-| Sets a Placeholder to the Input.
-}
withPlaceholder :
    String
    -> Config { c | placeholder : CommonsConstraints.Allowed }
    -> Config { c | placeholder : CommonsConstraints.Denied }
withPlaceholder placeholder (Config configuration) =
    Config { configuration | placeholder = Just placeholder }


{-| Append an additional custom html.
-}
withAdditionalContent :
    Html Never
    -> Config { c | additionalContent : CommonsConstraints.Allowed }
    -> Config { c | additionalContent : CommonsConstraints.Denied }
withAdditionalContent additionalContent (Config configuration) =
    Config { configuration | additionalContent = Just additionalContent }


{-| Internal
-}
addIconCalendarToDateField : Config constraints -> Config constraints
addIconCalendarToDateField ((Config configData) as config_) =
    case configData.type_ of
        Date ->
            Config { configData | addon = Just { placement = Placement.prepend, type_ = iconAddon IconSet.Calendar } }

        _ ->
            config_


{-| Renders the Input.Stories/Chapters/DateField.elm
-}
render : (Msg -> msg) -> ctx -> Model ctx value msg -> Config constraints -> Html msg
render tagger ctx ((Model modelData) as model) ((Config configData) as config_) =
    let
        shownValidation : Result String ()
        shownValidation =
            StrategyInternal.getShownValidation
                modelData.fieldStatus
                (modelData.validation ctx modelData.value)
                configData.isSubmitted
                configData.strategy
    in
    config_
        |> addIconCalendarToDateField
        |> renderField shownValidation model
        |> Html.map tagger
        |> FormItem.config configData
        |> FormItem.withLabel configData.label
        |> FormItem.withAdditionalContent configData.additionalContent
        |> FormItem.render shownValidation


{-| Internal.
-}
renderField : Result String () -> Model ctx value msg -> Config constraints -> Html Msg
renderField shownValidation model ((Config { disabled, addon }) as configuration) =
    Html.div
        [ Html.Attributes.classList
            [ ( "form-field", True )
            , ( "form-field--error", Result.Extra.isErr shownValidation )
            , ( "form-field--disabled", disabled )
            ]
        , CommonsAttributes.maybe addonToAttribute addon
        ]
        [ addon
            |> Maybe.map (renderAddon shownValidation model configuration)
            |> Maybe.withDefault (renderInput shownValidation model configuration)
        ]


{-| Internal.
-}
renderAddon : Result String () -> Model ctx value msg -> Config constraints -> Addon -> Html Msg
renderAddon validationResult model configuration addon =
    Html.label
        [ Html.Attributes.class "form-field__wrapper" ]
        [ CommonsRender.renderIf (Placement.isPrepend addon.placement) (renderAddonByType addon.type_)
        , renderInput validationResult model configuration
        , CommonsRender.renderIf (Placement.isAppend addon.placement) (renderAddonByType addon.type_)
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
renderInput : Result String () -> Model ctx value msg -> Config constraints -> Html Msg
renderInput validationResult (Model modelData) (Config configData) =
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
