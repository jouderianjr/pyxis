module Examples.Form.Model exposing
    ( Model
    , initialModel
    , mapData
    , submit
    , updateCities
    , updateDataAndDispatch
    , updateFaqs
    , updateModal
    , validate
    )

import Date exposing (Date)
import Examples.Form.Api.City exposing (City)
import Examples.Form.Data as Data exposing (Data(..))
import Examples.Form.Msg as Msg exposing (Msg)
import Examples.Form.Types as Fields
import Http
import PrimaUpdate
import Pyxis.Components.Accordion as Accordion
import Pyxis.Components.Field.Autocomplete as Autocomplete
import Pyxis.Components.Field.Input as Input
import Pyxis.Components.Field.RadioCardGroup as RadioCardGroup
import Pyxis.Components.Field.Textarea as Textarea
import RemoteData exposing (RemoteData)


type alias Model =
    { data : Data
    , citiesApi : RemoteData Http.Error (List City)
    , showModal : Bool
    , faqs : Accordion.Model
    }


type alias Response =
    { birth : Date
    , claimDate : Date
    , claimType : Fields.Claim
    , dynamic : String
    , insuranceType : Fields.Insurance
    , peopleInvolved : Bool
    , plate : String
    , residentialCity : City
    }


initialModel : Model
initialModel =
    { data = Data.initialData
    , citiesApi = RemoteData.NotAsked
    , showModal = False
    , faqs = Accordion.init (Accordion.singleOpening (Just "accordion-1"))
    }


mapData : (Data -> Data) -> Model -> Model
mapData mapper model =
    { model | data = mapper model.data }


updateDataAndDispatch : (Data -> ( Data, Cmd msg )) -> Model -> ( Model, Cmd msg )
updateDataAndDispatch mapper model =
    let
        ( data, cmd ) =
            mapper model.data
    in
    ( { model | data = data }, cmd )


updateCities : RemoteData Http.Error (List City) -> Model -> Model
updateCities remoteData model =
    { model | citiesApi = remoteData }


updateFaqs : Accordion.Msg -> Model -> ( Model, Cmd Msg )
updateFaqs msg model =
    let
        ( accordionModel, accordionCmd ) =
            Accordion.update msg model.faqs
    in
    { model | faqs = accordionModel }
        |> PrimaUpdate.withCmd (Cmd.map Msg.FaqToggled accordionCmd)


updateModal : Bool -> Model -> ( Model, Cmd Msg )
updateModal isOpen model =
    PrimaUpdate.withoutCmds { model | showModal = isOpen }


submit : Model -> ( Model, Cmd Msg )
submit model =
    model
        |> mapData (\(Data d) -> Data { d | isFormSubmitted = True })
        |> PrimaUpdate.withoutCmds


validate : Data -> Result String Response
validate ((Data config) as data) =
    Ok Response
        |> parseAndThen (Input.validate data config.birth)
        |> parseAndThen (Input.validate data config.claimDate)
        |> parseAndThen (RadioCardGroup.validate data config.claimType)
        |> parseAndThen (Textarea.validate data config.dynamic)
        |> parseAndThen (RadioCardGroup.validate data config.insuranceType)
        |> parseAndThen (RadioCardGroup.validate data config.peopleInvolved)
        |> parseAndThen (Input.validate data config.plate)
        |> parseAndThen (Autocomplete.validate data config.residentialCity)


parseAndThen : Result x a -> Result x (a -> b) -> Result x b
parseAndThen result =
    Result.andThen (\partial -> Result.map partial result)
