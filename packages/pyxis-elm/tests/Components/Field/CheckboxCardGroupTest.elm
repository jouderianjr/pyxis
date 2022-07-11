module Components.Field.CheckboxCardGroupTest exposing (suite)

import Expect
import Fuzz
import Fuzz.Extra
import Html.Attributes
import Json.Encode
import Pyxis.Components.Field.CheckboxCardGroup as CheckboxCardGroup
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


langsConfig : CheckboxCardGroup.Config () Lang parsedValue
langsConfig =
    CheckboxCardGroup.config "checkbox"
        |> CheckboxCardGroup.withOptions langsOptions


langsOptions : List (CheckboxCardGroup.Option Lang)
langsOptions =
    [ CheckboxCardGroup.option { value = Elm, title = Just "Elm", text = Nothing, addon = Nothing }
    , CheckboxCardGroup.option { value = Typescript, title = Just "Typescript", text = Nothing, addon = Nothing }
    , CheckboxCardGroup.option { value = Rust, title = Just "Rust", text = Nothing, addon = Nothing }
    , CheckboxCardGroup.option { value = Elixir, title = Just "Elixir", text = Nothing, addon = Nothing }
    ]


suite : Test
suite =
    Test.describe "The CheckboxGroup component"
        [ Test.describe "Id"
            [ Test.fuzz Fuzz.Extra.nonEmptyString "the CheckboxGroup has an id and a data-test-id" <|
                \id ->
                    CheckboxCardGroup.config "name"
                        |> CheckboxCardGroup.withId id
                        |> renderCheckboxGroup
                        |> Query.find [ Selector.class "form-card-group" ]
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
                    CheckboxCardGroup.config "checkbox"
                        |> CheckboxCardGroup.withOptions
                            [ CheckboxCardGroup.option { value = Elm, title = Just "Elm", text = Nothing, addon = Nothing }
                            , CheckboxCardGroup.option { value = Typescript, title = Just "Typescript", text = Nothing, addon = Nothing }
                            , CheckboxCardGroup.option { value = Rust, title = Just "Rust", text = Nothing, addon = Nothing }
                            , CheckboxCardGroup.option { value = Elixir, title = Just "Elixir", text = Nothing, addon = Nothing }
                                |> CheckboxCardGroup.withDisabledOption b
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
                CheckboxCardGroup.config name
                    |> CheckboxCardGroup.withOptions langsOptions
                    |> CheckboxCardGroup.withId name
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
                    CheckboxCardGroup.config "checkbox"
                        |> CheckboxCardGroup.withClassList [ ( s1, True ), ( s2, False ), ( s3, True ) ]
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
                    CheckboxCardGroup.config "checkbox"
                        |> CheckboxCardGroup.withClassList [ ( s1, True ), ( s2, True ) ]
                        |> CheckboxCardGroup.withClassList [ ( s3, True ) ]
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
                            (CheckboxCardGroup.getValue
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
                            (CheckboxCardGroup.getValue
                                >> List.member Typescript
                                >> Expect.false "`Typescript` option should not be selected"
                            )
                        |> Simulation.run
            ]
        , Test.describe "Validation"
            [ Test.test "should be applied initially" <|
                \() ->
                    CheckboxCardGroup.init
                        |> CheckboxCardGroup.getValue
                        |> nonEmptyLangValidation ()
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
                                    |> CheckboxCardGroup.getValue
                                    |> nonEmptyLangValidation ()
                                    |> whenOk
                                        (Expect.all
                                            [ List.member Typescript >> Expect.true "`Typescript` option should  be selected"
                                            , List.member Elixir >> Expect.false "`Elixir` option should not be selected"
                                            , List.member Rust >> Expect.false "`Rust` option should not be selected"
                                            ]
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
                                    |> CheckboxCardGroup.getValue
                                    |> nonEmptyLangValidation ()
                                    |> Expect.err
                            )
                        |> Simulation.run
            ]
        ]


type alias ComponentModel =
    CheckboxCardGroup.Model Lang ComponentMsg


type alias ComponentMsg =
    CheckboxCardGroup.Msg Lang


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


renderCheckboxGroup : CheckboxCardGroup.Config () Lang parsedValue -> Query.Single ComponentMsg
renderCheckboxGroup =
    CheckboxCardGroup.render identity () CheckboxCardGroup.init >> Query.fromHtml


simulation : Simulation ComponentModel ComponentMsg
simulation =
    Simulation.fromSandbox
        { init = CheckboxCardGroup.init
        , update = \subMsg model -> Tuple.first (CheckboxCardGroup.update subMsg model)
        , view =
            \model ->
                langsConfig
                    |> CheckboxCardGroup.withValidationOnBlur nonEmptyLangValidation False
                    |> CheckboxCardGroup.render identity () model
        }


nonEmptyLangValidation : () -> List Lang -> Result String (List Lang)
nonEmptyLangValidation () langs =
    case langs of
        [] ->
            Err "You must select at least one option"

        _ ->
            Ok langs
