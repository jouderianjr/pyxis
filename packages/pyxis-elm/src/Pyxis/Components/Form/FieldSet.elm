module Pyxis.Components.Form.FieldSet exposing
    ( Config
    , config
    , withHeader
    , withContent
    , withFooter
    , render
    )

{-|


# FieldSet

@docs Config
@docs config


## General

@docs withHeader
@docs withContent
@docs withFooter


## Rendering

@docs render

-}

import Html exposing (Html)
import Html.Attributes
import Pyxis.Components.Form.Grid as Grid


{-| Represents a FieldSet and its contents.
-}
type Config msg
    = Config (ConfigData msg)


{-| Internal.
-}
type alias ConfigData msg =
    { header : List (Grid.Row msg)
    , content : List (Grid.Row msg)
    , footer : List (Grid.Row msg)
    }


{-| Creates a FieldSet.
-}
config : Config msg
config =
    Config
        { header = []
        , content = []
        , footer = []
        }


{-| Adds a Grid to the FieldSet's header.
-}
withHeader : List (Grid.Row msg) -> Config msg -> Config msg
withHeader rows (Config configuration) =
    Config { configuration | header = rows }


{-| Adds a Grid to the FieldSet's content.
-}
withContent : List (Grid.Row msg) -> Config msg -> Config msg
withContent grid (Config configuration) =
    Config { configuration | content = grid }


{-| Adds a Grid to the FieldSet's footer.
-}
withFooter : List (Grid.Row msg) -> Config msg -> Config msg
withFooter rows (Config configuration) =
    Config { configuration | footer = rows }


{-| Renders the FieldSet.
-}
render : Config msg -> Html msg
render (Config configuration) =
    Html.fieldset
        [ Html.Attributes.class "form-fieldset" ]
        [ Grid.render
            [ Grid.largeGap ]
            (configuration.header ++ renderContent configuration ++ configuration.footer)
        ]


{-| Internal.
-}
renderContent : ConfigData msg -> List (Grid.Row msg)
renderContent configuration =
    [ Grid.oneColRowFullWidth
        [ Grid.render
            [ Grid.smallGap ]
            configuration.content
        ]
    ]
