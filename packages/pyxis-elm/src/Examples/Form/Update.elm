module Examples.Form.Update exposing (update)

import Examples.Form.Api.City as CityApi
import Examples.Form.Data as Data exposing (Data(..))
import Examples.Form.Model as Model exposing (Model)
import Examples.Form.Msg exposing (Msg(..))
import PrimaUpdate


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CitiesFetched remoteData ->
            model
                |> Model.updateCities remoteData
                |> Model.updateDataAndDispatch (Data.updateResidentialCityRemoteData remoteData)

        PerformCitiesQuery ->
            model
                |> PrimaUpdate.withCmds [ CityApi.fetch CitiesFetched ]

        ResidentialCityChanged subMsg ->
            Model.updateDataAndDispatch (Data.updateResidentialCity subMsg) model

        ResidentialProvinceChanged subMsg ->
            Model.updateDataAndDispatch (Data.updateResidentialProvince subMsg) model

        BirthDateChanged subMsg ->
            Model.updateDataAndDispatch (Data.updateBirthDate subMsg) model

        ClaimDateChanged subMsg ->
            Model.updateDataAndDispatch (Data.updateClaimDate subMsg) model

        DynamicsChanged subMsg ->
            Model.updateDataAndDispatch (Data.updateDynamic subMsg) model

        InsuranceTypeChanged subMsg ->
            Model.updateDataAndDispatch (Data.updateInsuranceType subMsg) model

        PlateChanged subMsg ->
            Model.updateDataAndDispatch (Data.updatePlate subMsg) model

        PrivacyChanged subMsg ->
            Model.updateDataAndDispatch (Data.updatePrivacyChanged subMsg) model

        ClaimTypeChanged subMsg ->
            Model.updateDataAndDispatch (Data.updateClaimType subMsg) model

        PeopleInvolvedChanged subMsg ->
            Model.updateDataAndDispatch (Data.updatePeopleInvolved subMsg) model

        Submit ->
            Model.submit model

        ShowModal isOpen ->
            Model.updateModal isOpen model

        FaqToggled subMsg ->
            Model.updateFaqs subMsg model

        VehiclesOwnChanged subMsg ->
            Model.updateDataAndDispatch (Data.updateVehiclesOwn subMsg) model
