module Pyxis.Components.Field.Label exposing
    ( Config
    , config
    , withFor
    , withId
    , withSubText
    , withClassList
    , small
    , medium
    , Size
    , withSize
    , render
    )

{-|


# Label component


## Configuration

@docs Config
@docs config


## Generics

@docs withFor
@docs withId
@docs withSubText
@docs withClassList


## Size

@docs small
@docs medium
@docs Size
@docs withSize


## Rendering

@docs render

-}

import Html exposing (Html)
import Html.Attributes
import Pyxis.Commons.Alias as CommonsAlias
import Pyxis.Commons.Attributes as CommonsAttributes
import Pyxis.Commons.Render as CommonsRender


{-| Label size
-}
type Size
    = Small
    | Medium


{-| Label size small
-}
small : Size
small =
    Small


{-| Label size medium
-}
medium : Size
medium =
    Medium


{-| The Label model.
-}
type Config
    = Config Configuration


{-| Internal. The internal Label configuration.
-}
type alias Configuration =
    { classList : List ( String, Bool )
    , for : Maybe String
    , id : Maybe CommonsAlias.Id
    , size : Size
    , subText : Maybe String
    , text : String
    }


{-| Inits the Label.

    import Pyxis.Components.Field.Label as Label

    myLabel : Html msg
    myLabel =
        Label.config "My custom label"
            |> Label.render

-}
config : String -> Config
config text =
    Config
        { classList = []
        , for = Nothing
        , id = Nothing
        , size = Medium
        , subText = Nothing
        , text = text
        }


{-| Add a `for` attribute to label.

    import Pyxis.Components.Field.Label as Label

    myLabel : Html msg
    myLabel =
        Label.config "My custom label"
            |> Label.withFor "input-id"
            |> Label.render

-}
withFor : CommonsAlias.Id -> Config -> Config
withFor for (Config configuration) =
    Config { configuration | for = Just for }


{-| Add `id` and `data-test-id` attributes to label.

    import Pyxis.Components.Field.Label as Label

    myLabel : Html msg
    myLabel =
        Label.config "My custom label"
            |> Label.withId "label-id"
            |> Label.render

-}
withId : CommonsAlias.Id -> Config -> Config
withId id (Config configuration) =
    Config { configuration | id = Just id }


{-| Add a list of conditional classes for label.

    import Pyxis.Components.Field.Label as Label

    myLabel : Html msg
    myLabel =
        Label.config "My custom label"
            |> Label.withClassList [ ( "my-label-class", True ), ( "another-class", True ) ]
            |> Label.render

-}
withClassList : List ( String, Bool ) -> Config -> Config
withClassList classList (Config configuration) =
    Config { configuration | classList = classList }


{-| Set label to small size.

    import Pyxis.Components.Field.Label as Label

    myLabel : Html msg
    myLabel =
        Label.config "My custom label"
            |> Label.withSize Size.small
            |> Label.render

-}
withSize : Size -> Config -> Config
withSize a (Config configuration) =
    Config { configuration | size = a }


{-| Set a sub-level text for label.

    import Pyxis.Components.Field.Label as Label

    myLabel : Html msg
    myLabel =
        Label.config "My custom label"
            |> Label.withSubText "This is a sub-level text"
            |> Label.render

-}
withSubText : String -> Config -> Config
withSubText text (Config configuration) =
    Config { configuration | subText = Just text }


{-| Renders the Label.
-}
render : Config -> Html msg
render (Config { for, classList, id, size, text, subText }) =
    Html.label
        [ Html.Attributes.classList
            [ ( "form-label", True )
            , ( "form-label--small", size == Small )
            ]
        , Html.Attributes.classList classList
        , CommonsAttributes.maybe Html.Attributes.for for
        , CommonsAttributes.maybe Html.Attributes.id id
        , CommonsAttributes.maybe CommonsAttributes.testId id
        ]
        [ Html.text text
        , subText
            |> Maybe.map renderSubText
            |> CommonsRender.renderMaybe
        ]


{-| Internal.
-}
renderSubText : String -> Html msg
renderSubText subText =
    Html.small [ Html.Attributes.class "form-label__sub" ] [ Html.text subText ]
