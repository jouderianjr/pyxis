module Pyxis.Components.Form.Legend exposing
    ( Config
    , config
    , iconAddon
    , imageAddon
    , withAddon
    , withDescription
    , withAlignmentLeft
    , render
    )

{-|


# Legend

@docs Config
@docs config


## Addons

@docs iconAddon
@docs imageAddon
@docs withAddon


## Generics

@docs withDescription
@docs withAlignmentLeft


## Rendering

@docs render

-}

import Html exposing (Html)
import Html.Attributes
import Pyxis.Commons.Render as CommonsRender
import Pyxis.Components.Icon as Icon
import Pyxis.Components.IconSet as IconSet


{-| Represents a Legend and its contents.
-}
type Config msg
    = Config ConfigData


{-| Represents the Addon type
-}
type AddonType
    = IconAddon IconSet.Icon
    | ImageAddon String


{-| Internal.
-}
type alias ImageUrl =
    String


{-| Represents the alignment of Legend
-}
type Alignment
    = Center
    | Left


{-| Align the content to left.
-}
isAlignedLeft : Alignment -> Bool
isAlignedLeft =
    (==) Left


{-| Creates an Addon with an Icon from our IconSet.
-}
iconAddon : IconSet.Icon -> AddonType
iconAddon =
    IconAddon


{-| Creates an Addon with an Image
-}
imageAddon : ImageUrl -> AddonType
imageAddon =
    ImageAddon


{-| Internal.
-}
type alias ConfigData =
    { addon : Maybe AddonType
    , title : String
    , alignment : Alignment
    , description : Maybe String
    }


{-| Creates a FieldSet with an empty legend.
-}
config : String -> Config msg
config title =
    Config
        { addon = Nothing
        , title = title
        , alignment = Center
        , description = Nothing
        }


{-| Adds a description to the Legend.
-}
withDescription : String -> Config msg -> Config msg
withDescription text (Config configuration) =
    Config { configuration | description = Just text }


{-| Adds a left alignment to the Legend.
-}
withAlignmentLeft : Config msg -> Config msg
withAlignmentLeft (Config configuration) =
    Config { configuration | alignment = Left }


{-| Sets an Addon by type to the Legend.
-}
withAddon : AddonType -> Config msg -> Config msg
withAddon type_ (Config configuration) =
    Config { configuration | addon = Just type_ }


{-| Internal.
-}
render : Config msg -> Html msg
render (Config configuration) =
    Html.legend
        [ Html.Attributes.classList
            [ ( "form-legend", True )
            , ( "form-legend--align-left", isAlignedLeft configuration.alignment )
            ]
        ]
        [ configuration.addon
            |> Maybe.map renderAddonByType
            |> CommonsRender.renderMaybe
        , renderTitle configuration.title
        , configuration.description
            |> Maybe.map renderDescription
            |> CommonsRender.renderMaybe
        ]


{-| Internal.
-}
renderAddonByType : AddonType -> Html msg
renderAddonByType type_ =
    case type_ of
        IconAddon icon ->
            Html.div
                [ Html.Attributes.class "form-legend__addon" ]
                [ icon
                    |> Icon.config
                    |> Icon.withStyle Icon.brand
                    |> Icon.render
                ]

        ImageAddon url ->
            Html.span
                [ Html.Attributes.class "form-legend__addon" ]
                [ Html.img
                    [ Html.Attributes.src url
                    , Html.Attributes.height 80
                    ]
                    []
                ]


{-| Internal.
-}
renderTitle : String -> Html msg
renderTitle str =
    Html.span
        [ Html.Attributes.class "form-legend__title" ]
        [ Html.text str ]


{-| Internal.
-}
renderDescription : String -> Html msg
renderDescription str =
    Html.span
        [ Html.Attributes.class "form-legend__text" ]
        [ Html.text str ]
