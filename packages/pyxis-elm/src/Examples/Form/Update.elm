module Examples.Form.Update exposing (update)

import Examples.Form.Api.City as CityApi
import Examples.Form.Data as Data exposing (Data(..))
import Examples.Form.Model as Model exposing (Model)
import PrimaCmd as PrimaUpdate
import PrimaUpdate
import Pyxis.Components.Accordion as Accordion
import Pyxis.Components.Field.Autocomplete as Autocomplete
import Pyxis.Components.Field.CheckboxGroup as CheckboxGroup
import Pyxis.Components.Field.Input as Input
import Pyxis.Components.Field.RadioCardGroup as RadioCardGroup
import Pyxis.Components.Field.Select as Select
import Pyxis.Components.Field.Textarea as Textarea
import RemoteData


update : Model.Msg -> Model -> ( Model, Cmd Model.Msg )
update msg model =
    case msg of
        Model.CitiesFetched ((RemoteData.Success _) as remoteData) ->
            { model | citiesApi = remoteData }
                |> Model.mapData (\(Data d) -> Data { d | residentialCity = Autocomplete.setOptions remoteData d.residentialCity })
                |> PrimaUpdate.withoutCmds

        Model.CitiesFetched ((RemoteData.Failure _) as remoteData) ->
            { model | citiesApi = remoteData }
                |> Model.mapData (\(Data d) -> Data { d | residentialCity = Autocomplete.setOptions remoteData d.residentialCity })
                |> PrimaUpdate.withoutCmds

        Model.CitiesFetched remoteData ->
            { model | citiesApi = remoteData }
                |> PrimaUpdate.withoutCmds

        Model.Submit ->
            model
                |> Model.mapData (\(Data d) -> Data { d | isFormSubmitted = True })
                |> Model.updateResponse
                |> PrimaUpdate.withoutCmds

        Model.AutocompleteFieldChanged Data.ResidentialCity subMsg ->
            let
                ( autocompleteModel, autocompleteCmd ) =
                    Model.mapResidentialCity subMsg model.data
            in
            model
                |> Model.setData autocompleteModel
                |> PrimaUpdate.withCmds
                    [ Cmd.map (Model.AutocompleteFieldChanged Data.ResidentialCity) autocompleteCmd
                    , PrimaUpdate.ifThenCmd
                        (Autocomplete.isOnInput subMsg)
                        (CityApi.fetch Model.CitiesFetched)
                    ]

        Model.DateFieldChanged Data.Birth subMsg ->
            model
                |> Model.mapData (\(Data d) -> Data { d | birth = Input.update subMsg d.birth })
                |> PrimaUpdate.withoutCmds

        Model.TextareaFieldChanged Data.Dynamics subMsg ->
            model
                |> Model.mapData (\(Data d) -> Data { d | dynamic = Textarea.update subMsg d.dynamic })
                |> PrimaUpdate.withoutCmds

        Model.InsuranceTypeChanged subMsg ->
            model
                |> Model.mapData (\(Data d) -> Data { d | insuranceType = RadioCardGroup.update subMsg d.insuranceType })
                |> PrimaUpdate.withoutCmds

        Model.TextFieldChanged Data.Plate subMsg ->
            model
                |> Model.mapData (\(Data d) -> Data { d | plate = Input.update subMsg d.plate })
                |> PrimaUpdate.withoutCmds

        Model.DateFieldChanged Data.ClaimDate subMsg ->
            model
                |> Model.mapData (\(Data d) -> Data { d | claimDate = Input.update subMsg d.claimDate })
                |> PrimaUpdate.withoutCmds

        Model.SelectFieldChanged Data.ResidentialProvince subMsg ->
            model
                |> Model.mapData (\(Data d) -> Data { d | residentialProvince = Tuple.first (Select.update subMsg d.residentialProvince) })
                |> PrimaUpdate.withoutCmds

        Model.PrivacyChanged subMsg ->
            model
                |> Model.mapData (\(Data d) -> Data { d | privacyCheck = CheckboxGroup.update subMsg d.privacyCheck })
                |> PrimaUpdate.withoutCmds

        Model.ClaimTypeChanged subMsg ->
            model
                |> Model.mapData (\(Data d) -> Data { d | claimType = RadioCardGroup.update subMsg d.claimType })
                |> PrimaUpdate.withoutCmds

        Model.PeopleInvolvedChanged subMsg ->
            model
                |> Model.mapData (\(Data d) -> Data { d | peopleInvolved = RadioCardGroup.update subMsg d.peopleInvolved })
                |> PrimaUpdate.withoutCmds

        Model.ShowModal bool ->
            { model | showModal = bool }
                |> PrimaUpdate.withoutCmds

        Model.AccordionChanged subMsg ->
            let
                ( accordionModel, accordionCmd ) =
                    Accordion.update subMsg model.accordion
            in
            { model | accordion = accordionModel }
                |> PrimaUpdate.withCmd (Cmd.map Model.AccordionChanged accordionCmd)
