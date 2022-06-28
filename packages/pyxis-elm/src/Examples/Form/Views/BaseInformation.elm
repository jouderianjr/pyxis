module Examples.Form.Views.BaseInformation exposing (view)

import Examples.Form.Data exposing (Data(..))
import Examples.Form.Msg as Msg exposing (Msg)
import Examples.Form.Types as Types
import Html exposing (Html)
import Html.Attributes
import Pyxis.Components.Field.Autocomplete as Autocomplete
import Pyxis.Components.Field.CheckboxGroup as CheckboxGroup
import Pyxis.Components.Field.Error.Strategy as Strategy
import Pyxis.Components.Field.Input as Input
import Pyxis.Components.Field.Label as Label
import Pyxis.Components.Field.Select as Select
import Pyxis.Components.Form.FieldSet as FieldSet
import Pyxis.Components.Form.Grid as Grid
import Pyxis.Components.Form.Grid.Row as Row
import Pyxis.Components.Form.Legend as Legend
import Pyxis.Components.IconSet as IconSet


view : Data -> FieldSet.Config Msg
view ((Data config) as data) =
    FieldSet.config
        |> FieldSet.withHeader
            [ Grid.simpleOneColRow
                [ Legend.config "Vehicle & owner"
                    |> Legend.render
                ]
            ]
        |> FieldSet.withContent
            [ Grid.row
                [ Row.smallSize ]
                [ Grid.simpleCol
                    [ "plate"
                        |> Input.text
                        |> Input.withPlaceholder "AA123BC"
                        |> Input.withStrategy Strategy.onSubmit
                        |> Input.withIsSubmitted config.isFormSubmitted
                        |> Input.withLabel
                            ("Vehicle plate"
                                |> Label.config
                                |> Label.withSubText "(Vehicle A)"
                            )
                        |> Input.render Msg.PlateChanged data config.plate
                    ]
                ]
            , Grid.row
                [ Row.smallSize ]
                [ Grid.simpleCol
                    [ "birth_date"
                        |> Input.date
                        |> Input.withStrategy Strategy.onSubmit
                        |> Input.withIsSubmitted config.isFormSubmitted
                        |> Input.withLabel (Label.config "Owner birth date")
                        |> Input.render Msg.BirthDateChanged data config.birth
                    ]
                ]
            , Grid.row
                [ Row.smallSize ]
                [ Grid.simpleCol
                    [ "residential_city"
                        |> Autocomplete.config
                        |> Autocomplete.withStrategy Strategy.onSubmit
                        |> Autocomplete.withIsSubmitted config.isFormSubmitted
                        |> Autocomplete.withNoResultsFoundMessage "No results were found."
                        |> Autocomplete.withLabel (Label.config "Residential city")
                        |> Autocomplete.withHint "Type at least 3 chars to start searching."
                        |> Autocomplete.withPlaceholder "Milano"
                        |> Autocomplete.withAddonSuggestion
                            { icon = IconSet.InfoCircle
                            , title = "Lorem ipsum"
                            , subtitle = Just "Lorem ipsum dolor sit amet."
                            }
                        |> Autocomplete.render Msg.ResidentialCityChanged data config.residentialCity
                    ]
                ]
            , Grid.row
                [ Row.smallSize ]
                [ Grid.simpleCol
                    [ Select.config "residential_province" False
                        |> Select.withStrategy Strategy.onSubmit
                        |> Select.withIsSubmitted config.isFormSubmitted
                        |> Select.withLabel (Label.config "Provincia di residenza")
                        |> Select.render Msg.ResidentialProvinceChanged data config.residentialProvince
                    ]
                ]
            , Grid.row
                [ Row.smallSize ]
                [ Grid.simpleCol
                    [ "vehicles-own"
                        |> CheckboxGroup.config
                        |> CheckboxGroup.withOptions
                            [ CheckboxGroup.option { value = Types.Car, label = Html.text "Car" }
                            , CheckboxGroup.option { value = Types.Motorcycle, label = Html.text "Motorcycle" }
                            , CheckboxGroup.option { value = Types.Van, label = Html.text "Van" }
                            ]
                        |> CheckboxGroup.withLabel (Label.config "Kind of vehicles involved in the accident")
                        |> CheckboxGroup.withStrategy Strategy.onSubmit
                        |> CheckboxGroup.withLayout CheckboxGroup.vertical
                        |> CheckboxGroup.withIsSubmitted config.isFormSubmitted
                        |> CheckboxGroup.render Msg.VehiclesOwnChanged data config.vehiclesOwn
                    ]
                ]
            , Grid.row
                [ Row.smallSize ]
                [ Grid.simpleCol
                    [ "claim_date"
                        |> Input.date
                        |> Input.withStrategy Strategy.onSubmit
                        |> Input.withIsSubmitted config.isFormSubmitted
                        |> Input.withLabel (Label.config "Claim date")
                        |> Input.render Msg.ClaimDateChanged data config.claimDate
                    ]
                ]
            , Grid.row
                [ Row.smallSize ]
                [ Grid.simpleCol
                    [ "checkbox-id"
                        |> CheckboxGroup.config
                        |> CheckboxGroup.withOptions
                            [ CheckboxGroup.option { value = Types.AcceptPrivacy, label = viewPrivacy } ]
                        |> CheckboxGroup.withStrategy Strategy.onSubmit
                        |> CheckboxGroup.withIsSubmitted config.isFormSubmitted
                        |> CheckboxGroup.withId "checkbox-group-single"
                        |> CheckboxGroup.render Msg.PrivacyChanged data config.privacyCheck
                    ]
                ]
            ]


viewPrivacy : Html msg
viewPrivacy =
    Html.span
        []
        [ Html.text
            "I agree with the "
        , Html.a
            [ Html.Attributes.class "link"
            , Html.Attributes.href "https://www.prima.it/app/privacy-policy"
            , Html.Attributes.target "_blank"
            ]
            [ Html.text "Privacy policy"
            ]
        , Html.text " lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum volutpat et neque vel aliquam. Ut nec felis lectus."
        ]
