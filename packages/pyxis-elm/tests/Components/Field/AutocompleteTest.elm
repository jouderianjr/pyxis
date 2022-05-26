module Components.Field.AutocompleteTest exposing (suite)

import Expect
import Fuzz
import Html
import Html.Attributes
import Pyxis.Components.Button as Button
import Pyxis.Components.Field.Autocomplete as Autocomplete
import Pyxis.Components.Field.Label as Label
import Pyxis.Components.IconSet as IconSet
import RemoteData
import Test exposing (Test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import Test.Simulation as Simulation exposing (Simulation)


type Job
    = Developer
    | Designer
    | ProductManager


filterJobs : String -> Job -> Bool
filterJobs filter =
    getJobName >> String.contains filter


getJobName : Job -> String
getJobName job =
    case job of
        Developer ->
            "DEVELOPER"

        Designer ->
            "DESIGNER"

        ProductManager ->
            "PRODUCT_MANAGER"


suite : Test
suite =
    Test.describe "The Autocomplete component"
        [ Test.fuzz Fuzz.string "should set an additional content" <|
            \s ->
                config
                    |> Autocomplete.withAdditionalContent (Html.span [] [ Html.text s ])
                    |> render
                    |> Query.find [ Selector.tag "span" ]
                    |> Query.has [ Selector.text s ]
        , Test.fuzz Fuzz.string "should set a disabled attribute" <|
            \s ->
                config
                    |> Autocomplete.withDisabled True
                    |> render
                    |> findInput
                    |> Query.has [ Selector.attribute (Html.Attributes.disabled True) ]
        , Test.fuzz Fuzz.string "should add a label" <|
            \s ->
                config
                    |> Autocomplete.withLabel (Label.config s)
                    |> render
                    |> Query.find
                        [ Selector.tag "label"
                        , Selector.class "form-label"
                        ]
                    |> Query.has [ Selector.text s ]
        , Test.fuzz Fuzz.string "should set a name attribute" <|
            \s ->
                Autocomplete.config s
                    |> render
                    |> findInput
                    |> Query.has [ Selector.attribute (Html.Attributes.name s) ]
        , Test.fuzz Fuzz.string "should set a placeholder attribute" <|
            \s ->
                config
                    |> Autocomplete.withPlaceholder s
                    |> render
                    |> findInput
                    |> Query.has [ Selector.attribute (Html.Attributes.placeholder s) ]
        , Test.test "should set a size" <|
            \() ->
                config
                    |> Autocomplete.withSize Autocomplete.small
                    |> render
                    |> findInput
                    |> Query.has [ Selector.class "form-field__autocomplete--small" ]
        , Test.test "Show the custom message when no result is found" <|
            \() ->
                config
                    |> Autocomplete.withNoResultsFoundMessage "Nothing was found."
                    |> simulation
                    |> Simulation.simulate ( Event.focus, [ Selector.class "form-field__autocomplete" ] )
                    |> Simulation.simulate ( Event.input "A very long search term which will match no results.", [ Selector.class "form-field__autocomplete" ] )
                    |> Simulation.expectHtml
                        (findDropdown >> Query.has [ Selector.text "Nothing was found." ])
                    |> Simulation.run
        , Test.describe "Addon"
            [ Test.test "Show action under no result message" <|
                \() ->
                    config
                        |> Autocomplete.withAddonAction
                            (Button.ghost
                                |> Button.withText "Visit the page"
                                |> Button.withType (Button.link "https://www.google.com")
                                |> Button.render
                            )
                        |> simulation
                        |> Simulation.simulate ( Event.focus, [ Selector.class "form-field__autocomplete" ] )
                        |> Simulation.simulate ( Event.input "Qwerty", [ Selector.class "form-field__autocomplete" ] )
                        |> Simulation.expectHtml
                            (findDropdown
                                >> Query.find [ Selector.class "form-dropdown__no-results__action" ]
                                >> Query.has [ Selector.text "Visit the page", Selector.attribute (Html.Attributes.href "https://www.google.com") ]
                            )
                        |> Simulation.run
            , Test.test "Prepend an header to the option list" <|
                \() ->
                    config
                        |> Autocomplete.withAddonHeader "Choose a role:"
                        |> simulation
                        |> Simulation.simulate ( Event.focus, [ Selector.class "form-field__autocomplete" ] )
                        |> Simulation.simulate ( Event.input "D", [ Selector.class "form-field__autocomplete" ] )
                        |> Simulation.expectHtml
                            (findDropdown
                                >> Query.find [ Selector.class "form-dropdown__header" ]
                                >> Query.has [ Selector.text "Choose a role:" ]
                            )
                        |> Simulation.run
            , Test.test "On focus the suggestion should be visible" <|
                \() ->
                    config
                        |> Autocomplete.withAddonSuggestion { title = "Suggestion", subtitle = Just "Subtitle", icon = IconSet.Search }
                        |> render
                        |> findDropdown
                        |> Query.find [ Selector.class "form-dropdown__suggestion" ]
                        |> Query.has [ Selector.text "Suggestion", Selector.text "Subtitle" ]
            ]
        , Test.describe "Update"
            [ Test.test "Inputting a given option should update the model" <|
                \() ->
                    config
                        |> simulation
                        |> Simulation.simulate ( Event.focus, [ Selector.class "form-field__autocomplete" ] )
                        |> Simulation.simulate ( Event.input "DEVELOPER", [ Selector.class "form-field__autocomplete" ] )
                        |> Simulation.simulate ( Event.click, [ Selector.class "form-dropdown__item" ] )
                        |> Simulation.expectModel
                            (Expect.all
                                [ Autocomplete.validate () >> Expect.equal (Ok Developer)
                                ]
                            )
                        |> Simulation.run
            ]
        ]


config : Autocomplete.Config Job (Autocomplete.Msg Job)
config =
    Autocomplete.config "autocomplete"
        |> Autocomplete.withId "autocomplete-id"


init : Autocomplete.Model () Job
init =
    Autocomplete.init Nothing getJobName filterJobs (always validation)


findInput : Query.Single msg -> Query.Single msg
findInput =
    Query.find [ Selector.class "form-field__autocomplete" ]


findDropdown : Query.Single msg -> Query.Single msg
findDropdown =
    Query.find [ Selector.class "form-dropdown" ]


render : Autocomplete.Config Job (Autocomplete.Msg Job) -> Query.Single (Autocomplete.Msg Job)
render =
    Autocomplete.render identity () init >> Query.fromHtml


validation : Maybe Job -> Result String Job
validation maybeJob =
    maybeJob
        |> Maybe.map Ok
        |> Maybe.withDefault (Err "Select a job.")


simulation : Autocomplete.Config Job (Autocomplete.Msg Job) -> Simulation (Autocomplete.Model () Job) (Autocomplete.Msg Job)
simulation config_ =
    Simulation.fromElement
        { init =
            ( Autocomplete.init Nothing getJobName filterJobs (always validation)
                |> Autocomplete.setOptions (RemoteData.Success [ Developer, Designer, ProductManager ])
            , Cmd.none
            )
        , update = \msg model -> Autocomplete.update msg model
        , view = \model -> Autocomplete.render identity () model config_
        }
