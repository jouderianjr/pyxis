module Examples.Form.Views.BaseInformation exposing (view)

import Examples.Form.Data as Data exposing (Data(..))
import Examples.Form.Msg as Msg exposing (Msg)
import Examples.Form.Types as Types
import Html exposing (Html)
import Html.Attributes
import Pyxis.Components.Field.Autocomplete as Autocomplete
import Pyxis.Components.Field.CheckboxGroup as CheckboxGroup
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
            [ Grid.oneColRowFullWidth
                [ Legend.config "Vehicle & owner"
                    |> Legend.render
                ]
            ]
        |> FieldSet.withContent
            [ Grid.row [ Row.smallSize ]
                [ Grid.col []
                    [ "name"
                        |> Input.text
                        |> Input.withPlaceholder "John"
                        |> Input.withValidationOnSubmit Data.notEmptyStringValidation config.isFormSubmitted
                        |> Input.withLabel (Label.config "Name")
                        |> Input.render Msg.NameChanged () config.name
                    ]
                , Grid.col []
                    [ "surname"
                        |> Input.text
                        |> Input.withPlaceholder "Doe"
                        |> Input.withValidationOnSubmit Data.notEmptyStringValidation config.isFormSubmitted
                        |> Input.withLabel (Label.config "Surname")
                        |> Input.render Msg.SurnameChanged () config.surname
                    ]
                ]
            , Grid.oneColRowSmall
                [ "plate"
                    |> Input.text
                    |> Input.withPlaceholder "AA123BC"
                    |> Input.withValidationOnSubmit Data.notEmptyStringValidation config.isFormSubmitted
                    |> Input.withLabel
                        ("Vehicle plate"
                            |> Label.config
                            |> Label.withSubText "(Vehicle A)"
                        )
                    |> Input.render Msg.PlateChanged () config.plate
                ]
            , Grid.oneColRowSmall
                [ "birth_date"
                    |> Input.date
                    |> Input.withValidationOnSubmit Data.dateValidation config.isFormSubmitted
                    |> Input.withLabel (Label.config "Owner birth date")
                    |> Input.render Msg.BirthDateChanged () config.birth
                ]
            , Grid.oneColRowSmall
                [ "residential_city"
                    |> Autocomplete.config
                    |> Autocomplete.withValidationOnSubmit Data.residentialCityValidation config.isFormSubmitted
                    |> Autocomplete.withNoResultsFoundMessage "No results were found."
                    |> Autocomplete.withLabel (Label.config "Residential city")
                    |> Autocomplete.withHint "Type at least 3 chars to start searching."
                    |> Autocomplete.withPlaceholder "Milano"
                    |> Autocomplete.withSuggestion
                        { icon = IconSet.InfoCircle
                        , title = "Lorem ipsum"
                        , subtitle = Just "Lorem ipsum dolor sit amet."
                        }
                    |> Autocomplete.render Msg.ResidentialCityChanged () config.residentialCity
                ]
            , Grid.oneColRowSmall
                [ Select.config "residential_province" False
                    |> Select.withLabel (Label.config "Provincia di residenza")
                    |> Select.render Msg.ResidentialProvinceChanged data config.residentialProvince
                ]
            , Grid.oneColRowSmall
                [ "vehicles-own"
                    |> CheckboxGroup.config
                    |> CheckboxGroup.withOptions
                        [ CheckboxGroup.option { value = Types.Car, label = Html.text "Car" }
                        , CheckboxGroup.option { value = Types.Motorcycle, label = Html.text "Motorcycle" }
                        , CheckboxGroup.option { value = Types.Van, label = Html.text "Van" }
                        ]
                    |> CheckboxGroup.withLabel (Label.config "Kind of vehicles involved in the accident")
                    |> CheckboxGroup.withValidationOnSubmit Data.vehiclesOwn config.isFormSubmitted
                    |> CheckboxGroup.withLayout CheckboxGroup.vertical
                    |> CheckboxGroup.render Msg.VehiclesOwnChanged data config.vehiclesOwn
                ]
            , Grid.oneColRowSmall
                [ "claim_date"
                    |> Input.date
                    |> Input.withValidationOnSubmit Data.dateValidation config.isFormSubmitted
                    |> Input.withLabel (Label.config "Claim date")
                    |> Input.render Msg.ClaimDateChanged () config.claimDate
                ]
            , Grid.oneColRowSmall
                [ "checkbox-id"
                    |> CheckboxGroup.config
                    |> CheckboxGroup.withOptions
                        [ CheckboxGroup.option { value = Types.AcceptPrivacy, label = viewPrivacy } ]
                    |> CheckboxGroup.withValidationOnSubmit Data.privacyValidation config.isFormSubmitted
                    |> CheckboxGroup.withId "checkbox-group-single"
                    |> CheckboxGroup.render Msg.PrivacyChanged data config.privacyCheck
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
