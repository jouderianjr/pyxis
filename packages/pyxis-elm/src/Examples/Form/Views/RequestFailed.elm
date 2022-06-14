module Examples.Form.Views.RequestFailed exposing (view)

import Examples.Form.Msg exposing (Msg)
import Html exposing (Html)
import Html.Attributes
import Pyxis.Components.Icon as Icon
import Pyxis.Components.IconSet as IconSet


view : Html Msg
view =
    Html.div
        [ Html.Attributes.class "margin-v-m"
        , Html.Attributes.style "display" "flex"
        , Html.Attributes.style "flex-direction" "column"
        , Html.Attributes.style "align-items" "center"
        ]
        [ IconSet.Alert
            |> Icon.config
            |> Icon.withSize Icon.large
            |> Icon.withStyle Icon.error
            |> Icon.render
        , Html.p
            [ Html.Attributes.class "title-m-bold margin-v-s" ]
            [ Html.text "We're sorry!" ]
        , Html.p
            [ Html.Attributes.class "text-l-book margin-v-l" ]
            [ Html.text "We cannot handle non-motor claims. Please, "
            , Html.a
                [ Html.Attributes.href "tel:010203040506"
                , Html.Attributes.class "link"
                ]
                [ Html.text "call our support center" ]
            , Html.text " they'll be happy to help you."
            ]
        ]
