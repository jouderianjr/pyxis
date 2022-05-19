module Components.Field.LabelTest exposing (suite)

import Html.Attributes
import Pyxis.Components.Field.Label as Label
import Test exposing (Test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector


suite : Test
suite =
    Test.describe "The Label component"
        [ Test.describe "Default"
            [ Test.test "has a textual content" <|
                \() ->
                    Label.config "My label"
                        |> Label.render
                        |> Query.fromHtml
                        |> Query.has
                            [ Selector.tag "label"
                            , Selector.text "My label"
                            , Selector.classes [ "form-label" ]
                            ]
            , Test.describe "Size"
                [ Test.test "is small" <|
                    \() ->
                        Label.config "My label"
                            |> Label.withSize Label.small
                            |> Label.render
                            |> Query.fromHtml
                            |> Query.has [ Selector.classes [ "form-label", "form-label--small" ] ]
                ]
            , Test.describe "With a sub-text"
                [ Test.test "creates a 'small' tag" <|
                    \() ->
                        Label.config "My label"
                            |> Label.withSubText "Sub-level text"
                            |> Label.render
                            |> Query.fromHtml
                            |> Query.find [ Selector.tag "small" ]
                            |> Query.has
                                [ Selector.classes [ "form-label__sub" ]
                                , Selector.text "Sub-level text"
                                ]
                ]
            , Test.describe "Generics"
                [ Test.test "has a for attribute" <|
                    \() ->
                        Label.config "My label"
                            |> Label.withFor "input-id"
                            |> Label.render
                            |> Query.fromHtml
                            |> Query.has [ Selector.attribute (Html.Attributes.for "input-id") ]
                , Test.test "has a class list" <|
                    \() ->
                        Label.config "My label"
                            |> Label.withClassList
                                [ ( "my-class", True )
                                , ( "my-other-class", True )
                                ]
                            |> Label.render
                            |> Query.fromHtml
                            |> Query.has [ Selector.classes [ "my-class", "my-other-class" ] ]
                , Test.test "has an id" <|
                    \() ->
                        Label.config "My label"
                            |> Label.withId "label-id"
                            |> Label.render
                            |> Query.fromHtml
                            |> Query.has
                                [ Selector.attribute (Html.Attributes.id "label-id")
                                , Selector.attribute (Html.Attributes.attribute "data-test-id" "label-id")
                                ]
                ]
            ]
        ]
