module Components.Field.RadioGroupTest exposing (suite)

import Commons.Attributes as CA
import Components.Field.RadioGroup as RadioGroup
import Expect
import Fuzz
import Html
import Html.Attributes
import Test exposing (Test)
import Test.Extra as Test
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import Test.Simulation as Simulation


type Option
    = M
    | F
    | Default


type Msg
    = Tagger (RadioGroup.Msg Option)


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
                radioGroupConfig
                    |> RadioGroup.withName name
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
                        |> Simulation.expectModel
                            (RadioGroup.getValue
                                >> validation {}
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
                        |> Simulation.expectModel (RadioGroup.getValue >> Expect.equal M)
                        |> Simulation.run
            ]
        ]


findInputs : Query.Single Msg -> Query.Multiple Msg
findInputs =
    Query.findAll [ Selector.tag "input" ]


radioOptions : List (RadioGroup.Option Option)
radioOptions =
    [ RadioGroup.option { value = M, label = "Male" }
    , RadioGroup.option { value = F, label = "Female" }
    ]


radioGroupConfig : RadioGroup.Config Msg Option
radioGroupConfig =
    RadioGroup.config Tagger "gender" |> RadioGroup.withOptions radioOptions


renderRadioGroup : RadioGroup.Config Msg Option -> Query.Single Msg
renderRadioGroup =
    RadioGroup.render {} (RadioGroup.init Default validation)
        >> Query.fromHtml


simulationWithValidation : Simulation.Simulation (RadioGroup.Model {} Option) Msg
simulationWithValidation =
    Simulation.fromSandbox
        { init = RadioGroup.init Default validation
        , update = \(Tagger subMsg) model -> RadioGroup.update {} subMsg model
        , view = \model -> RadioGroup.render {} model radioGroupConfig
        }


validation : ctx -> Option -> Result String Option
validation _ value =
    if value == Default then
        Err "Required"

    else
        Ok value


simulateEvents : String -> Simulation.Simulation (RadioGroup.Model {} Option) Msg -> Simulation.Simulation (RadioGroup.Model {} Option) Msg
simulateEvents testId simulation =
    simulation
        |> Simulation.simulate ( Event.check True, [ Selector.attribute (CA.testId testId) ] )
