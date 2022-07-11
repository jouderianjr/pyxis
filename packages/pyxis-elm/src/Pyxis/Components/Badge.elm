module Pyxis.Components.Badge exposing
    ( Config
    , neutral
    , brand
    , action
    , success
    , alert
    , error
    , neutralGradient
    , brandGradient
    , ghost
    , withClassList
    , withId
    , withTheme
    , render
    )

{-|


# Badge Component

@docs Config
@docs neutral
@docs brand
@docs action
@docs success
@docs alert
@docs error
@docs neutralGradient
@docs brandGradient
@docs ghost


## Generics

@docs withClassList
@docs withId
@docs withTheme


## Rendering

@docs render

-}

import Html exposing (Html)
import Html.Attributes
import Pyxis.Commons.Alias as CommonsAlias
import Pyxis.Commons.Attributes as CommonsAttributes
import Pyxis.Commons.Properties.Theme as Theme exposing (Theme)


{-| Internal. The internal Badge configuration
-}
type alias ConfigData =
    { classList : List ( String, Bool )
    , id : Maybe CommonsAlias.Id
    , text : String
    , theme : Theme
    , variant : Variant
    }


{-| The view configuration
-}
type Config
    = Config ConfigData


{-| Creates a Badge
-}
config : Variant -> String -> Config
config variant text =
    Config
        { classList = []
        , id = Nothing
        , text = text
        , theme = Theme.default
        , variant = variant
        }


{-| Badge Variants.
-}
type Variant
    = Neutral
    | Brand
    | Action
    | Error
    | Success
    | Alert
    | NeutralGradient
    | BrandGradient
    | Ghost


{-| Creates a neutral Badge.
-}
neutral : String -> Config
neutral =
    config Neutral


{-| Creates a brand Badge.
-}
brand : String -> Config
brand =
    config Brand


{-| Creates an action Badge.
-}
action : String -> Config
action =
    config Action


{-| Creates a success Badge.
-}
success : String -> Config
success =
    config Success


{-| Creates a alert Badge.
-}
alert : String -> Config
alert =
    config Alert


{-| Creates an error Badge.
-}
error : String -> Config
error =
    config Error


{-| Creates a neutral Badge with gradient.
-}
neutralGradient : String -> Config
neutralGradient =
    config NeutralGradient


{-| Creates a brand Badge with gradient.
-}
brandGradient : String -> Config
brandGradient =
    config BrandGradient


{-| Creates a ghost Badge.
-}
ghost : String -> Config
ghost =
    config Ghost


{-| Add a ClassList to Badge
-}
withClassList : List ( String, Bool ) -> Config -> Config
withClassList classList (Config configuration) =
    Config { configuration | classList = classList }


{-| Add `id` and `data-test-id` to Badge.
-}
withId : CommonsAlias.Id -> Config -> Config
withId id (Config configuration) =
    Config { configuration | id = Just id }


{-| Sets a theme to the Badge.
-}
withTheme : Theme -> Config -> Config
withTheme theme (Config configuration) =
    Config { configuration | theme = theme }


{-| Renders the Badge.
-}
render : Config -> Html msg
render (Config { classList, id, text, theme, variant }) =
    Html.span
        [ Html.Attributes.classList
            [ ( "badge", True )
            , ( "badge--neutral-gradient", variant == NeutralGradient )
            , ( "badge--brand", variant == Brand )
            , ( "badge--brand-gradient", variant == BrandGradient )
            , ( "badge--action", variant == Action )
            , ( "badge--success", variant == Success )
            , ( "badge--alert", variant == Alert )
            , ( "badge--error", variant == Error )
            , ( "badge--ghost", variant == Ghost )
            , ( "badge--alt", Theme.isAlternative theme )
            ]
        , Html.Attributes.classList classList
        , CommonsAttributes.maybe Html.Attributes.id id
        , CommonsAttributes.maybe CommonsAttributes.testId id
        ]
        [ Html.text text ]
