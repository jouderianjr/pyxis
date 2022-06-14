module Components.Field.SelectTest exposing (suite)

import Expect
import Fuzz
import Html.Attributes
import Pyxis.Components.Field.Select as Select
import Test exposing (Test)
import Test.Extra as Test
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import Test.Simulation as Simulation exposing (Simulation)


type Job
    = Developer
    | Designer
    | ProductManager


suite : Test
suite =
    Test.describe "The Select component"
        [ Test.describe "Default"
            [ Test.fuzz Fuzz.string "the input has an id and a data-test-id" <|
                \id ->
                    Select.config False
                        |> renderSelect "select" id
                        |> Query.has
                            [ Selector.attribute (Html.Attributes.id id)
                            , Selector.attribute (Html.Attributes.attribute "data-test-id" id)
                            ]
            ]
        , Test.describe "Disabled attribute"
            [ Test.test "should be False by default" <|
                \() ->
                    Select.config False
                        |> renderSelect "select" "select-id"
                        |> findSelect
                        |> Query.has [ Selector.disabled False ]
            , Test.fuzz Fuzz.bool "should be rendered correctly" <|
                \b ->
                    Select.config False
                        |> Select.withDisabled b
                        |> renderSelect "select" "select-id"
                        |> findSelect
                        |> Query.has [ Selector.disabled b ]
            ]
        , Test.fuzz Fuzz.string "name attribute should be rendered correctly" <|
            \name ->
                Select.config False
                    |> renderSelect name "select-id"
                    |> findSelect
                    |> Query.has
                        [ Selector.attribute (Html.Attributes.name name)
                        ]
        , Test.fuzz Fuzz.string "placeholder attribute should be rendered correctly" <|
            \p ->
                Select.config False
                    |> Select.withPlaceholder p
                    |> renderSelect "select" "select-id"
                    |> findSelect
                    |> Query.has
                        [ Selector.tag "option"
                        , Selector.text p
                        ]
        , Test.fuzz Fuzz.string "error message should be rendered correctly" <|
            \p ->
                Select.config False
                    |> Select.withPlaceholder p
                    |> renderSelect "select" "select-id"
                    |> findSelect
                    |> Query.has
                        [ Selector.tag "option"
                        , Selector.text p
                        ]
        , Test.describe "ClassList attribute"
            [ Test.fuzzDistinctClassNames3 "should render correctly the given classes" <|
                \s1 s2 s3 ->
                    Select.config False
                        |> Select.withClassList [ ( s1, True ), ( s2, False ), ( s3, True ) ]
                        |> renderSelect "select" "select-id"
                        |> findSelect
                        |> Expect.all
                            [ Query.has
                                [ Selector.classes [ s1, s3 ]
                                ]
                            , Query.hasNot
                                [ Selector.classes [ s2 ]
                                ]
                            ]
            , Test.fuzzDistinctClassNames3 "should only render the last pipe value" <|
                \s1 s2 s3 ->
                    Select.config False
                        |> Select.withClassList [ ( s1, True ), ( s2, True ) ]
                        |> Select.withClassList [ ( s3, True ) ]
                        |> renderSelect "select" "select-id"
                        |> findSelect
                        |> Expect.all
                            [ Query.hasNot
                                [ Selector.classes [ s1, s2 ]
                                ]
                            , Query.has
                                [ Selector.classes [ s3 ]
                                ]
                            ]
            ]
        , Test.describe "Update"
            [ Test.test "Inputting a given option should update the model" <|
                \() ->
                    simulationDesktop
                        |> Simulation.simulate ( Event.input "DEVELOPER", [ Selector.tag "select" ] )
                        |> Simulation.expectModel
                            (Expect.all
                                [ Select.validate () >> Expect.equal (Ok Developer)
                                ]
                            )
                        |> Simulation.run
            ]
        ]


findSelect : Query.Single msg -> Query.Single msg
findSelect =
    Query.find [ Selector.tag "select" ]


renderSelect : String -> String -> Select.Config -> Query.Single Select.Msg
renderSelect name id =
    Select.render identity
        ()
        (Select.init name Nothing (always Ok)
            |> Select.setId id
        )
        >> Query.fromHtml


requiredFieldValidation : Maybe a -> Result String a
requiredFieldValidation m =
    case m of
        Nothing ->
            Err "Required field"

        Just str ->
            Ok str


validateJob : String -> Result String Job
validateJob job =
    case job of
        "DEVELOPER" ->
            Ok Developer

        "DESIGNER" ->
            Ok Designer

        "PRODUCT_MANAGER" ->
            Ok ProductManager

        _ ->
            Err "Inserire opzione valida"


simulationDesktop : Simulation (Select.Model () Job Select.Msg) Select.Msg
simulationDesktop =
    Simulation.fromElement
        { init =
            ( Select.init "select"
                Nothing
                (always (requiredFieldValidation >> Result.andThen validateJob))
                |> Select.setOptions
                    [ Select.option { value = "DEVELOPER", label = "Developer" }
                    , Select.option { value = "DESIGNER", label = "Designer" }
                    , Select.option { value = "PRODUCT_MANAGER", label = "Product Manager" }
                    ]
            , Cmd.none
            )
        , update = Select.update identity
        , view =
            \model ->
                Select.config False
                    |> Select.render identity () model
        }
