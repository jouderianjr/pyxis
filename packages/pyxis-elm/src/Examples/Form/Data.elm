module Examples.Form.Data exposing
    ( Data(..)
    , birthValidation
    , initialData
    , isInsuranceTypeHousehold
    , isInsuranceTypeMotor
    , notEmptyStringValidation
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
    )

import Date exposing (Date)
import Examples.Form.Api.City as City exposing (City)
import Examples.Form.Api.Province as Province
import Examples.Form.Msg as Msg exposing (Msg)
import Examples.Form.Types as Types
import Http
import PrimaFunction
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
        , birth : Input.Model Data Date Msg
        , claimDate : Input.Model Data Date Msg
        , claimType : RadioCardGroup.Model Data Types.Claim Types.Claim Msg
        , dynamic : Textarea.Model Data Msg
        , insuranceType : RadioCardGroup.Model Data Types.Insurance Types.Insurance Msg
        , peopleInvolved : RadioCardGroup.Model Data Bool Bool Msg
        , plate : Input.Model Data String Msg
        , privacyCheck : CheckboxGroup.Model Data () Bool Msg
        , residentialCity : Autocomplete.Model Data City Msg
        , residentialProvince : Select.Model Data String
        }


initialData : Data
initialData =
    Data
        { isFormSubmitted = False
        , birth = Input.init "" birthValidation
        , claimDate = Input.init "" birthValidation
        , claimType =
            Result.fromMaybe ""
                |> always
                |> RadioCardGroup.init (Just Types.CarAccident)
        , dynamic = Textarea.init "" notEmptyStringValidation
        , insuranceType =
            Types.Motor
                |> cardValidation
                |> RadioCardGroup.init Nothing
        , peopleInvolved =
            False
                |> cardValidation
                |> RadioCardGroup.init Nothing
        , plate = Input.init "" notEmptyStringValidation
        , privacyCheck = CheckboxGroup.init [] privacyValidation
        , residentialCity =
            Result.fromMaybe ""
                |> always
                |> Autocomplete.init Nothing City.getName City.startsWith
                |> Autocomplete.setOnInput Msg.PerformCitiesQuery
        , residentialProvince =
            Result.fromMaybe ""
                |> always
                |> Select.init "residential-province" (Just (Province.getName Province.capitalProvince))
                |> Select.setOptions (List.map (\p -> Select.option { label = Province.getName p, value = Province.getName p }) Province.list)
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
    ( Data { d | residentialProvince = componentModel }, Cmd.map Msg.ResidentialProvinceChanged componentCmd )


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


updatePrivacyChanged : CheckboxGroup.Msg () -> Data -> ( Data, Cmd Msg )
updatePrivacyChanged msg (Data d) =
    let
        ( componentModel, componentCmd ) =
            CheckboxGroup.update msg d.privacyCheck
    in
    ( Data { d | privacyCheck = componentModel }, componentCmd )



-- Validations


notEmptyStringValidation : Data -> String -> Result String String
notEmptyStringValidation (Data data) value =
    if data.isFormSubmitted && String.isEmpty value then
        Err "This field cannot be empty."

    else
        Ok value


cardValidation : value -> Data -> Maybe value -> Result String value
cardValidation default (Data data) value =
    value
        |> Maybe.map Ok
        |> Maybe.withDefault
            (PrimaFunction.ifThenElse data.isFormSubmitted
                (Err "Select at least one option.")
                (Ok default)
            )


birthValidation : Data -> String -> Result String Date.Date
birthValidation (Data data) value =
    case ( data.isFormSubmitted, Date.fromIsoString value ) of
        ( True, Ok validDate ) ->
            Ok validDate

        _ ->
            Err "Enter a valid date."


privacyValidation : Data -> List () -> Result String Bool
privacyValidation (Data data) list =
    if data.isFormSubmitted && List.member () list then
        Err "You must agree to privacy policy."

    else
        Ok True



-- Readers


isInsuranceTypeMotor : Data -> Bool
isInsuranceTypeMotor (Data d) =
    RadioCardGroup.getValue d.insuranceType == Just Types.Motor


isInsuranceTypeHousehold : Data -> Bool
isInsuranceTypeHousehold (Data d) =
    RadioCardGroup.getValue d.insuranceType == Just Types.Household
