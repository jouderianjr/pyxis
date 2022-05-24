module Examples.Form.Data exposing
    ( AutocompleteField(..)
    , ClaimType(..)
    , Data(..)
    , DateField(..)
    , InsuranceType(..)
    , PeopleInvolved(..)
    , SelectField(..)
    , TextField(..)
    , TextareaField(..)
    , birthValidation
    , initialData
    , notEmptyStringValidation
    )

import Date exposing (Date)
import Examples.Form.Api.City exposing (City)
import Examples.Form.Api.Province as Province
import Pyxis.Components.Field.Autocomplete as Autocomplete
import Pyxis.Components.Field.CheckboxGroup as CheckboxGroup
import Pyxis.Components.Field.Input as Input
import Pyxis.Components.Field.RadioCardGroup as RadioCardGroup
import Pyxis.Components.Field.Select as Select
import Pyxis.Components.Field.Textarea as Textarea


type Data
    = Data
        { isFormSubmitted : Bool
        , birth : Input.Model Data Date
        , claimDate : Input.Model Data Date
        , claimType : RadioCardGroup.Model Data ClaimType ClaimType
        , dynamic : Textarea.Model Data
        , insuranceType : RadioCardGroup.Model Data InsuranceType InsuranceType
        , peopleInvolved : RadioCardGroup.Model Data PeopleInvolved PeopleInvolved
        , plate : Input.Model Data String
        , privacyCheck : CheckboxGroup.Model Data () Bool
        , residentialCity : Autocomplete.Model Data City
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
                |> RadioCardGroup.init (Just CarAccident)
        , dynamic = Textarea.init "" notEmptyStringValidation
        , insuranceType =
            Motor
                |> cardValidation
                |> RadioCardGroup.init Nothing
        , peopleInvolved =
            NotInvolved
                |> cardValidation
                |> RadioCardGroup.init Nothing
        , plate = Input.init "" notEmptyStringValidation
        , privacyCheck = CheckboxGroup.init [] privacyValidation
        , residentialCity =
            Result.fromMaybe ""
                |> always
                |> Autocomplete.init Nothing
        , residentialProvince =
            Result.fromMaybe ""
                |> always
                |> Select.init (Just (Province.getName Province.capitalProvince))
        }


type AutocompleteField
    = ResidentialCity


type TextField
    = Plate


type TextareaField
    = Dynamics


type DateField
    = Birth
    | ClaimDate


type SelectField
    = ResidentialProvince


type InsuranceType
    = Motor
    | Home


type ClaimType
    = CarAccident
    | OtherClaims


type PeopleInvolved
    = Involved
    | NotInvolved


notEmptyStringValidation : Data -> String -> Result String String
notEmptyStringValidation (Data data) value =
    if data.isFormSubmitted && String.isEmpty value then
        Err "This field cannot be empty."

    else
        Ok value


cardValidation : value -> Data -> Maybe value -> Result String value
cardValidation default (Data data) value =
    case value of
        Nothing ->
            if data.isFormSubmitted then
                Err "Select at least one option."

            else
                Ok default

        Just value_ ->
            Ok value_


birthValidation : Data -> String -> Result String Date.Date
birthValidation (Data data) value =
    case ( data.isFormSubmitted, Date.fromIsoString value ) of
        ( True, Ok validDate ) ->
            Ok validDate

        _ ->
            Err "Enter a valid date."


privacyValidation : Data -> List () -> Result String Bool
privacyValidation (Data data) list =
    if data.isFormSubmitted && (List.member () list |> not) then
        Err "You must agree to privacy policy."

    else
        Ok True
