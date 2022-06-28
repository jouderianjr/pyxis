module Examples.Form.Msg exposing (Msg(..))

import Examples.Form.Api.City exposing (City)
import Examples.Form.Types as Fields
import Http
import Pyxis.Components.Accordion as Accordion
import Pyxis.Components.Field.Autocomplete as Autocomplete
import Pyxis.Components.Field.CheckboxGroup as CheckboxGroup
import Pyxis.Components.Field.Input as Input
import Pyxis.Components.Field.RadioCardGroup as RadioCardGroup
import Pyxis.Components.Field.Select as Select
import Pyxis.Components.Field.Textarea as Textarea
import RemoteData exposing (RemoteData)


type Msg
    = CitiesFetched (RemoteData Http.Error (List City))
    | PerformCitiesQuery
    | Submit
    | ResidentialCityChanged (Autocomplete.Msg City)
    | ResidentialProvinceChanged Select.Msg
    | PlateChanged Input.Msg
    | DynamicsChanged Textarea.Msg
    | BirthDateChanged Input.Msg
    | ClaimDateChanged Input.Msg
    | InsuranceTypeChanged (RadioCardGroup.Msg Fields.Insurance)
    | ClaimTypeChanged (RadioCardGroup.Msg Fields.Claim)
    | PeopleInvolvedChanged (RadioCardGroup.Msg Bool)
    | PrivacyChanged (CheckboxGroup.Msg Fields.Option)
    | VehiclesOwnChanged (CheckboxGroup.Msg Fields.Vehicles)
    | ShowModal Bool
    | FaqToggled Accordion.Msg
