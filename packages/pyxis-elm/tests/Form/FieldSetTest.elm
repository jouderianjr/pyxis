module Form.FieldSetTest exposing (suite)

import Fuzz
import Html
import Html.Attributes
import Pyxis.Components.Form.FieldSet as FieldSet
import Pyxis.Components.Form.Grid as Grid
import Test exposing (Test)
import Test.Html.Query as Query


suite : Test
suite =
    Test.describe "The Form FieldSet component"
        [ Test.describe "Header"
            [ Test.fuzz Fuzz.string "contains text" <|
                \s ->
                    FieldSet.config
                        |> FieldSet.withHeader
                            [ Grid.oneColRowFullWidth [ Html.text s ]
                            ]
                        |> FieldSet.render
                        |> Query.fromHtml
                        |> Query.contains
                            [ Html.div
                                [ Html.Attributes.class "form-grid__row__column" ]
                                [ Html.text s ]
                            ]
            ]
        , Test.describe "Content"
            [ Test.fuzz Fuzz.string "contains text" <|
                \s ->
                    FieldSet.config
                        |> FieldSet.withContent
                            [ Grid.oneColRowFullWidth [ Html.text s ]
                            ]
                        |> FieldSet.render
                        |> Query.fromHtml
                        |> Query.contains
                            [ Html.div
                                [ Html.Attributes.class "form-grid__row__column" ]
                                [ Html.text s ]
                            ]
            ]
        , Test.describe "Footer"
            [ Test.fuzz Fuzz.string "contains text" <|
                \s ->
                    FieldSet.config
                        |> FieldSet.withFooter
                            [ Grid.oneColRowFullWidth [ Html.text s ]
                            ]
                        |> FieldSet.render
                        |> Query.fromHtml
                        |> Query.contains
                            [ Html.div
                                [ Html.Attributes.class "form-grid__row__column" ]
                                [ Html.text s ]
                            ]
            ]
        ]
