module Components.Field.TextareaTest exposing (suite)

import Expect
import Fuzz
import Html.Attributes
import Pyxis.Components.Field.Label as LabelField
import Pyxis.Components.Field.Textarea as TextareaField
import Test exposing (Test)
import Test.Extra as Test
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import Test.Simulation as Simulation exposing (Simulation)


suite : Test
suite =
    Test.describe "The Textarea component"
        [ Test.describe "Default"
            [ Test.test "the textarea has an id and a data-test-id" <|
                \() ->
                    fieldConfig
                        |> fieldRender () fieldModel
                        |> findTextarea
                        |> Query.has
                            [ Selector.attribute (Html.Attributes.id "textarea-id")
                            , Selector.attribute (Html.Attributes.attribute "data-test-id" "textarea-id")
                            , Selector.classes [ "form-field__textarea" ]
                            ]
            ]
        , Test.describe "Label"
            [ Test.fuzz Fuzz.string "the input has label" <|
                \s ->
                    fieldConfig
                        |> TextareaField.withLabel (LabelField.config s)
                        |> fieldRender () fieldModel
                        |> findLabel
                        |> Query.has
                            [ Selector.text s
                            ]
            ]
        , Test.describe "Disabled attribute"
            [ Test.test "should be False by default" <|
                \() ->
                    fieldConfig
                        |> fieldRender () fieldModel
                        |> findTextarea
                        |> Query.has [ Selector.disabled False ]
            , Test.fuzz Fuzz.bool "should be rendered correctly" <|
                \b ->
                    fieldConfig
                        |> TextareaField.withDisabled b
                        |> fieldRender () fieldModel
                        |> findTextarea
                        |> Query.has [ Selector.disabled b ]
            ]
        , Test.fuzz Fuzz.string "name attribute should be rendered correctly" <|
            \name ->
                TextareaField.config name
                    |> fieldRender () fieldModel
                    |> findTextarea
                    |> Query.has
                        [ Selector.attribute (Html.Attributes.name name)
                        ]
        , Test.fuzz Fuzz.string "placeholder attribute should be rendered correctly" <|
            \p ->
                fieldConfig
                    |> TextareaField.withPlaceholder p
                    |> fieldRender () fieldModel
                    |> findTextarea
                    |> Query.has
                        [ Selector.attribute (Html.Attributes.placeholder p)
                        ]
        , Test.describe "ClassList attribute"
            [ Test.fuzzDistinctClassNames3 "should render correctly the given classes" <|
                \s1 s2 s3 ->
                    fieldConfig
                        |> TextareaField.withClassList [ ( s1, True ), ( s2, False ), ( s3, True ) ]
                        |> fieldRender () fieldModel
                        |> findTextarea
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
                    fieldConfig
                        |> TextareaField.withClassList [ ( s1, True ), ( s2, True ) ]
                        |> TextareaField.withClassList [ ( s3, True ) ]
                        |> fieldRender () fieldModel
                        |> findTextarea
                        |> Expect.all
                            [ Query.hasNot
                                [ Selector.classes [ s1, s2 ]
                                ]
                            , Query.has
                                [ Selector.classes [ s3 ]
                                ]
                            ]
            ]
        , Test.describe "Validation"
            [ Test.test "should pass initially if no validation is applied" <|
                \() ->
                    fieldModel
                        |> TextareaField.getValue
                        |> Expect.equal ""
            ]
        , Test.describe "Value mapper"
            [ Test.fuzz Fuzz.string "maps the inputted string" <|
                \str ->
                    simulation (TextareaField.config "" |> TextareaField.withValueMapper String.toUpper)
                        |> Simulation.simulate ( Event.input str, [ Selector.tag "textarea" ] )
                        |> Simulation.expectModel (TextareaField.getValue >> Expect.equal (String.toUpper str))
                        |> Simulation.run
            ]
        ]


type alias ComponentModel =
    TextareaField.Model TextareaField.Msg


type alias ComponentMsg =
    TextareaField.Msg


findTextarea : Query.Single msg -> Query.Single msg
findTextarea =
    Query.find [ Selector.tag "textarea" ]


findLabel : Query.Single msg -> Query.Single msg
findLabel =
    Query.find [ Selector.tag "label", Selector.class "form-label" ]


fieldModel : ComponentModel
fieldModel =
    TextareaField.init ""


fieldConfig : TextareaField.Config () String
fieldConfig =
    TextareaField.config "name"
        |> TextareaField.withId "textarea-id"


fieldRender : () -> ComponentModel -> TextareaField.Config () String -> Query.Single TextareaField.Msg
fieldRender ctx model =
    TextareaField.render identity ctx model >> Query.fromHtml


simulation : TextareaField.Config () String -> Simulation ComponentModel ComponentMsg
simulation config =
    Simulation.fromSandbox
        { init = TextareaField.init ""
        , update = \subMsg model -> Tuple.first (TextareaField.update subMsg model)
        , view = \model -> TextareaField.render identity () model config
        }
