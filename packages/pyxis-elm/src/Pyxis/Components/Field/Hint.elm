module Pyxis.Components.Field.Hint exposing (Config, config, render, toId, withFieldId)

import Html exposing (Html)
import Html.Attributes
import Pyxis.Commons.Alias as CommonsAlias
import Pyxis.Commons.Attributes as CommonsAttributes


{-| Represent a form field hint.
-}
type Config
    = Config
        { message : String
        , id : Maybe CommonsAlias.Id
        }


{-| Creates an hint message.
-}
config : String -> Config
config message =
    Config { id = Nothing, message = message }


{-| Adds an id to the hint.
-}
withFieldId : CommonsAlias.Id -> Config -> Config
withFieldId fieldId (Config configuration) =
    Config { configuration | id = Just (toId fieldId) }


{-| Given the field id returns an hintId.
-}
toId : CommonsAlias.Id -> String
toId fieldId =
    fieldId ++ "-hint"


render : Config -> Html msg
render (Config { id, message }) =
    Html.div
        [ Html.Attributes.class "form-item__hint"
        , CommonsAttributes.maybe Html.Attributes.id id
        ]
        [ Html.text message
        ]
