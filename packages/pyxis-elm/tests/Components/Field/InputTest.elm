module Components.Field.InputTest exposing (suite)

import Expect
import Fuzz
import Html.Attributes
import Pyxis.Components.Field.Input as Input
import Pyxis.Components.Field.Label as LabelField
import Pyxis.Components.IconSet as IconSet
import Test exposing (Test)
import Test.Extra as Test
import Test.Html.Query as Query
import Test.Html.Selector as Selector


suite : Test
suite =
    Test.describe "The Input component"
        [ Test.test "renders the `form-field__text` class" <|
            \() ->
                fieldConfig
                    |> Input.render identity () fieldModel
                    |> Query.fromHtml
                    |> findInput
                    |> Query.has [ Selector.class "form-field__text" ]
        , Test.describe "Label"
            [ Test.fuzz Fuzz.string "should be rendered correctly" <|
                \s ->
                    fieldConfig
                        |> Input.withLabel (LabelField.config s)
                        |> Input.render identity () fieldModel
                        |> Query.fromHtml
                        |> findLabel
                        |> Query.has [ Selector.text s ]
            ]
        , Test.describe "Value attribute"
            [ Test.test "should be rendered correctly" <|
                \() ->
                    fieldConfig
                        |> Input.render identity () fieldModel
                        |> Query.fromHtml
                        |> findInput
                        |> Query.has [ Selector.attribute (Html.Attributes.value "") ]
            ]
        , Test.describe "Disabled attribute"
            [ Test.test "should be False by default" <|
                \() ->
                    fieldConfig
                        |> Input.render identity () fieldModel
                        |> Query.fromHtml
                        |> findInput
                        |> Query.has [ Selector.disabled False ]
            , Test.fuzz Fuzz.bool "should be rendered correctly" <|
                \b ->
                    fieldConfig
                        |> Input.withDisabled b
                        |> Input.render identity () fieldModel
                        |> Query.fromHtml
                        |> findInput
                        |> Query.has [ Selector.disabled b ]
            ]
        , Test.fuzz Fuzz.string "Name attribute should be rendered correctly" <|
            \name ->
                Input.text name
                    |> Input.render identity () fieldModel
                    |> Query.fromHtml
                    |> findInput
                    |> Query.has
                        [ Selector.attribute (Html.Attributes.name name)
                        ]
        , Test.fuzz Fuzz.string "placeholder attribute should be rendered correctly" <|
            \p ->
                fieldConfig
                    |> Input.withPlaceholder p
                    |> Input.render identity () fieldModel
                    |> Query.fromHtml
                    |> findInput
                    |> Query.has
                        [ Selector.attribute (Html.Attributes.placeholder p)
                        ]
        , Test.fuzz Fuzz.string "min attribute should be rendered correctly" <|
            \p ->
                Input.date
                    "input_field"
                    |> Input.withMin p
                    |> Input.render identity () fieldModel
                    |> Query.fromHtml
                    |> findInput
                    |> Query.has
                        [ Selector.attribute (Html.Attributes.min p)
                        ]
        , Test.fuzz Fuzz.string "max attribute should be rendered correctly" <|
            \p ->
                Input.date
                    "input_field"
                    |> Input.withMax p
                    |> Input.render identity () fieldModel
                    |> Query.fromHtml
                    |> findInput
                    |> Query.has
                        [ Selector.attribute (Html.Attributes.max p)
                        ]
        , Test.fuzz Fuzz.string "step attribute should be rendered correctly" <|
            \p ->
                Input.date
                    "input_field"
                    |> Input.withStep p
                    |> Input.render identity () fieldModel
                    |> Query.fromHtml
                    |> findInput
                    |> Query.has
                        [ Selector.attribute (Html.Attributes.step p)
                        ]
        , Test.test "id attribute should be rendered correctly" <|
            \() ->
                fieldConfig
                    |> Input.withId "field-id"
                    |> Input.render identity () fieldModel
                    |> Query.fromHtml
                    |> findInput
                    |> Query.has
                        [ Selector.id "field-id"
                        ]
        , Test.describe "classList"
            [ Test.fuzzDistinctClassNames3 "should render correctly the given classes" <|
                \s1 s2 s3 ->
                    fieldConfig
                        |> Input.withClassList [ ( s1, True ), ( s2, False ), ( s3, True ) ]
                        |> Input.render identity () fieldModel
                        |> Query.fromHtml
                        |> findInput
                        |> Expect.all
                            [ Query.has
                                [ Selector.classes [ s1, s3 ]
                                ]
                            , Query.hasNot
                                [ Selector.classes [ s2 ]
                                ]
                            ]
            ]
        , Test.describe "disabled attribute"
            [ Test.test "should be disabled by default" <|
                \() ->
                    fieldConfig
                        |> Input.render identity () fieldModel
                        |> Query.fromHtml
                        |> Query.has
                            [ Selector.disabled False
                            ]
            , Test.fuzz Fuzz.bool "should render the disabled property correctly" <|
                \b ->
                    fieldConfig
                        |> Input.withDisabled b
                        |> Input.render identity () fieldModel
                        |> Query.fromHtml
                        |> findInput
                        |> Query.has
                            [ Selector.disabled b
                            ]
            , Test.test "should render the disabled class when disabled" <|
                \() ->
                    fieldConfig
                        |> Input.withDisabled True
                        |> Input.render identity () fieldModel
                        |> Query.fromHtml
                        |> Query.has
                            [ Selector.class "form-field--disabled"
                            ]
            , Test.test "should not render the disabled class when not disabled" <|
                \() ->
                    fieldConfig
                        |> Input.render identity () fieldModel
                        |> Query.fromHtml
                        |> Query.hasNot
                            [ Selector.class "form-field--disabled"
                            ]
            ]
        , Test.describe "Addon"
            [ Test.describe "Should render the right class"
                [ Test.describe "Icon addon"
                    [ Test.test "append positioning should be rendered correctly" <|
                        \() ->
                            fieldConfig
                                |> Input.withIconAppend IconSet.ArrowDown
                                |> Input.render identity () fieldModel
                                |> Query.fromHtml
                                |> Query.has
                                    [ Selector.class "form-field--with-append-icon"
                                    , Selector.class "form-field__addon"
                                    ]
                    , Test.test "prepend positioning should be rendered correctly" <|
                        \() ->
                            fieldConfig
                                |> Input.withIconPrepend IconSet.ArrowDown
                                |> Input.render identity () fieldModel
                                |> Query.fromHtml
                                |> Query.has
                                    [ Selector.class "form-field--with-prepend-icon"
                                    , Selector.class "form-field__addon"
                                    ]
                    ]
                , Test.describe "Text addon"
                    [ Test.fuzz Fuzz.string "append positioning should be rendered correctly" <|
                        \s ->
                            fieldConfig
                                |> Input.withTextAppend s
                                |> Input.render identity () fieldModel
                                |> Query.fromHtml
                                |> Query.has
                                    [ Selector.class "form-field--with-append-text"
                                    , Selector.class "form-field__addon"
                                    , Selector.text s
                                    ]
                    , Test.fuzz Fuzz.string "prepend positioning should be rendered correctly" <|
                        \s ->
                            fieldConfig
                                |> Input.withTextPrepend s
                                |> Input.render identity () fieldModel
                                |> Query.fromHtml
                                |> Query.has
                                    [ Selector.class "form-field--with-prepend-text"
                                    , Selector.class "form-field__addon"
                                    , Selector.text s
                                    ]
                    ]
                ]
            ]
        , Test.describe "Size"
            [ Test.test "should render the correct size class" <|
                \() ->
                    fieldConfig
                        |> Input.withSize Input.small
                        |> Input.render identity () fieldModel
                        |> Query.fromHtml
                        |> findInput
                        |> Query.has
                            [ Selector.class "form-field__text--small"
                            ]
            ]
        ]


fieldModel : Input.Model msg
fieldModel =
    Input.init ""


fieldConfig : Input.TextConfig () String
fieldConfig =
    Input.text "field"


findInput : Query.Single msg -> Query.Single msg
findInput =
    Query.find [ Selector.tag "input" ]


findLabel : Query.Single msg -> Query.Single msg
findLabel =
    Query.find [ Selector.tag "label", Selector.class "form-label" ]
