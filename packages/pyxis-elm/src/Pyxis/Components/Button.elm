module Pyxis.Components.Button exposing
    ( Config
    , primary
    , secondary
    , tertiary
    , brand
    , ghost
    , Type
    , button
    , submit
    , reset
    , link
    , linkWithTarget
    , withType
    , withTheme
    , withSize
    , huge
    , large
    , medium
    , small
    , withIconAppend
    , withIconOnly
    , withIconPrepend
    , withAriaLabel
    , withClassList
    , withContentWidth
    , withDisabled
    , withId
    , withLoading
    , withOnClick
    , withShadow
    , withTabIndex
    , withText
    , render
    )

{-|


# Button component

@docs Config
@docs primary
@docs secondary
@docs tertiary
@docs brand
@docs ghost


## Type

@docs Type
@docs button
@docs submit
@docs reset
@docs link
@docs linkWithTarget
@docs withType


## Theme

@docs withTheme


## Size

@docs withSize
@docs huge
@docs large
@docs medium
@docs small


## Icon

@docs withIconAppend
@docs withIconOnly
@docs withIconPrepend


## Generics

@docs withAriaLabel
@docs withClassList
@docs withContentWidth
@docs withDisabled
@docs withId
@docs withLoading
@docs withOnClick
@docs withShadow
@docs withTabIndex
@docs withText


## Rendering

@docs render

-}

import Html exposing (Html)
import Html.Attributes
import Html.Events
import Pyxis.Commons.Attributes as CommonsAttributes
import Pyxis.Commons.Attributes.LinkTarget exposing (LinkTarget)
import Pyxis.Commons.Constraints as CommonsConstraints
import Pyxis.Commons.Properties.Placement as Placement exposing (Placement)
import Pyxis.Commons.Properties.Theme as Theme exposing (Theme)
import Pyxis.Commons.Render as CommonsRender
import Pyxis.Components.Icon as Icon
import Pyxis.Components.IconSet as IconSet


{-| Internal. The internal Button configuration.
-}
type alias ConfigData msg =
    { ariaLabel : Maybe String
    , classList : List ( String, Bool )
    , contentWidth : Bool
    , disabled : Bool
    , icon : ButtonIcon
    , id : Maybe String
    , loading : Bool
    , onClick : Maybe msg
    , shadow : Bool
    , size : Size
    , tabIndex : Maybe Int
    , text : String
    , theme : Theme
    , type_ : Type
    , variant : Variant
    }


{-| The Button configuration.
-}
type Config constraints msg
    = Config (ConfigData msg)


{-| Internal. Common attribute constraints
-}
type alias CommonConstraints constraints =
    { constraints
        | ariaLabel : CommonsConstraints.Allowed
        , classList : CommonsConstraints.Allowed
        , disabled : CommonsConstraints.Allowed
        , iconAppend : CommonsConstraints.Allowed
        , iconPrepend : CommonsConstraints.Allowed
        , id : CommonsConstraints.Allowed
        , size : CommonsConstraints.Allowed
        , tabIndex : CommonsConstraints.Allowed
        , sizeSmall : CommonsConstraints.Allowed
        , text : CommonsConstraints.Allowed
        , theme : CommonsConstraints.Allowed
        , type_ : CommonsConstraints.Allowed
    }


{-| Internal. Constraints for Primary Button
-}
type alias PrimaryConstraints =
    CommonConstraints
        { contentWidth : CommonsConstraints.Allowed
        , iconOnly : CommonsConstraints.Allowed
        , loading : CommonsConstraints.Allowed
        , shadow : CommonsConstraints.Allowed
        , sizeHuge : CommonsConstraints.Allowed
        }


{-| Internal. Constraints for Secondary Button
-}
type alias SecondaryConstraints =
    CommonConstraints
        { contentWidth : CommonsConstraints.Allowed
        , iconOnly : CommonsConstraints.Allowed
        , loading : CommonsConstraints.Allowed
        }


{-| Internal. Constraints for Tertiary Button
-}
type alias TertiaryConstraints =
    CommonConstraints
        { contentWidth : CommonsConstraints.Allowed
        , iconOnly : CommonsConstraints.Allowed
        , loading : CommonsConstraints.Allowed
        }


{-| Internal. Constraints for Brand Button
-}
type alias BrandConstraints =
    CommonConstraints
        { contentWidth : CommonsConstraints.Allowed
        , iconOnly : CommonsConstraints.Allowed
        , loading : CommonsConstraints.Allowed
        , shadow : CommonsConstraints.Allowed
        }


{-| Internal. Constraints for Ghost Button
-}
type alias GhostConstraints =
    CommonConstraints
        {}


{-| Inits the Button.

    import MyForm
    import Pyxis.Components.Button as Button

    type Msg
        = OnClick

    myClickableButton : Html Msg
    myClickableButton =
        Button.brand
            |> Button.withTypeButton OnClick
            |> Button.withLargeSize
            |> Button.withText "Click me!"
            |> Button.render

    mySubmitButton : Html Msg
    mySubmitButton =
        Button.primary
            |> Button.withTypeSubmit
            |> Button.withText "Submit form"
            |> Button.withDisabled (not MyForm.canBeSubmitted)
            |> Button.render

-}
config : Variant -> Config constraints msg
config variant =
    Config
        { ariaLabel = Nothing
        , classList = []
        , contentWidth = False
        , disabled = False
        , icon = None
        , id = Nothing
        , loading = False
        , onClick = Nothing
        , shadow = False
        , size = Large
        , tabIndex = Nothing
        , text = ""
        , theme = Theme.default
        , type_ = Button
        , variant = variant
        }


{-| The available Button variant.
-}
type Variant
    = Primary
    | Secondary
    | Tertiary
    | Brand
    | Ghost


{-| Creates a Button with a Primary variant.
-}
primary : Config PrimaryConstraints msg
primary =
    config Primary


{-| Creates a Button with a Secondary variant.
-}
secondary : Config SecondaryConstraints msg
secondary =
    config Secondary


{-| Creates a Button with a Tertiary variant.
-}
tertiary : Config TertiaryConstraints msg
tertiary =
    config Tertiary


{-| Creates a Button with a Brand variant.
-}
brand : Config BrandConstraints msg
brand =
    config Brand


{-| Creates a Button with a Ghost variant.
-}
ghost : Config GhostConstraints msg
ghost =
    config Ghost


{-| The size configuration
-}
type Size
    = Huge
    | Large
    | Medium
    | Small


{-| A huge size
-}
huge :
    Config { c | sizeHuge : CommonsConstraints.Allowed, size : CommonsConstraints.Allowed } msg
    -> Config { c | sizeHuge : CommonsConstraints.Denied, size : CommonsConstraints.Denied } msg
huge (Config configuration) =
    Config { configuration | size = Huge }


{-| A large size
-}
large : Config { c | size : CommonsConstraints.Allowed } msg -> Config { c | size : CommonsConstraints.Denied } msg
large (Config configuration) =
    Config { configuration | size = Large }


{-| A medium size
-}
medium : Config { c | size : CommonsConstraints.Allowed } msg -> Config { c | size : CommonsConstraints.Denied } msg
medium (Config configuration) =
    Config { configuration | size = Medium }


{-| A small size
-}
small :
    Config { c | sizeSmall : CommonsConstraints.Allowed, size : CommonsConstraints.Allowed } msg
    -> Config { c | loading : CommonsConstraints.Denied, iconOnly : CommonsConstraints.Denied, size : CommonsConstraints.Denied } msg
small (Config configuration) =
    Config { configuration | size = Small }


{-| Internal.
-}
type ButtonIcon
    = PlacedIcon Placement IconSet.Icon
    | Standalone IconSet.Icon
    | None


{-| Internal.
-}
isPrepend : ButtonIcon -> Bool
isPrepend buttonIcon =
    case buttonIcon of
        PlacedIcon placement _ ->
            Placement.isPrepend placement

        _ ->
            False


{-| Internal.
-}
isAppend : ButtonIcon -> Bool
isAppend buttonIcon =
    case buttonIcon of
        PlacedIcon placement _ ->
            Placement.isAppend placement

        _ ->
            False


{-| Internal.
-}
isStandalone : ButtonIcon -> Bool
isStandalone buttonIcon =
    case buttonIcon of
        Standalone _ ->
            True

        _ ->
            False


{-| Internal.
-}
pickIcon : ButtonIcon -> Maybe IconSet.Icon
pickIcon buttonIcon =
    case buttonIcon of
        PlacedIcon _ icon ->
            Just icon

        Standalone icon ->
            Just icon

        None ->
            Nothing


{-| The available Button types.
-}
type Type
    = Button
    | Submit
    | Reset
    | Link String (Maybe LinkTarget)


{-| Creates a button with [type="button"].
-}
button : Type
button =
    Button


{-| Creates a button with [type="submit"].
-}
submit : Type
submit =
    Submit


{-| Creates a button with [type="reset"].
-}
reset : Type
reset =
    Reset


{-| Creates an anchor tag with button-like skin.
-}
link : String -> Type
link href =
    Link href Nothing


{-| Creates an anchor tag with button-like skin.
-}
linkWithTarget : String -> LinkTarget -> Type
linkWithTarget href linkTarget =
    Link href (Just linkTarget)


{-| Internal.
-}
isLinkType : Type -> Bool
isLinkType type_ =
    case type_ of
        Link _ _ ->
            True

        _ ->
            False


{-| Sets a type to the Button.
-}
withType :
    Type
    -> Config { c | type_ : CommonsConstraints.Allowed } msg
    -> Config { c | type_ : CommonsConstraints.Denied } msg
withType type_ (Config configuration) =
    Config { configuration | type_ = type_ }


{-| Internal.
-}
typeToAttribute : Type -> List (Html.Attribute msg)
typeToAttribute type_ =
    case type_ of
        Submit ->
            [ Html.Attributes.type_ "submit" ]

        Reset ->
            [ Html.Attributes.type_ "reset" ]

        Button ->
            [ Html.Attributes.type_ "button" ]

        Link href target ->
            [ Html.Attributes.href href
            , CommonsAttributes.maybe CommonsAttributes.target target
            ]


{-| Sets a theme to the Button.
-}
withTheme :
    Theme
    -> Config { c | theme : CommonsConstraints.Allowed } msg
    -> Config { c | theme : CommonsConstraints.Denied } msg
withTheme theme (Config configuration) =
    Config { configuration | theme = theme }


{-| Sets the icon size
-}
withSize :
    (Config before msg -> Config after msg)
    -> Config before msg
    -> Config after msg
withSize setSize =
    setSize


{-| Adds an icon to the Button. The icon will be shown before button's content from ltr.
-}
withIconPrepend :
    IconSet.Icon
    -> Config { c | iconPrepend : CommonsConstraints.Allowed } msg
    -> Config { c | iconPrepend : CommonsConstraints.Denied } msg
withIconPrepend icon (Config configuration) =
    Config { configuration | icon = PlacedIcon Placement.prepend icon }


{-| Adds an icon to the Button. The icon will be shown after button's content from ltr.
-}
withIconAppend :
    IconSet.Icon
    -> Config { c | iconAppend : CommonsConstraints.Allowed } msg
    -> Config { c | iconAppend : CommonsConstraints.Denied } msg
withIconAppend icon (Config configuration) =
    Config { configuration | icon = PlacedIcon Placement.append icon }


{-| Adds an icon to the Button. This will be the only content of the Button.
-}
withIconOnly :
    IconSet.Icon
    -> Config { c | iconOnly : CommonsConstraints.Allowed } msg
    -> Config { c | iconOnly : CommonsConstraints.Denied, sizeSmall : CommonsConstraints.Denied, contentWidth : CommonsConstraints.Denied } msg
withIconOnly icon (Config configuration) =
    Config { configuration | icon = Standalone icon }


{-| Sets whether the Button should be disabled or not.
-}
withDisabled : Bool -> Config { c | disabled : CommonsConstraints.Allowed } msg -> Config { c | disabled : CommonsConstraints.Denied } msg
withDisabled isDisabled (Config configuration) =
    Config { configuration | disabled = isDisabled }


{-| Sets an aria-label to the Button.
-}
withAriaLabel : String -> Config { c | ariaLabel : CommonsConstraints.Allowed } msg -> Config { c | ariaLabel : CommonsConstraints.Denied } msg
withAriaLabel ariaLabel (Config configuration) =
    Config { configuration | ariaLabel = Just ariaLabel }


{-| Sets an id to the Button.
-}
withId : String -> Config { c | id : CommonsConstraints.Allowed } msg -> Config { c | id : CommonsConstraints.Denied } msg
withId id (Config configuration) =
    Config { configuration | id = Just id }


{-| Sets whether the Button should show a loading spinner or not.
-}
withLoading :
    Bool
    -> Config { c | loading : CommonsConstraints.Allowed } msg
    -> Config { c | loading : CommonsConstraints.Denied, sizeSmall : CommonsConstraints.Denied } msg
withLoading isLoading (Config configuration) =
    Config { configuration | loading = isLoading }


{-| Sets whether the Button should have a content width or not.
-}
withContentWidth :
    Config { c | contentWidth : CommonsConstraints.Allowed } msg
    -> Config { c | contentWidth : CommonsConstraints.Denied, iconOnly : CommonsConstraints.Denied } msg
withContentWidth (Config configuration) =
    Config { configuration | contentWidth = True }


{-| Sets whether the Button should have a shadow or not.
-}
withShadow :
    Config { c | shadow : CommonsConstraints.Allowed } msg
    -> Config { c | shadow : CommonsConstraints.Denied } msg
withShadow (Config configuration) =
    Config { configuration | shadow = True }


{-| Adds a tabIndex to the Button.
-}
withTabIndex :
    Int
    -> Config { c | text : CommonsConstraints.Allowed } msg
    -> Config { c | text : CommonsConstraints.Denied } msg
withTabIndex tabIndex (Config configuration) =
    Config { configuration | tabIndex = Just tabIndex }


{-| Adds a textual content to the Button.
-}
withText :
    String
    -> Config { c | text : CommonsConstraints.Allowed } msg
    -> Config { c | text : CommonsConstraints.Denied } msg
withText text (Config configuration) =
    Config { configuration | text = text }


{-| Adds a classList to the Button.
-}
withClassList :
    List ( String, Bool )
    -> Config { c | classList : CommonsConstraints.Allowed } msg
    -> Config { c | classList : CommonsConstraints.Denied } msg
withClassList classList (Config configuration) =
    Config { configuration | classList = classList }


{-| Adds the event onClick to the Button.
-}
withOnClick : msg -> Config constraints msg -> Config a msg
withOnClick onClick (Config configuration) =
    Config { configuration | onClick = Just onClick }


{-| Renders the Button.
-}
render : Config constraints msg -> Html msg
render ((Config configData) as configuration) =
    renderTag
        configuration
        ([ Html.Attributes.classList
            ([ ( "button", True )
             , ( "button--prepend-icon", isPrepend configData.icon )
             , ( "button--append-icon", isAppend configData.icon )
             , ( "button--icon-only", isStandalone configData.icon )
             , ( "button--alt", Theme.isAlternative configData.theme )
             , ( "button--primary", configData.variant == Primary )
             , ( "button--secondary", configData.variant == Secondary )
             , ( "button--tertiary", configData.variant == Tertiary )
             , ( "button--brand", configData.variant == Brand )
             , ( "button--ghost", configData.variant == Ghost )
             , ( "button--huge", configData.size == Huge )
             , ( "button--large", configData.size == Large )
             , ( "button--medium", configData.size == Medium )
             , ( "button--small", configData.size == Small )
             , ( "button--loading", configData.loading )
             , ( "button--content-width", configData.contentWidth )
             , ( "button--shadow", configData.shadow )
             ]
                ++ configData.classList
            )
         , Html.Attributes.disabled configData.disabled
         , CommonsAttributes.maybe Html.Events.onClick configData.onClick
         , CommonsAttributes.maybe Html.Attributes.id configData.id
         , CommonsAttributes.maybe CommonsAttributes.testId configData.id
         , CommonsAttributes.maybe CommonsAttributes.ariaLabel configData.ariaLabel
         , CommonsAttributes.maybe Html.Attributes.tabindex (applyTabIndex configData.tabIndex configData.loading)
         ]
            ++ typeToAttribute configData.type_
        )
        [ configData.icon
            |> renderIcon configData.size
            |> CommonsRender.renderIf (isPrepend configData.icon || isStandalone configData.icon)
        , Html.text configData.text
            |> CommonsRender.renderUnless (isStandalone configData.icon)
        , configData.icon
            |> renderIcon configData.size
            |> CommonsRender.renderIf (isAppend configData.icon)
        ]


{-| Internal.
-}
renderTag : Config constraints msg -> (List (Html.Attribute msg) -> List (Html msg) -> Html msg)
renderTag (Config configData) =
    if isLinkType configData.type_ then
        Html.a

    else
        Html.button


{-| Internal.
-}
renderIcon : Size -> ButtonIcon -> Html msg
renderIcon size icon =
    icon
        |> pickIcon
        |> Maybe.map
            (Icon.config
                >> applyIconSize size
                >> Icon.render
            )
        |> CommonsRender.renderMaybe


{-| Internal.
-}
applyIconSize : Size -> Icon.Config -> Icon.Config
applyIconSize size =
    if size == Huge then
        Icon.withSize Icon.large

    else if size == Large then
        Icon.withSize Icon.medium

    else
        Icon.withSize Icon.small


{-| Internal.
-}
applyTabIndex : Maybe Int -> Bool -> Maybe Int
applyTabIndex maybeTabIndex loading =
    case ( maybeTabIndex, loading ) of
        ( Just tabIndex, False ) ->
            Just tabIndex

        ( _, True ) ->
            Just -1

        _ ->
            Nothing
