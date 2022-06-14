module Components.Field.RadioGroupTest exposing (suite)

import Expect
import Fuzz
import Html
import Html.Attributes
import Pyxis.Commons.Attributes as CommonsAttributes
import Pyxis.Components.Field.RadioGroup as RadioGroup
import Test exposing (Test)
import Test.Extra as Test
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import Test.Simulation as Simulation


type Option
    = M
    | F


suite : Test
suite =
    Test.describe "The RadioGroup component"
        [ Test.describe "Disabled attribute"
            [ Test.test "should be False by default" <|
                \() ->
                    radioGroupConfig
                        |> renderRadioGroup
                        |> findInputs
                        |> Query.each (Query.has [ Selector.disabled False ])
            , Test.fuzz Fuzz.bool "should be rendered correctly" <|
                \b ->
                    radioGroupConfig
                        |> RadioGroup.withDisabled b
                        |> renderRadioGroup
                        |> findInputs
                        |> Query.each (Query.has [ Selector.disabled b ])
            ]
        , Test.fuzz Fuzz.string "name attribute should be rendered correctly" <|
            \name ->
                RadioGroup.config name
                    |> renderRadioGroup
                    |> findInputs
                    |> Query.each
                        (Query.has
                            [ Selector.attribute (Html.Attributes.name name)
                            ]
                        )
        , Test.describe "ClassList attribute"
            [ Test.fuzzDistinctClassNames3 "should render correctly the given classes" <|
                \s1 s2 s3 ->
                    radioGroupConfig
                        |> RadioGroup.withClassList [ ( s1, True ), ( s2, False ), ( s3, True ) ]
                        |> renderRadioGroup
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
                    radioGroupConfig
                        |> RadioGroup.withClassList [ ( s1, True ), ( s2, True ) ]
                        |> RadioGroup.withClassList [ ( s3, True ) ]
                        |> renderRadioGroup
                        |> Expect.all
                            [ Query.has
                                [ Selector.classes [ s3 ]
                                ]
                            , Query.hasNot
                                [ Selector.classes [ s1, s2 ]
                                ]
                            ]
            ]
        , Test.describe "Vertical layout"
            [ Test.test "should have the class for the vertical layout" <|
                \() ->
                    radioGroupConfig
                        |> RadioGroup.withLayout RadioGroup.vertical
                        |> renderRadioGroup
                        |> Query.has
                            [ Selector.classes [ "form-control-group--column" ]
                            ]
            ]
        , Test.describe "Validation"
            [ Test.test "should not pass if the input is not compliant with the validation function" <|
                \() ->
                    simulationWithValidation
                        |> Simulation.simulate ( Event.focus, [ Selector.attribute (CommonsAttributes.testId "gender-male-option") ] )
                        |> Simulation.simulate ( Event.blur, [ Selector.attribute (CommonsAttributes.testId "gender-male-option") ] )
                        |> Simulation.expectModel
                            (RadioGroup.validate ()
                                >> Expect.equal (Err "Required")
                            )
                        |> Simulation.expectHtml (Query.find [ Selector.id "gender-error" ] >> Query.contains [ Html.text "Required" ])
                        |> Simulation.run
            ]
        , Test.describe "Events"
            [ Test.test "input should update the model value" <|
                \() ->
                    simulationWithValidation
                        |> simulateEvents "gender-male-option"
                        |> Simulation.expectModel (RadioGroup.getValue >> Expect.equal (Just M))
                        |> Simulation.run
            ]
        ]


type alias ComponentModel =
    RadioGroup.Model () Option Option ComponentMsg


type alias ComponentMsg =
    RadioGroup.Msg Option


findInputs : Query.Single msg -> Query.Multiple msg
findInputs =
    Query.findAll [ Selector.tag "input" ]


radioOptions : List (RadioGroup.Option Option)
radioOptions =
    [ RadioGroup.option { value = M, label = "Male" }
    , RadioGroup.option { value = F, label = "Female" }
    ]


radioGroupConfig : RadioGroup.Config Option
radioGroupConfig =
    RadioGroup.config "gender"
        |> RadioGroup.withOptions radioOptions
        |> RadioGroup.withId "gender"


renderRadioGroup : RadioGroup.Config Option -> Query.Single ComponentMsg
renderRadioGroup =
    RadioGroup.render identity () (RadioGroup.init Nothing validation)
        >> Query.fromHtml


simulationWithValidation : Simulation.Simulation ComponentModel ComponentMsg
simulationWithValidation =
    Simulation.fromSandbox
        { init = RadioGroup.init Nothing validation
        , update = \subMsg model -> Tuple.first (RadioGroup.update subMsg model)
        , view = \model -> RadioGroup.render identity () model radioGroupConfig
        }


validation : ctx -> Maybe Option -> Result String Option
validation _ value =
    value
        |> Maybe.map Ok
        |> Maybe.withDefault (Err "Required")


simulateEvents :
    String
    -> Simulation.Simulation ComponentModel ComponentMsg
    -> Simulation.Simulation ComponentModel ComponentMsg
simulateEvents testId simulation =
    simulation
        |> Simulation.simulate ( Event.check True, [ Selector.attribute (CommonsAttributes.testId testId) ] )
