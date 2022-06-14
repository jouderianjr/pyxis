module Examples.Form.Views.ClaimDetail exposing (view)

import Examples.Form.Data exposing (Data(..))
import Examples.Form.Msg as Msg exposing (Msg)
import Html
import Html.Attributes
import Pyxis.Components.Button as Button
import Pyxis.Components.Field.Error.Strategy as Strategy
import Pyxis.Components.Field.Label as Label
import Pyxis.Components.Field.RadioCardGroup as RadioCardGroup
import Pyxis.Components.Field.Textarea as Textarea
import Pyxis.Components.Form.FieldSet as FieldSet
import Pyxis.Components.Form.Grid as Grid
import Pyxis.Components.Form.Grid.Row as Row
import Pyxis.Components.Form.Legend as Legend


view : Data -> FieldSet.Config Msg
view ((Data config) as data) =
    FieldSet.config
        |> FieldSet.withHeader
            [ Grid.simpleOneColRow
                [ Legend.config "Claim details"
                    |> Legend.render
                ]
            ]
        |> FieldSet.withContent
            [ Grid.row
                [ Row.smallSize ]
                [ Grid.simpleCol
                    [ "people-involved"
                        |> RadioCardGroup.config
                        |> RadioCardGroup.withStrategy Strategy.onSubmit
                        |> RadioCardGroup.withIsSubmitted config.isFormSubmitted
                        |> RadioCardGroup.withLabel (Label.config "Is there any involved people?")
                        |> RadioCardGroup.withOptions
                            [ RadioCardGroup.option { value = True, title = Nothing, text = Just "Yes", addon = Nothing }
                            , RadioCardGroup.option { value = False, title = Nothing, text = Just "No", addon = Nothing }
                            ]
                        |> RadioCardGroup.render Msg.PeopleInvolvedChanged data config.peopleInvolved
                    ]
                ]
            , Grid.row
                [ Row.smallSize ]
                [ Grid.simpleCol
                    [ "claim-dynamic"
                        |> Textarea.config
                        |> Textarea.withStrategy Strategy.onSubmit
                        |> Textarea.withIsSubmitted config.isFormSubmitted
                        |> Textarea.withLabel (Label.config "Dynamic")
                        |> Textarea.withPlaceholder "Briefly describe the dynamics of the accident."
                        |> Textarea.withHint "Max. 300 words."
                        |> Textarea.render Msg.DynamicsChanged data config.dynamic
                    ]
                ]
            ]
        |> FieldSet.withFooter
            [ Grid.simpleOneColRow
                [ Html.div
                    [ Html.Attributes.class "button-row"
                    , Html.Attributes.style "justify-content" "center"
                    ]
                    [ Button.primary
                        |> Button.withType Button.button
                        |> Button.withOnClick Msg.Submit
                        |> Button.withText "Send"
                        |> Button.render
                    ]
                ]
            ]
