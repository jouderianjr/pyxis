module Examples.Form.Views.RequestReceived exposing (view)

import Examples.Form.Msg exposing (Msg)
import Html exposing (Html)
import Html.Attributes
import Pyxis.Components.Button as Button
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
        [ IconSet.CheckCircle
            |> Icon.config
            |> Icon.withSize Icon.large
            |> Icon.withStyle Icon.success
            |> Icon.render
        , Html.p
            [ Html.Attributes.class "title-m-bold margin-v-s" ]
            [ Html.text "Your request was successfully sent!" ]
        , Html.p
            [ Html.Attributes.class "text-l-book margin-v-l" ]
            [ Html.text
                "We received your request, don't worry we'll manage it sooner. "
            , Html.span
                [ Html.Attributes.class "text-l-bold" ]
                [ Html.text "In case of need, " ]
            , Html.text
                "we'll use your contact data to reach you out."
            ]
        , Button.secondary
            |> Button.withText "Back to the form"
            |> Button.render
        ]
