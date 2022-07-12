module Examples.Form.Views.ClaimType exposing (view)

import Examples.Form.Data as Data exposing (Data(..))
import Examples.Form.Msg as Msg exposing (Msg)
import Examples.Form.Types as Fields
import Html
import Html.Attributes
import Pyxis.Components.Button as Button
import Pyxis.Components.Field.RadioCardGroup as RadioCardGroup
import Pyxis.Components.Form.FieldSet as FieldSet
import Pyxis.Components.Form.Grid as Grid
import Pyxis.Components.Form.Legend as Legend
import Pyxis.Components.IconSet as IconSet


view : Data -> FieldSet.Config Msg
view (Data config) =
    FieldSet.config
        |> FieldSet.withHeader
            [ Grid.oneColRowFullWidth
                [ Legend.config "Choose the accident type"
                    |> Legend.withImage "../../../assets/placeholder.svg"
                    |> Legend.render
                ]
            ]
        |> FieldSet.withContent
            [ Grid.oneColRowSmall
                [ "claim-type"
                    |> RadioCardGroup.config
                    |> RadioCardGroup.withValidationOnSubmit Data.radioValidation config.isFormSubmitted
                    |> RadioCardGroup.withLayout RadioCardGroup.vertical
                    |> RadioCardGroup.withOptions
                        [ RadioCardGroup.option
                            { value = Fields.CarAccident
                            , title = Just "Car crash"
                            , text = Just "Lorem ipsum dolor sit amet."
                            , addon = RadioCardGroup.iconAddon IconSet.VehicleCollisionKasko
                            }
                        , RadioCardGroup.option
                            { value = Fields.OtherClaims
                            , title = Just "Others"
                            , text = Just "Theft, fire, etc."
                            , addon = RadioCardGroup.iconAddon IconSet.VehicleFullKasko
                            }
                        ]
                    |> RadioCardGroup.render Msg.ClaimTypeChanged () config.claimType
                ]
            ]
        |> FieldSet.withFooter
            [ Grid.oneColRowFullWidth
                [ Html.div
                    [ Html.Attributes.class "button-row"
                    , Html.Attributes.style "justify-content" "center"
                    ]
                    [ Button.secondary
                        |> Button.withType Button.button
                        |> Button.withOnClick (Msg.ShowModal True)
                        |> Button.withText "Read more about our policy."
                        |> Button.render
                    ]
                ]
            ]
