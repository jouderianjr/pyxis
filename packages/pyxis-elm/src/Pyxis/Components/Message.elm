module Pyxis.Components.Message exposing
    ( Config
    , neutral
    , brand
    , success
    , alert
    , error
    , ghost
    , Style
    , defaultBackground
    , coloredBackground
    , withClassList
    , withContent
    , withIcon
    , withId
    , withOnDismiss
    , withTitle
    , render
    )

{-|


# Message Component

@docs Config
@docs neutral
@docs brand
@docs success
@docs alert
@docs error
@docs ghost


## Style

@docs Style
@docs defaultBackground
@docs coloredBackground


## Generics

@docs withClassList
@docs withContent
@docs withIcon
@docs withId
@docs withOnDismiss
@docs withTitle


## Rendering

@docs render

-}

import Html exposing (Html)
import Html.Attributes
import Html.Events
import Pyxis.Commons.Attributes as CommonsAttributes
import Pyxis.Commons.Render as CommonsRender
import Pyxis.Components.Icon as Icon
import Pyxis.Components.IconSet as IconSet


{-| Internal. The internal Message configuration
-}
type alias ConfigData msg =
    { classList : List ( String, Bool )
    , content : List (Html msg)
    , icon : IconSet.Icon
    , id : Maybe String
    , onDismiss : Maybe (DismissData msg)
    , title : Maybe String
    , style : Style
    , variant : Variant
    }


{-| The message model
-}
type Config msg
    = Config (ConfigData msg)


{-| Creates a message
-}
config : Variant -> Style -> Config msg
config variant style =
    Config
        { classList = []
        , content = []
        , icon = defaultIcon variant
        , id = Nothing
        , onDismiss = Nothing
        , title = Nothing
        , variant = variant
        , style = style
        }


{-| Available Variants.
-}
type Variant
    = Neutral
    | Brand
    | Alert
    | Success
    | Error
    | Ghost


{-| Available Styles.
-}
type Style
    = Default
    | ColoredBackground


{-| Creates a neutral Message.
-}
neutral : Config msg
neutral =
    config Neutral Default


{-| Creates a brand Message.
-}
brand : Style -> Config msg
brand style =
    config Brand style


{-| Creates a success Message.
-}
success : Style -> Config msg
success style =
    config Success style


{-| Creates a error Message.
-}
error : Style -> Config msg
error style =
    config Error style


{-| Creates a Message with background color alert.
-}
alert : Config msg
alert =
    config Alert ColoredBackground


{-| Creates a Ghost Message.
-}
ghost : Config msg
ghost =
    config Ghost Default


{-| A message with the default grey background.
-}
defaultBackground : Style
defaultBackground =
    Default


{-| A message with a colored background
-}
coloredBackground : Style
coloredBackground =
    ColoredBackground


{-| Add text content to Message.
-}
withContent : List (Html msg) -> Config msg -> Config msg
withContent htmlText (Config configuration) =
    Config { configuration | content = htmlText }


{-| Add a title to Message.
-}
withTitle : String -> Config msg -> Config msg
withTitle title (Config configuration) =
    Config { configuration | title = Just title }


{-| Add a custom icon to Message that replaces the default one.
-}
withIcon : IconSet.Icon -> Config msg -> Config msg
withIcon icon (Config configuration) =
    Config { configuration | icon = icon }


{-| The internal configuration for a dismissible message
-}
type alias DismissData msg =
    { onDismiss : msg
    , ariaLabel : String
    }


{-| Add the configuration for a dismissible message,
-}
withOnDismiss : msg -> String -> Config msg -> Config msg
withOnDismiss onDismiss ariaLabel (Config configuration) =
    Config { configuration | onDismiss = Just { onDismiss = onDismiss, ariaLabel = ariaLabel } }


{-| Add a ClassList to Message
-}
withClassList : List ( String, Bool ) -> Config msg -> Config msg
withClassList classList (Config configuration) =
    Config { configuration | classList = classList }


{-| Add `id` and `data-test-id` to Message.
-}
withId : String -> Config msg -> Config msg
withId id (Config configuration) =
    Config { configuration | id = Just id }


{-| Internal.
-}
getRole : Variant -> String
getRole variant =
    if variant == Error then
        "alert"

    else
        "status"


{-| Internal.
-}
defaultIcon : Variant -> IconSet.Icon
defaultIcon variant =
    case variant of
        Brand ->
            IconSet.ThumbUp

        Success ->
            IconSet.CheckCircle

        Alert ->
            IconSet.Alert

        Error ->
            IconSet.ExclamationCircle

        _ ->
            IconSet.InfoCircle


{-| Renders the Message.
-}
render : Config msg -> Html msg
render (Config { classList, icon, id, content, title, onDismiss, style, variant }) =
    Html.div
        [ Html.Attributes.classList
            [ ( "message", True )
            , ( "message--with-background-color", style == ColoredBackground )
            , ( "message--brand", variant == Brand )
            , ( "message--success", variant == Success )
            , ( "message--alert", variant == Alert )
            , ( "message--error", variant == Error )
            , ( "message--ghost", variant == Ghost )
            ]
        , Html.Attributes.classList classList
        , CommonsAttributes.maybe Html.Attributes.id id
        , CommonsAttributes.maybe CommonsAttributes.testId id
        , CommonsAttributes.role (getRole variant)
        ]
        [ Html.div
            [ Html.Attributes.class "message__icon", CommonsAttributes.testId (IconSet.toLabel icon) ]
            [ icon
                |> Icon.config
                |> Icon.render
            ]
        , Html.div
            [ Html.Attributes.class "message__content-wrapper" ]
            [ title
                |> Maybe.map renderTitle
                |> CommonsRender.renderMaybe
            , Html.div
                [ Html.Attributes.class "message__text" ]
                content
            ]
        , onDismiss
            |> Maybe.map renderClose
            |> CommonsRender.renderMaybe
        ]


{-| Internal.
-}
renderTitle : String -> Html msg
renderTitle title =
    Html.div [ Html.Attributes.class "message__title" ] [ Html.text title ]


{-| Internal.
-}
renderClose : DismissData msg -> Html msg
renderClose { onDismiss, ariaLabel } =
    Html.button
        [ Html.Attributes.class "message__close"
        , Html.Attributes.type_ "button"
        , Html.Events.onClick onDismiss
        , CommonsAttributes.ariaLabel ariaLabel
        ]
        [ IconSet.Close
            |> Icon.config
            |> Icon.withSize Icon.small
            |> Icon.render
        ]
