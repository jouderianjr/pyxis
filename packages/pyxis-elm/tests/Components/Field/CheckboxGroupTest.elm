module Components.Field.CheckboxGroupTest exposing (suite)

import Expect
import Fuzz
import Fuzz.Extra
import Html
import Html.Attributes
import Json.Encode
import Pyxis.Components.Field.CheckboxGroup as CheckboxGroup
import Test exposing (Test)
import Test.Extra as TestExtra
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import Test.Simulation as Simulation exposing (Simulation)


type Lang
    = Elm
    | Typescript
    | Rust
    | Elixir


langsConfig : CheckboxGroup.Config Lang msg
langsConfig =
    CheckboxGroup.config "checkbox"
        |> CheckboxGroup.withOptions langsOptions


langsOptions : List (CheckboxGroup.Option Lang msg)
langsOptions =
    [ CheckboxGroup.option { value = Elm, label = Html.text "Elm" }
    , CheckboxGroup.option { value = Typescript, label = Html.text "Typescript" }
    , CheckboxGroup.option { value = Rust, label = Html.text "Rust" }
    , CheckboxGroup.option { value = Elixir, label = Html.text "Elixir" }
    ]


suite : Test
suite =
    Test.describe "The CheckboxGroup component"
        [ Test.describe "Id"
            [ Test.fuzz Fuzz.Extra.nonEmptyString "the CheckboxGroup has an id and a data-test-id" <|
                \id ->
                    CheckboxGroup.config "name"
                        |> CheckboxGroup.withId id
                        |> renderCheckboxGroup
                        |> Query.has
                            [ Selector.attribute (Html.Attributes.id id)
                            , Selector.attribute (Html.Attributes.attribute "data-test-id" id)
                            ]
            ]
        , Test.describe "Disabled attribute"
            [ Test.test "should be False by default" <|
                \() ->
                    langsConfig
                        |> renderCheckboxGroup
                        |> findInput "Elixir"
                        |> Query.has [ Selector.disabled False ]
            , Test.fuzz Fuzz.bool "should be rendered correctly" <|
                \b ->
                    CheckboxGroup.config "checkbox"
                        |> CheckboxGroup.withOptions
                            [ CheckboxGroup.option { value = Elm, label = Html.text "Elm" }
                            , CheckboxGroup.option { value = Typescript, label = Html.text "Typescript" }
                            , CheckboxGroup.option { value = Rust, label = Html.text "Rust" }
                            , CheckboxGroup.option { value = Elixir, label = Html.text "Elixir" }
                                |> CheckboxGroup.withDisabledOption b
                            ]
                        |> renderCheckboxGroup
                        |> findInput "Elixir"
                        |> Query.has [ Selector.disabled b ]
            ]
        , Test.fuzz Fuzz.string "name attribute should be rendered correctly on every input" <|
            \name ->
                let
                    hasName : Query.Single msg -> Expect.Expectation
                    hasName =
                        Query.has
                            [ Selector.attribute (Html.Attributes.name name)
                            ]
                in
                CheckboxGroup.config name
                    |> CheckboxGroup.withOptions langsOptions
                    |> CheckboxGroup.withId name
                    |> renderCheckboxGroup
                    |> Expect.all
                        [ findInput "Elm" >> hasName
                        , findInput "Typescript" >> hasName
                        , findInput "Rust" >> hasName
                        , findInput "Elixir" >> hasName
                        ]
        , Test.describe "ClassList attribute"
            [ TestExtra.fuzzDistinctClassNames3 "should render correctly the given classes" <|
                \s1 s2 s3 ->
                    CheckboxGroup.config "checkbox-id"
                        |> CheckboxGroup.withClassList [ ( s1, True ), ( s2, False ), ( s3, True ) ]
                        |> renderCheckboxGroup
                        |> Expect.all
                            [ Query.has
                                [ Selector.classes [ s1, s3 ]
                                ]
                            , Query.hasNot
                                [ Selector.classes [ s2 ]
                                ]
                            ]
            , TestExtra.fuzzDistinctClassNames3 "should only render the last pipe value" <|
                \s1 s2 s3 ->
                    CheckboxGroup.config "checkbox-id"
                        |> CheckboxGroup.withClassList [ ( s1, True ), ( s2, True ) ]
                        |> CheckboxGroup.withClassList [ ( s3, True ) ]
                        |> renderCheckboxGroup
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
            [ Test.test "selecting options" <|
                \() ->
                    simulation
                        |> Simulation.simulate (check "Typescript" True)
                        |> Simulation.expectModel
                            (CheckboxGroup.getValue
                                >> List.member Typescript
                                >> Expect.true "`Typescript` option should be selected"
                            )
                        |> Simulation.run
            , Test.test "unselecting options" <|
                \() ->
                    simulation
                        |> Simulation.simulate (check "Typescript" True)
                        |> Simulation.simulate (check "Typescript" False)
                        |> Simulation.expectModel
                            (CheckboxGroup.getValue
                                >> List.member Typescript
                                >> Expect.false "`Typescript` option should not be selected"
                            )
                        |> Simulation.run
            ]
        , Test.describe "Validation"
            [ Test.test "should be applied initially" <|
                \() ->
                    CheckboxGroup.init [] nonEmptyLangValidation
                        |> CheckboxGroup.validate ()
                        |> Expect.err
            , Test.test "should update when selecting items" <|
                \() ->
                    simulation
                        |> Simulation.simulate (check "Typescript" True)
                        |> Simulation.simulate (check "Elixir" True)
                        |> Simulation.simulate (check "Elixir" False)
                        |> Simulation.expectModel
                            (\model ->
                                model
                                    |> CheckboxGroup.validate ()
                                    |> whenOk
                                        (\( hd, tl ) ->
                                            Expect.all
                                                [ List.member Typescript >> Expect.true "`Typescript` option should  be selected"
                                                , List.member Elixir >> Expect.false "`Elixir` option should not be selected"
                                                , List.member Rust >> Expect.false "`Rust` option should not be selected"
                                                ]
                                                (hd :: tl)
                                        )
                            )
                        |> Simulation.run
            , Test.test "should update when selecting items (1)" <|
                \() ->
                    simulation
                        |> Simulation.simulate (check "Typescript" True)
                        |> Simulation.simulate (check "Elixir" True)
                        |> Simulation.simulate (check "Elixir" False)
                        |> Simulation.simulate (check "Typescript" False)
                        |> Simulation.expectModel
                            (\model ->
                                model
                                    |> CheckboxGroup.validate ()
                                    |> Expect.err
                            )
                        |> Simulation.run
            ]
        ]


whenOk : (value -> Expect.Expectation) -> Result String value -> Expect.Expectation
whenOk expectation result =
    case result of
        Err err ->
            Expect.fail err

        Ok x ->
            expectation x


check : String -> Bool -> ( ( String, Json.Encode.Value ), List Selector.Selector )
check label b =
    ( Event.check b
    , inputSelectors label
    )


inputSelectors : String -> List Selector.Selector
inputSelectors label =
    [ Selector.all
        [ Selector.tag "label"
        , Selector.containing [ Selector.text label ]
        ]
    , Selector.tag "input"
    ]


findInput : String -> Query.Single msg -> Query.Single msg
findInput label =
    Query.find (inputSelectors label)


renderCheckboxGroup : CheckboxGroup.Config value (CheckboxGroup.Msg value) -> Query.Single (CheckboxGroup.Msg value)
renderCheckboxGroup =
    CheckboxGroup.render identity () (CheckboxGroup.init [] (always Ok)) >> Query.fromHtml


type alias NonemptyList a =
    ( a, List a )


nonEmptyLangValidation : () -> List Lang -> Result String (NonemptyList Lang)
nonEmptyLangValidation () langs =
    case langs of
        [] ->
            Err "You must select at least one option"

        hd :: tl ->
            Ok ( hd, tl )


simulation :
    Simulation
        (CheckboxGroup.Model () Lang (NonemptyList Lang))
        (CheckboxGroup.Msg Lang)
simulation =
    Simulation.fromSandbox
        { init = CheckboxGroup.init [] nonEmptyLangValidation
        , update = CheckboxGroup.update
        , view = \model -> CheckboxGroup.render identity () model langsConfig
        }
