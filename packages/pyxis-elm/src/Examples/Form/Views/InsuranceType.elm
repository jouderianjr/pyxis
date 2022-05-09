module Examples.Form.Views.InsuranceType exposing (view)

import Components.Field.Error.Strategy as Strategy
import Components.Field.RadioCardGroup as RadioCardGroup
import Components.Form.FieldSet as FieldSet
import Components.Form.Grid as Grid
import Components.Form.Grid.Row as Row
import Components.Form.Legend as Legend
import Examples.Form.Data as Data exposing (Data(..))
import Examples.Form.Model as Model


view : Data -> FieldSet.Config Model.Msg
view ((Data config) as data) =
    FieldSet.config
        |> FieldSet.withHeader
            [ Grid.simpleOneColRow
                [ Legend.config "Scegli il sinistro da denunciare"
                    |> Legend.render
                ]
            ]
        |> FieldSet.withContent
            [ Grid.row
                [ Row.mediumSize ]
                [ Grid.simpleCol
                    [ "insurance-type"
                        |> RadioCardGroup.config
                        |> RadioCardGroup.withStrategy Strategy.onSubmit
                        |> RadioCardGroup.withSize RadioCardGroup.large
                        |> RadioCardGroup.withOptions
                            [ RadioCardGroup.option { value = Data.Motor, title = Just "Veicoli", text = Nothing, addon = RadioCardGroup.imgAddon "../../../../assets/placeholder.svg" }
                            , RadioCardGroup.option { value = Data.Home, title = Just "Casa e famiglia", text = Nothing, addon = RadioCardGroup.imgAddon "../../../../assets/placeholder.svg" }
                            ]
                        |> RadioCardGroup.render Model.InsuranceTypeChanged data config.insuranceType
                    ]
                ]
            ]
