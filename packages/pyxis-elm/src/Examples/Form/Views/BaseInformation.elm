module Examples.Form.Views.BaseInformation exposing (view)

import Examples.Form.Api.Province as Province
import Examples.Form.Data as Data exposing (Data(..))
import Examples.Form.Model as Model
import Html
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


view : Data -> FieldSet.Config Model.Msg
view ((Data config) as data) =
    FieldSet.config
        |> FieldSet.withHeader
            [ Grid.simpleOneColRow
                [ Legend.config "Inserisci alcune informazioni di base"
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
                        |> Input.withLabel
                            ("Targa del veicolo assicurato con Prima"
                                |> Label.config
                                |> Label.withSubText "(Veicolo A)"
                            )
                        |> Input.withAdditionalContent (Html.button [] [])
                        |> Input.render (Model.TextFieldChanged Data.Plate) data config.plate
                    ]
                ]
            , Grid.row
                [ Row.smallSize ]
                [ Grid.simpleCol
                    [ "birth_date"
                        |> Input.date
                        |> Input.withLabel (Label.config "Data di nascita del proprietario")
                        |> Input.render (Model.DateFieldChanged Data.Birth) data config.birth
                    ]
                ]
            , Grid.row
                [ Row.smallSize ]
                [ Grid.simpleCol
                    [ "residential_city"
                        |> Autocomplete.config
                        |> Autocomplete.withStrategy Strategy.onSubmit
                        |> Autocomplete.withNoResultsFoundMessage "Nessun risultato trovato."
                        |> Autocomplete.withLabel (Label.config "Città di residenza")
                        |> Autocomplete.withHint "Min. 3 caratteri"
                        |> Autocomplete.withPlaceholder "Milano"
                        |> Autocomplete.withAddonSuggestion
                            { icon = IconSet.InfoCircle
                            , title = "Lorem ipsum"
                            , subtitle = Just "Lorem ipsum dolor sit amet."
                            }
                        |> Autocomplete.render (Model.AutocompleteFieldChanged Data.ResidentialCity) data config.residentialCity
                    ]
                ]
            , Grid.row
                [ Row.smallSize ]
                [ Grid.simpleCol
                    [ "residential_province"
                        |> Select.config False
                        |> Select.withOptions (List.map (\p -> Select.option { label = Province.getName p, value = Province.getName p }) Province.list)
                        |> Select.withLabel (Label.config "Provincia di residenza")
                        |> Select.render (Model.SelectFieldChanged Data.ResidentialProvince) data config.residentialProvince
                    ]
                ]
            , Grid.row
                [ Row.smallSize ]
                [ Grid.simpleCol
                    [ "claim_date"
                        |> Input.date
                        |> Input.withLabel (Label.config "Data del sinistro")
                        |> Input.render (Model.DateFieldChanged Data.ClaimDate) data config.claimDate
                    ]
                ]
            , Grid.row
                [ Row.smallSize ]
                [ Grid.simpleCol
                    [ "checkbox-id"
                        |> CheckboxGroup.single
                            (Html.div
                                []
                                [ Html.text
                                    "Dichiaro di aver letto l’"
                                , Html.a [ Html.Attributes.href "https://www.prima.it/app/privacy-policy" ]
                                    [ Html.text "Informativa Privacy" ]
                                , Html.text
                                    ", disposta ai sensi degli articoli 13 e 14 del Regolamento UE 2016/679. "
                                ]
                            )
                        |> CheckboxGroup.withStrategy Strategy.onSubmit
                        |> CheckboxGroup.withId "checkbox-group-single"
                        |> CheckboxGroup.render Model.PrivacyChanged data config.privacyCheck
                    ]
                ]
            ]
