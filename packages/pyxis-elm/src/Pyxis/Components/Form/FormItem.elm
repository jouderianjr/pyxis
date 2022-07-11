module Pyxis.Components.Form.FormItem exposing
    ( PartialFieldConfig
    , config
    , withAdditionalContent
    , withLabel
    , render
    )

{-|


# FormItem component


## Config

@docs PartialFieldConfig
@docs config


## Generics

@docs withAdditionalContent
@docs withLabel


## Rendering

@docs render

-}

import Html exposing (Html)
import Html.Attributes
import Maybe.Extra
import Pyxis.Commons.Alias as CommonsAlias
import Pyxis.Commons.Render as CommonsRender
import Pyxis.Components.Field.Error as Error
import Pyxis.Components.Field.Hint as Hint
import Pyxis.Components.Field.Label as Label


{-| Partial representation of the field configuration
-}
type alias PartialFieldConfig a =
    { a
        | id : CommonsAlias.Id
        , hint : Maybe Hint.Config
    }


{-| Internal.
-}
type Config a msg
    = Config
        { additionalContent : Maybe (Html Never)
        , field : Html msg
        , fieldConfig : PartialFieldConfig a
        , label : Maybe Label.Config
        }


{-| Internal
-}
customizeLabel : PartialFieldConfig a -> Label.Config -> Label.Config
customizeLabel configData =
    Label.withId (configData.id ++ "-label")
        >> Label.withFor configData.id


{-| Generate FormItem Config.
-}
config : PartialFieldConfig a -> Html msg -> Config a msg
config fieldConfig field =
    Config
        { additionalContent = Nothing
        , field = field
        , fieldConfig = fieldConfig
        , label = Nothing
        }


{-| Adds a Label to the field.
-}
withLabel : Maybe Label.Config -> Config a msg -> Config a msg
withLabel label (Config configuration) =
    Config { configuration | label = label }


{-| Append an additional custom html.
-}
withAdditionalContent : Maybe (Html Never) -> Config a msg -> Config a msg
withAdditionalContent additionalContent (Config configuration) =
    Config { configuration | additionalContent = additionalContent }


{-| FormItem render.
-}
render : Maybe (Error.Config value) -> Config a msg -> Html msg
render error (Config { label, field, fieldConfig, additionalContent }) =
    Html.div
        [ Html.Attributes.class "form-item" ]
        [ label
            |> Maybe.map (customizeLabel fieldConfig >> Label.render)
            |> CommonsRender.renderMaybe
        , Html.div
            [ Html.Attributes.class "form-item__wrapper" ]
            [ field
            , renderErrorOrHint fieldConfig.id error fieldConfig.hint
            ]
        , CommonsRender.renderMaybe (Maybe.map (Html.map never) additionalContent)
        ]


{-| Internal
-}
renderErrorOrHint : CommonsAlias.Id -> Maybe (Error.Config value) -> Maybe Hint.Config -> Html msg
renderErrorOrHint id errorConfig hintConfig =
    Maybe.Extra.or
        (Maybe.map Error.render errorConfig)
        (Maybe.map (Hint.withFieldId id >> Hint.render) hintConfig)
        |> CommonsRender.renderMaybe
