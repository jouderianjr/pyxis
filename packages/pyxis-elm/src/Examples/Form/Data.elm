module Examples.Form.Data exposing
    ( Data(..)
    , dateValidation
    , initialData
    , isInsuranceTypeHousehold
    , isInsuranceTypeMotor
    , notEmptyStringValidation
    , privacyValidation
    , radioValidation
    , residentialCityValidation
    , updateBirthDate
    , updateClaimDate
    , updateClaimType
    , updateDynamic
    , updateInsuranceType
    , updatePeopleInvolved
    , updatePlate
    , updatePrivacyChanged
    , updateResidentialCity
    , updateResidentialCityRemoteData
    , updateResidentialProvince
    , updateVehiclesOwn
    , vehiclesOwn
    )

import Date exposing (Date)
import Examples.Form.Api.City as City exposing (City)
import Examples.Form.Api.Province as Province
import Examples.Form.Msg as Msg exposing (Msg)
import Examples.Form.Types as Types
import Http
import Pyxis.Components.Field.Autocomplete as Autocomplete
import Pyxis.Components.Field.CheckboxGroup as CheckboxGroup
import Pyxis.Components.Field.Input as Input
import Pyxis.Components.Field.RadioCardGroup as RadioCardGroup
import Pyxis.Components.Field.Select as Select
import Pyxis.Components.Field.Textarea as Textarea
import RemoteData exposing (RemoteData)


type Data
    = Data
        { isFormSubmitted : Bool
        , birth : Input.Model Msg
        , claimDate : Input.Model Msg
        , claimType : RadioCardGroup.Model Types.Claim Msg
        , dynamic : Textarea.Model Msg
        , insuranceType : RadioCardGroup.Model Types.Insurance Msg
        , peopleInvolved : RadioCardGroup.Model Bool Msg
        , plate : Input.Model Msg
        , privacyCheck : CheckboxGroup.Model Types.Option Msg
        , residentialCity : Autocomplete.Model City Msg
        , residentialProvince : Select.Model Msg
        , vehiclesOwn : CheckboxGroup.Model Types.Vehicles Msg
        }


initialData : Data
initialData =
    Data
        { isFormSubmitted = False
        , birth = Input.init
        , claimDate = Input.init
        , claimType = RadioCardGroup.init |> RadioCardGroup.setValue Types.CarAccident
        , dynamic = Textarea.init
        , insuranceType = RadioCardGroup.init
        , peopleInvolved = RadioCardGroup.init
        , plate = Input.init
        , privacyCheck = CheckboxGroup.init
        , residentialCity =
            Autocomplete.init City.getName City.startsWith
                |> Autocomplete.setOnInput Msg.PerformCitiesQuery
        , residentialProvince =
            Select.init
                |> Select.setValue (Province.getName Province.capitalProvince)
                |> Select.setOptions (List.map (\p -> Select.option { label = Province.getName p, value = Province.getName p }) Province.list)
        , vehiclesOwn = CheckboxGroup.init
        }



-- Mappers


updateBirthDate : Input.Msg -> Data -> ( Data, Cmd Msg )
updateBirthDate msg (Data d) =
    let
        ( componentModel, componentCmd ) =
            Input.update msg d.birth
    in
    ( Data { d | birth = componentModel }, componentCmd )


updateClaimDate : Input.Msg -> Data -> ( Data, Cmd Msg )
updateClaimDate msg (Data d) =
    let
        ( componentModel, componentCmd ) =
            Input.update msg d.claimDate
    in
    ( Data { d | claimDate = componentModel }, componentCmd )


updateDynamic : Textarea.Msg -> Data -> ( Data, Cmd Msg )
updateDynamic msg (Data d) =
    let
        ( componentModel, componentCmd ) =
            Textarea.update msg d.dynamic
    in
    ( Data { d | dynamic = componentModel }, componentCmd )


updatePlate : Input.Msg -> Data -> ( Data, Cmd Msg )
updatePlate msg (Data d) =
    let
        ( componentModel, componentCmd ) =
            Input.update msg d.plate
    in
    ( Data { d | plate = componentModel }, componentCmd )


updateResidentialCity : Autocomplete.Msg City -> Data -> ( Data, Cmd Msg )
updateResidentialCity msg (Data d) =
    let
        ( componentModel, componentCmd ) =
            Autocomplete.update msg d.residentialCity
    in
    ( Data { d | residentialCity = componentModel }, componentCmd )


updateResidentialCityRemoteData : RemoteData Http.Error (List City) -> Data -> ( Data, Cmd Msg )
updateResidentialCityRemoteData remoteData (Data d) =
    ( Data { d | residentialCity = Autocomplete.setOptions remoteData d.residentialCity }, Cmd.none )


updateResidentialProvince : Select.Msg -> Data -> ( Data, Cmd Msg )
updateResidentialProvince msg (Data d) =
    let
        ( componentModel, componentCmd ) =
            Select.update msg d.residentialProvince
    in
    ( Data { d | residentialProvince = componentModel }, componentCmd )


updateInsuranceType : RadioCardGroup.Msg Types.Insurance -> Data -> ( Data, Cmd Msg )
updateInsuranceType msg (Data d) =
    let
        ( componentModel, componentCmd ) =
            RadioCardGroup.update msg d.insuranceType
    in
    ( Data { d | insuranceType = componentModel }, componentCmd )


updateClaimType : RadioCardGroup.Msg Types.Claim -> Data -> ( Data, Cmd Msg )
updateClaimType msg (Data d) =
    let
        ( componentModel, componentCmd ) =
            RadioCardGroup.update msg d.claimType
    in
    ( Data { d | claimType = componentModel }, componentCmd )


updatePeopleInvolved : RadioCardGroup.Msg Bool -> Data -> ( Data, Cmd Msg )
updatePeopleInvolved msg (Data d) =
    let
        ( componentModel, componentCmd ) =
            RadioCardGroup.update msg d.peopleInvolved
    in
    ( Data { d | peopleInvolved = componentModel }, componentCmd )


updatePrivacyChanged : CheckboxGroup.Msg Types.Option -> Data -> ( Data, Cmd Msg )
updatePrivacyChanged msg (Data d) =
    let
        ( componentModel, componentCmd ) =
            CheckboxGroup.update msg d.privacyCheck
    in
    ( Data { d | privacyCheck = componentModel }, componentCmd )


updateVehiclesOwn : CheckboxGroup.Msg Types.Vehicles -> Data -> ( Data, Cmd Msg )
updateVehiclesOwn msg (Data d) =
    let
        ( componentModel, componentCmd ) =
            CheckboxGroup.update msg d.vehiclesOwn
    in
    ( Data { d | vehiclesOwn = componentModel }, componentCmd )



-- Validations


notEmptyStringValidation : String -> Result String String
notEmptyStringValidation value =
    if String.isEmpty value then
        Err "This field cannot be empty."

    else
        Ok value


radioValidation : Maybe option -> Result String option
radioValidation selected =
    Result.fromMaybe "You must select one option" selected


dateValidation : String -> Result String Date
dateValidation value =
    case Date.fromIsoString value of
        Ok validDate ->
            Ok validDate

        _ ->
            Err "Enter a valid date."


privacyValidation : Data -> List Types.Option -> Result String (List Types.Option)
privacyValidation (Data data) list =
    if data.isFormSubmitted && List.isEmpty list then
        Err "You must agree to privacy policy."

    else
        Ok [ Types.AcceptPrivacy ]


vehiclesOwn : Data -> List Types.Vehicles -> Result String (List Types.Vehicles)
vehiclesOwn (Data data) list =
    if data.isFormSubmitted && List.length list < 2 then
        Err "Select at least two options"

    else
        Ok list


residentialCityValidation : Maybe City -> Result String City
residentialCityValidation maybeJob =
    maybeJob
        |> Maybe.map Ok
        |> Maybe.withDefault (Err "Select a city")



-- Readers


isInsuranceTypeMotor : Data -> Bool
isInsuranceTypeMotor (Data d) =
    RadioCardGroup.getValue d.insuranceType == Just Types.Motor


isInsuranceTypeHousehold : Data -> Bool
isInsuranceTypeHousehold (Data d) =
    RadioCardGroup.getValue d.insuranceType == Just Types.Household
