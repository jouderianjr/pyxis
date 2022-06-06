module Pyxis.Components.Toggle exposing
    ( Config
    , config
    , withClassList
    , withAriaLabel
    , withDisabled
    , withLabel
    , render
    )

{-|


# Toggle Component

@docs Config
@docs config


## Generics

@docs withClassList
@docs withAriaLabel
@docs withDisabled
@docs withLabel


## Rendering

@docs render

-}

import Html exposing (Html)
import Html.Attributes
import Html.Events
import Pyxis.Commons.Attributes as CommonsAttributes
import Pyxis.Commons.Render as CommonsRender
import Pyxis.Commons.String as CommonsString
import Pyxis.Components.Field.Label as Label


{-| Internal. The internal Toggle configuration.
-}
type alias ConfigData msg =
    { ariaLabel : Maybe String
    , classList : List ( String, Bool )
    , disabled : Bool
    , id : String
    , label : Maybe Label.Config
    , onCheck : Bool -> msg
    }


{-| The Toggle configuration.
-}
type Config msg
    = Config (ConfigData msg)


{-| Inits the Toggle.

    type Msg
            = OnToggle Bool

        toggle : Bool -> Html Msg
        toggle initialState =
            Toggle.config OnToggle
                |> Toggle.render initialState

-}
config : String -> (Bool -> msg) -> Config msg
config id onCheck =
    Config
        { ariaLabel = Nothing
        , classList = []
        , disabled = False
        , id = id
        , label = Nothing
        , onCheck = onCheck
        }


{-| Sets whether the Toggle should be disabled or not.
-}
withDisabled : Bool -> Config msg -> Config msg
withDisabled disabled (Config configuration) =
    Config { configuration | disabled = disabled }


{-| Sets an aria-label to the Toggle.
-}
withAriaLabel : String -> Config msg -> Config msg
withAriaLabel ariaLabel (Config configuration) =
    Config { configuration | ariaLabel = Just ariaLabel }


{-| Adds a textual content to the Toggle.
-}
withLabel : Label.Config -> Config msg -> Config msg
withLabel label (Config configuration) =
    Config { configuration | label = Just label }


{-| Adds a classList to the Toggle.
-}
withClassList : List ( String, Bool ) -> Config msg -> Config msg
withClassList classes (Config configuration) =
    Config { configuration | classList = classes }


{-| Renders the toggle.
-}
render : Bool -> Config msg -> Html msg
render value (Config { ariaLabel, classList, disabled, label, onCheck, id }) =
    Html.div
        [ Html.Attributes.classList
            [ ( "toggle", True )
            , ( "toggle--disabled", disabled )
            ]
        , Html.Attributes.classList classList
        ]
        [ label
            |> Maybe.map (renderLabel id)
            |> CommonsRender.renderMaybe
        , Html.input
            [ Html.Attributes.type_ "checkbox"
            , Html.Attributes.class "toggle__input"
            , Html.Attributes.attribute "aria-checked" (CommonsString.fromBool value)
            , CommonsAttributes.role "switch"
            , Html.Attributes.disabled disabled
            , Html.Attributes.checked value
            , Html.Events.onCheck onCheck
            , Html.Attributes.id id
            , CommonsAttributes.testId id
            , CommonsAttributes.maybe CommonsAttributes.ariaLabel ariaLabel
            ]
            []
        ]


{-| Internal.
-}
renderLabel : String -> Label.Config -> Html msg
renderLabel id label =
    label
        |> Label.withFor id
        |> Label.render
