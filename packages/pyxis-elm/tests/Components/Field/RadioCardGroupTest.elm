module Components.Field.RadioCardGroupTest exposing (suite)

import Expect
import Fuzz
import Html
import Html.Attributes
import Pyxis.Commons.Attributes as CommonsAttributes
import Pyxis.Components.Field.RadioCardGroup as RadioCardGroup
import Pyxis.Components.IconSet as IconSet
import Test exposing (Test)
import Test.Extra as Test
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import Test.Simulation as Simulation exposing (Simulation)


type Option
    = Home
    | Motor


suite : Test
suite =
    Test.describe "The RadioCardGroup component"
        [ Test.describe "Disabled attribute"
            [ Test.test "should be False by default" <|
                \() ->
                    radioCardGroupConfig noAddonOptions
                        |> renderRadioCardGroup
                        |> findInputs
                        |> Query.each (Query.has [ Selector.disabled False ])
            , Test.fuzz Fuzz.bool "should be rendered correctly" <|
                \b ->
                    radioCardGroupConfig noAddonOptions
                        |> RadioCardGroup.withDisabled b
                        |> renderRadioCardGroup
                        |> findInputs
                        |> Query.each (Query.has [ Selector.disabled b ])
            , Test.test "if disabled, each card has the proper class" <|
                \() ->
                    radioCardGroupConfig noAddonOptions
                        |> RadioCardGroup.withDisabled True
                        |> renderRadioCardGroup
                        |> findCards
                        |> Query.each (Query.has [ Selector.class "form-card--disabled" ])
            ]
        , Test.fuzz Fuzz.string "name attribute should be rendered correctly" <|
            \name ->
                RadioCardGroup.config name
                    |> RadioCardGroup.withOptions noAddonOptions
                    |> renderRadioCardGroup
                    |> findInputs
                    |> Query.each
                        (Query.has
                            [ Selector.attribute (Html.Attributes.name name)
                            ]
                        )
        , Test.test "checked card should have the correct class" <|
            \() ->
                radioCardGroupConfig noAddonOptions
                    |> RadioCardGroup.render identity
                        ()
                        (RadioCardGroup.init |> RadioCardGroup.setValue Home)
                    |> Query.fromHtml
                    |> Query.find [ Selector.containing [ Selector.id "area-home---title-option" ] ]
                    |> Query.has [ Selector.class "form-card--checked" ]
        , Test.describe "ClassList attribute"
            [ Test.fuzzDistinctClassNames3 "should render correctly the given classes" <|
                \s1 s2 s3 ->
                    radioCardGroupConfig noAddonOptions
                        |> RadioCardGroup.withClassList [ ( s1, True ), ( s2, False ), ( s3, True ) ]
                        |> renderRadioCardGroup
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
                    radioCardGroupConfig noAddonOptions
                        |> RadioCardGroup.withClassList [ ( s1, True ), ( s2, True ) ]
                        |> RadioCardGroup.withClassList [ ( s3, True ) ]
                        |> renderRadioCardGroup
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
                    radioCardGroupConfig noAddonOptions
                        |> RadioCardGroup.withLayout RadioCardGroup.vertical
                        |> renderRadioCardGroup
                        |> Query.has
                            [ Selector.classes [ "form-card-group--column" ]
                            ]
            ]
        , Test.describe "Large Size"
            [ Test.test "should have the class for the large" <|
                \() ->
                    radioCardGroupConfig noAddonOptions
                        |> RadioCardGroup.withSize RadioCardGroup.large
                        |> renderRadioCardGroup
                        |> findCards
                        |> Query.each (Query.has [ Selector.classes [ "form-card--large" ] ])
            ]
        , Test.describe "Addon"
            [ Test.test "with image addon should render an image with proper class" <|
                \() ->
                    radioCardGroupConfig withImgAddonOptions
                        |> renderRadioCardGroup
                        |> findCards
                        |> Query.each
                            (Query.has [ Selector.tag "img", Selector.class "form-card__addon" ])
            , Test.test "with text addon should render the text passed with proper class" <|
                \() ->
                    radioCardGroupConfig withTextAddonOptions
                        |> RadioCardGroup.withSize RadioCardGroup.large
                        |> renderRadioCardGroup
                        |> findCards
                        |> Query.each
                            (Query.has [ Selector.text "1.000,00", Selector.class "form-card__addon" ])
            , Test.test "with icon addon should render an Icon with proper class" <|
                \() ->
                    radioCardGroupConfig withIconAddonOptions
                        |> RadioCardGroup.withSize RadioCardGroup.large
                        |> renderRadioCardGroup
                        |> findCards
                        |> Query.each
                            (Query.has
                                [ Selector.attribute (CommonsAttributes.testId (IconSet.toLabel IconSet.Car))
                                , Selector.classes [ "form-card__addon", "form-card__addon--with-icon" ]
                                ]
                            )
            ]
        , Test.describe "Validation"
            [ Test.test "should not pass if the input is not compliant with the validation function" <|
                \() ->
                    simulationWithValidation
                        |> Simulation.simulate ( Event.focus, [ Selector.attribute (CommonsAttributes.testId "area-home---title-option") ] )
                        |> Simulation.simulate ( Event.blur, [ Selector.attribute (CommonsAttributes.testId "area-home---title-option") ] )
                        |> Simulation.expectModel
                            (RadioCardGroup.getValue
                                >> validation {}
                                >> Expect.equal (Err "Required")
                            )
                        |> Simulation.expectHtml (Query.find [ Selector.id "area-error" ] >> Query.contains [ Html.text "Required" ])
                        |> Simulation.run
            ]
        , Test.describe "Events"
            [ Test.test "input should update the model value" <|
                \() ->
                    simulationWithValidation
                        |> simulateEvents "area-home---title-option"
                        |> Simulation.expectModel (RadioCardGroup.getValue >> Expect.equal (Just Home))
                        |> Simulation.run
            ]
        ]


type alias ComponentModel =
    RadioCardGroup.Model Option ComponentMsg


type alias ComponentMsg =
    RadioCardGroup.Msg Option


findInputs : Query.Single msg -> Query.Multiple msg
findInputs =
    Query.findAll [ Selector.tag "input" ]


findCards : Query.Single msg -> Query.Multiple msg
findCards =
    Query.findAll [ Selector.class "form-card" ]


noAddonOptions : List (RadioCardGroup.Option Option)
noAddonOptions =
    [ RadioCardGroup.option
        { value = Home
        , text = Just "Home - description"
        , title = Just "Home - title"
        , addon = Nothing
        }
    , RadioCardGroup.option
        { value = Motor
        , text = Just "Motor - description"
        , title = Just "Motor - title"
        , addon = Nothing
        }
    ]


withImgAddonOptions : List (RadioCardGroup.Option Option)
withImgAddonOptions =
    [ RadioCardGroup.option
        { value = Home
        , text = Just "Home - description"
        , title = Just "Home - title"
        , addon = RadioCardGroup.imgAddon "/home.svg"
        }
    , RadioCardGroup.option
        { value = Motor
        , text = Just "Motor - description"
        , title = Just "Motor - title"
        , addon = RadioCardGroup.imgAddon "/car.svg"
        }
    ]


withIconAddonOptions : List (RadioCardGroup.Option Option)
withIconAddonOptions =
    [ RadioCardGroup.option
        { value = Home
        , text = Just "Home - description"
        , title = Just "Home - title"
        , addon = RadioCardGroup.iconAddon IconSet.Car
        }
    , RadioCardGroup.option
        { value = Motor
        , text = Just "Motor - description"
        , title = Just "Motor - title"
        , addon = RadioCardGroup.iconAddon IconSet.Car
        }
    ]


withTextAddonOptions : List (RadioCardGroup.Option Option)
withTextAddonOptions =
    [ RadioCardGroup.option
        { value = Home
        , text = Just "Home - description"
        , title = Just "Home - title"
        , addon = RadioCardGroup.textAddon "1.000,00"
        }
    , RadioCardGroup.option
        { value = Motor
        , text = Just "Motor - description"
        , title = Just "Motor - title"
        , addon = RadioCardGroup.textAddon "1.000,00"
        }
    ]


radioCardGroupConfig : List (RadioCardGroup.Option Option) -> RadioCardGroup.Config () Option Option
radioCardGroupConfig options =
    RadioCardGroup.config "area"
        |> RadioCardGroup.withOptions options
        |> RadioCardGroup.withId "area"
        |> RadioCardGroup.withValidationOnBlur validation False


renderRadioCardGroup : RadioCardGroup.Config () Option Option -> Query.Single ComponentMsg
renderRadioCardGroup =
    RadioCardGroup.render identity () RadioCardGroup.init
        >> Query.fromHtml


simulationWithValidation : Simulation.Simulation ComponentModel ComponentMsg
simulationWithValidation =
    Simulation.fromSandbox
        { init = RadioCardGroup.init
        , update = \subMsg model -> Tuple.first (RadioCardGroup.update subMsg model)
        , view = \model -> RadioCardGroup.render identity () model (radioCardGroupConfig noAddonOptions)
        }


validation : ctx -> Maybe Option -> Result String Option
validation _ value =
    value
        |> Maybe.map Ok
        |> Maybe.withDefault (Err "Required")


simulateEvents : String -> Simulation ComponentModel ComponentMsg -> Simulation ComponentModel ComponentMsg
simulateEvents testId simulation =
    Simulation.simulate ( Event.check True, [ Selector.attribute (CommonsAttributes.testId testId) ] ) simulation
