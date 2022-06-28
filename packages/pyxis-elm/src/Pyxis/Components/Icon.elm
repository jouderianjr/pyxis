module Pyxis.Components.Icon exposing
    ( Config
    , config
    , withTheme
    , small
    , medium
    , large
    , Size
    , withSize
    , Style
    , default
    , neutral
    , brand
    , success
    , alert
    , error
    , withStyle
    , withDescription
    , withClassList
    , render
    )

{-|


# Icon component

@docs Config
@docs config


## Theme

@docs withTheme


## Size

@docs small
@docs medium
@docs large
@docs Size
@docs withSize


## Style

@docs Style
@docs default
@docs neutral
@docs brand
@docs success
@docs alert
@docs error
@docs withStyle


## Generics

@docs withDescription
@docs withClassList


## Rendering

@docs render

-}

import Html exposing (Html)
import Html.Attributes
import Maybe.Extra
import Pyxis.Commons.Attributes as CommonsAttributes
import Pyxis.Commons.Properties.Theme as Theme exposing (Theme)
import Pyxis.Commons.Render as CommonsRender
import Pyxis.Components.IconSet as IconSet
import SvgParser


{-| The Icon model.
-}
type Config
    = Config
        { classList : List ( String, Bool )
        , description : Maybe String
        , icon : IconSet.Icon
        , size : Size
        , style : Style
        , theme : Theme
        }


{-| Icon size
-}
type Size
    = Small
    | Medium
    | Large


{-| Icon size small
-}
small : Size
small =
    Small


{-| Icon size medium
-}
medium : Size
medium =
    Medium


{-| Icon size large
-}
large : Size
large =
    Large


{-| Inits the Icon.
-}
config : IconSet.Icon -> Config
config icon =
    Config
        { classList = []
        , description = Nothing
        , icon = icon
        , size = Medium
        , style = Default
        , theme = Theme.default
        }


{-| Sets a theme to the Icon.
-}
withTheme : Theme -> Config -> Config
withTheme a (Config configuration) =
    Config { configuration | theme = a }


{-| Sets a large size to the Icon.
-}
withSize : Size -> Config -> Config
withSize a (Config configuration) =
    Config { configuration | size = a }


{-| The available Icon styles.
-}
type Style
    = Default
    | Boxed Variant


{-| The available Icon variants.
-}
type Variant
    = Neutral
    | Brand
    | Success
    | Alert
    | Error


{-| Creates a Default style.
-}
default : Style
default =
    Default


{-| Creates a Neutral style.
-}
neutral : Style
neutral =
    Boxed Neutral


{-| Creates a Brand style.
-}
brand : Style
brand =
    Boxed Brand


{-| Creates a Success style.
-}
success : Style
success =
    Boxed Success


{-| Creates a Alert style.
-}
alert : Style
alert =
    Boxed Alert


{-| Sets a default style to the Icon.
-}
withStyle : Style -> Config -> Config
withStyle a (Config configuration) =
    Config { configuration | style = a }


{-| Represent a error style for the Icon.
-}
error : Style
error =
    Boxed Error


{-| Adds an accessible text to the Icon.
-}
withDescription : String -> Config -> Config
withDescription a (Config configuration) =
    Config { configuration | description = Just a }


{-| Adds a classList to the Icon.
-}
withClassList : List ( String, Bool ) -> Config -> Config
withClassList a (Config configuration) =
    Config { configuration | classList = a }


{-| Internal.
-}
isBoxed : Style -> Bool
isBoxed style =
    case style of
        Boxed _ ->
            True

        _ ->
            False


{-| Renders the Icon.
-}
render : Config -> Html msg
render (Config configData) =
    Html.div
        [ Html.Attributes.classList
            ([ ( "icon", True )
             , ( "icon--size-l", Large == configData.size )
             , ( "icon--size-m", Medium == configData.size )
             , ( "icon--size-s", Small == configData.size )
             , ( "icon--boxed", isBoxed configData.style || Theme.isAlternative configData.theme )
             , ( "icon--brand", configData.style == brand )
             , ( "icon--success", configData.style == success )
             , ( "icon--alert", configData.style == alert )
             , ( "icon--error", configData.style == error )
             , ( "icon--alt", Theme.isAlternative configData.theme )
             ]
                ++ configData.classList
            )
        , CommonsAttributes.ariaHidden (Maybe.Extra.isNothing configData.description)
        , CommonsAttributes.maybe CommonsAttributes.ariaLabel configData.description
        , CommonsAttributes.renderIf (Maybe.Extra.isJust configData.description) (CommonsAttributes.role "img")
        ]
        [ configData.icon
            |> IconSet.toString
            |> SvgParser.parse
            |> Result.toMaybe
            |> CommonsRender.renderMaybe
        ]
