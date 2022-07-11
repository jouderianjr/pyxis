module Pyxis.Components.TextSwitch exposing
    ( Config
    , config
    , Option
    , option
    , withOptions
    , contentWidth
    , equalWidth
    , withOptionsWidth
    , withClassList
    , withId
    , withAriaLabel
    , withLabel
    , left
    , topCenter
    , topLeft
    , withLabelPosition
    , withTheme
    , render
    )

{-|


# TextSwitch Component


## Config

@docs Config
@docs config


## Options

@docs Option
@docs option
@docs withOptions
@docs contentWidth
@docs equalWidth
@docs withOptionsWidth


## Generics

@docs withClassList
@docs withId
@docs withAriaLabel
@docs withLabel
@docs left
@docs topCenter
@docs topLeft
@docs withLabelPosition
@docs withTheme


## Rendering

@docs render

-}

import Html
import Html.Attributes
import Html.Events
import Maybe.Extra
import Pyxis.Commons.Alias as CommonsAlias
import Pyxis.Commons.Attributes as CommonsAttributes
import Pyxis.Commons.Properties.Theme as Theme exposing (Theme)
import Pyxis.Commons.Render as CommonsRender


{-| The TextSwitch configuration.
-}
type Config value msg
    = Config (ConfigData value msg)


{-| Internal. The internal TextSwitch configuration.
-}
type alias ConfigData value msg =
    { ariaLabel : Maybe String
    , classList : List ( String, Bool )
    , id : CommonsAlias.Id
    , label : Maybe String
    , labelPosition : LabelPosition
    , name : CommonsAlias.Name
    , onChange : value -> msg
    , options : List (Option value)
    , optionsWidth : OptionsWidth
    , theme : Theme
    }


{-| Initialize the TextSwitch Config.
-}
config : CommonsAlias.Name -> (value -> msg) -> Config value msg
config name onChange =
    Config
        { ariaLabel = Nothing
        , classList = []
        , id = "id-" ++ name
        , label = Nothing
        , labelPosition = TopCenter
        , name = name
        , onChange = onChange
        , options = []
        , optionsWidth = ContentWidth
        , theme = Theme.default
        }


{-| How to set the width of all the options.
-}
type OptionsWidth
    = ContentWidth
    | EqualWidth


{-| Sets the type of width for the options of the TextSwitch.
-}
withOptionsWidth : OptionsWidth -> Config value msg -> Config value msg
withOptionsWidth optionWidth (Config configuration) =
    Config { configuration | optionsWidth = optionWidth }


{-| Width of the options based on their content.
-}
contentWidth : OptionsWidth
contentWidth =
    ContentWidth


{-| All the options have the same width.
-}
equalWidth : OptionsWidth
equalWidth =
    EqualWidth


{-| Sets an id to the TextSwitch.
-}
withId : CommonsAlias.Id -> Config value msg -> Config value msg
withId id (Config configuration) =
    Config { configuration | id = id }


{-| Adds a classList to the TextSwitch.
-}
withClassList : List ( String, Bool ) -> Config value msg -> Config value msg
withClassList classes (Config configuration) =
    Config { configuration | classList = classes }


{-| Adds an aria-label to the TextSwitch.
-}
withAriaLabel : String -> Config value msg -> Config value msg
withAriaLabel label (Config configuration) =
    Config { configuration | ariaLabel = Just label }


{-| Adds a label to the TextSwitch.
-}
withLabel : String -> Config value msg -> Config value msg
withLabel label (Config configuration) =
    Config { configuration | label = Just label }


type LabelPosition
    = TopCenter
    | TopLeft
    | Left


{-| Label is on top center position.
-}
topCenter : LabelPosition
topCenter =
    TopCenter


{-| Label is on top left position.
-}
topLeft : LabelPosition
topLeft =
    TopLeft


{-| Label is on the left.
-}
left : LabelPosition
left =
    Left


{-| Sets the position of the label.
-}
withLabelPosition : LabelPosition -> Config value msg -> Config value msg
withLabelPosition position (Config configuration) =
    Config { configuration | labelPosition = position }


{-| Represent the single Option.
-}
type Option value
    = Option (OptionConfig value)


{-| Internal.
-}
type alias OptionConfig value =
    { value : value
    , label : String
    }


{-| Generate an Option
-}
option : OptionConfig value -> Option value
option =
    Option


{-| Adds options to the TextSwitch.
-}
withOptions : List (Option value) -> Config value msg -> Config value msg
withOptions options (Config configuration) =
    Config { configuration | options = options }


{-| Sets a theme to the TextSwitch.
-}
withTheme : Theme -> Config value msg -> Config value msg
withTheme theme (Config configuration) =
    Config { configuration | theme = theme }


{-| Renders the TextSwitch.
-}
render : value -> Config value msg -> Html.Html msg
render selectedValue ((Config { ariaLabel, id, label, classList, labelPosition, options, optionsWidth, theme }) as configuration) =
    Html.div
        [ Html.Attributes.classList
            [ ( "text-switch-wrapper", True )
            , ( "text-switch-wrapper--alt", Theme.isAlternative theme )
            , ( "text-switch-wrapper--left-label", labelPosition == Left )
            , ( "text-switch-wrapper--top-left-label", labelPosition == TopLeft )
            ]
        , Html.Attributes.classList classList
        , Html.Attributes.id id
        , CommonsAttributes.testId id
        ]
        [ label
            |> Maybe.map (renderLabel id)
            |> CommonsRender.renderMaybe
        , Html.div
            [ Html.Attributes.classList
                [ ( "text-switch", True )
                , ( "text-switch--equal-option-width", optionsWidth == EqualWidth )
                ]
            , CommonsAttributes.role "radiogroup"
            , CommonsAttributes.maybe CommonsAttributes.ariaLabel ariaLabel
            , id
                |> labelId
                |> CommonsAttributes.ariaLabelledbyBy
                |> CommonsAttributes.renderIf (Maybe.Extra.isJust label)
            ]
            (List.indexedMap (renderOption selectedValue configuration) options)
        ]


{-| Internal.
-}
renderLabel : CommonsAlias.Id -> String -> Html.Html msg
renderLabel id label =
    Html.label
        [ Html.Attributes.class "text-switch__label"
        , labelId id |> Html.Attributes.id
        ]
        [ Html.text label ]


{-| Internal.
-}
renderOption : value -> Config value msg -> Int -> Option value -> Html.Html msg
renderOption selectedValue (Config { id, name, onChange }) index (Option { value, label }) =
    Html.label
        [ Html.Attributes.classList
            [ ( "text-switch__option", True )
            , ( "text-switch__option--checked", selectedValue == value )
            , ( "text-switch__option--checked-no-transition", selectedValue == value )
            ]
        ]
        [ Html.input
            [ Html.Attributes.type_ "radio"
            , Html.Attributes.class "text-switch__option-input"
            , Html.Attributes.checked (selectedValue == value)
            , Html.Attributes.id (optionId id index)
            , CommonsAttributes.testId (optionId id index)
            , Html.Attributes.name name
            , Html.Events.onCheck (always (onChange value))
            ]
            []
        , Html.text label
        ]


{-| Internal.
-}
optionId : CommonsAlias.Id -> Int -> String
optionId id index =
    [ id, "option", String.fromInt index ]
        |> String.join "-"


{-| Internal.
-}
labelId : CommonsAlias.Id -> String
labelId id =
    id ++ "-label"
