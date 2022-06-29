module Pyxis.Components.Accordion.Item exposing
    ( Config
    , config
    , withTitle
    , withSubtitle
    , withContent
    , ActionText
    , withActionText
    , withImage
    , withIcon
    , setContentId
    , render
    )

{-|


# Accordion Item


## Configuration

@docs Config
@docs config


## Content

@docs withTitle
@docs withSubtitle
@docs withContent


# Item Addon

@docs ActionText
@docs withActionText
@docs withImage
@docs withIcon


# Generics

@docs setContentId


## Rendering

@docs render

-}

import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Pyxis.Commons.Attributes as CommonsAttributes
import Pyxis.Commons.Render as CommonsRender
import Pyxis.Commons.String as CommonsString
import Pyxis.Components.Icon as Icon
import Pyxis.Components.IconSet as IconSet


{-| Internal. Alias for ActionText.
-}
type alias ActionText =
    { open : String
    , close : String
    }


{-| Internal. Alias for ImageUrl.
-}
type alias ImageUrl =
    String


{-| Addon types.
-}
type AddonType
    = IconAddon IconSet.Icon
    | ImageAddon ImageUrl


{-| Internal. The internal item configuration
-}
type alias ConfigData msg =
    { actionText : Maybe ActionText
    , addon : Maybe AddonType
    , content : List (Html msg)
    , height : Float
    , id : String
    , subtitle : Maybe String
    , title : Maybe String
    }


{-| The item's view configuration
-}
type Config msg
    = Config (ConfigData msg)


{-| Creates an accordion item
-}
config : String -> Config msg
config id =
    Config
        { actionText = Nothing
        , addon = Nothing
        , content = []
        , height = 0
        , id = id
        , subtitle = Nothing
        , title = Nothing
        }


{-| Sets the title.
-}
withTitle : String -> Config msg -> Config msg
withTitle title (Config itemConfig) =
    Config { itemConfig | title = Just title }


{-| Sets the subtitle.
-}
withSubtitle : String -> Config msg -> Config msg
withSubtitle subtitle (Config itemConfig) =
    Config { itemConfig | subtitle = Just subtitle }


{-| Sets the action texts.
-}
withActionText : ActionText -> Config msg -> Config msg
withActionText actionText (Config itemConfig) =
    Config { itemConfig | actionText = Just actionText }


{-| Sets an Icon Addon.
-}
withIcon : IconSet.Icon -> Config msg -> Config msg
withIcon icon (Config itemConfig) =
    Config { itemConfig | addon = IconAddon icon |> Just }


{-| Sets a Text Addon.
-}
withImage : ImageUrl -> Config msg -> Config msg
withImage url (Config itemConfig) =
    Config { itemConfig | addon = ImageAddon url |> Just }


{-| Sets the content.
-}
withContent : List (Html msg) -> Config msg -> Config msg
withContent content (Config itemConfig) =
    Config { itemConfig | content = content }


{-| Internal. The internal render data configuration
-}
type alias RenderData msg =
    { onClick : String -> msg
    , onFocus : String -> msg
    , classList : List ( String, Bool )
    , isOpen : String -> Bool
    , itemsHeight : Dict String Float
    }


{-| Render the accordion item.
-}
render : RenderData msg -> Config msg -> Html.Html msg
render { onClick, onFocus, classList, isOpen, itemsHeight } ((Config { content, id }) as configuration) =
    Html.div
        [ Html.Attributes.class "accordion-item"
        , Html.Attributes.classList classList
        , Html.Attributes.id id
        ]
        [ renderButton (onClick id) (onFocus id) (isOpen id) configuration
        , renderSection (isOpen id) id content itemsHeight
        ]


{-| Internal. Render subtitle.
-}
renderTitle : String -> Html msg
renderTitle title =
    Html.div
        [ Html.Attributes.class "accordion-item__header__title" ]
        [ Html.text title ]


{-| Internal. Render subtitle.
-}
renderSubtitle : String -> Html msg
renderSubtitle subtitle =
    Html.div
        [ Html.Attributes.class "accordion-item__header__subtitle" ]
        [ Html.text subtitle ]


{-| Internal. Render action text.
-}
renderActionText : Bool -> ActionText -> Html msg
renderActionText open actionTexts =
    Html.span
        [ Html.Attributes.class "accordion-item__header__action-label" ]
        [ Html.text
            (if open then
                actionTexts.close

             else
                actionTexts.open
            )
        ]


{-| Internal. Render an Addon by type.
-}
renderAddonByType : AddonType -> Html msg
renderAddonByType type_ =
    case type_ of
        IconAddon icon ->
            Html.div
                [ Html.Attributes.class "accordion-item__header__addon" ]
                [ icon
                    |> Icon.config
                    |> Icon.withSize Icon.large
                    |> Icon.render
                ]

        ImageAddon url ->
            Html.div
                [ Html.Attributes.class "accordion-item__header__addon" ]
                [ Html.img
                    [ Html.Attributes.src url
                    , Html.Attributes.height 60
                    , Html.Attributes.width 60
                    ]
                    []
                ]


{-| Internal. Render accordion item button
-}
renderButton : msg -> msg -> Bool -> Config msg -> Html msg
renderButton onClick onFocus open (Config { title, subtitle, actionText, addon, id }) =
    Html.h6
        []
        [ Html.button
            [ Html.Attributes.class "accordion-item__header"
            , Html.Attributes.attribute "aria-controls" (setSectionId id)
            , Html.Attributes.attribute "aria-expanded" (CommonsString.fromBool open)
            , Html.Attributes.id (setHeaderId id)
            , Html.Events.onClick onClick
            , Html.Events.onFocus onFocus
            ]
            [ addon
                |> Maybe.map renderAddonByType
                |> CommonsRender.renderMaybe
            , Html.div
                [ Html.Attributes.class "accordion-item__header__content-wrapper" ]
                [ title
                    |> Maybe.map renderTitle
                    |> CommonsRender.renderMaybe
                , subtitle
                    |> Maybe.map renderSubtitle
                    |> CommonsRender.renderMaybe
                ]
            , Html.div
                [ Html.Attributes.class "accordion-item__header__action-wrapper" ]
                [ actionText
                    |> Maybe.map (renderActionText open)
                    |> CommonsRender.renderMaybe
                , Html.span
                    [ Html.Attributes.class "accordion-item__header__action-icon"
                    , Html.Attributes.classList [ ( "accordion-item__header__action-icon--open", open ) ]
                    ]
                    [ Icon.config IconSet.ChevronDown
                        |> Icon.withSize Icon.large
                        |> Icon.render
                    ]
                ]
            ]
        ]


{-| Internal. Render accordion item section
-}
renderSection : Bool -> String -> List (Html msg) -> Dict String Float -> Html msg
renderSection open id content itemsHeight =
    Html.section
        [ Html.Attributes.class "accordion-item__panel"
        , Html.Attributes.classList [ ( "accordion-item__panel--open", open ) ]
        , CommonsAttributes.ariaLabelledbyBy (setHeaderId id)
        , Html.Attributes.id (setSectionId id)
        , Html.Attributes.style "max-height" (setMaxHeight open id itemsHeight ++ "px")
        ]
        [ Html.div
            [ Html.Attributes.class "accordion-item__panel__inner-wrapper"
            , Html.Attributes.id (setContentId id)
            ]
            content
        ]


{-| Internal. Set item content height if accordion is open.
-}
setMaxHeight : Bool -> String -> Dict String Float -> String
setMaxHeight open id itemsHeight =
    if open then
        Dict.get id itemsHeight
            |> Maybe.map String.fromFloat
            |> Maybe.withDefault ""

    else
        "0"


{-| Internal. Generate accordion section id.
-}
setHeaderId : String -> String
setHeaderId id =
    CommonsString.toKebabCase (id ++ "-header")


{-| Internal. Generate accordion section id.
-}
setSectionId : String -> String
setSectionId id =
    CommonsString.toKebabCase (id ++ "-section")


{-| Generate accordion content id.
-}
setContentId : String -> String
setContentId id =
    CommonsString.toKebabCase (id ++ "-content")
