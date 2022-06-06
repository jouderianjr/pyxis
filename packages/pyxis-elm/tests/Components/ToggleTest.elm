module Components.ToggleTest exposing (suite)

import Expect
import Html.Attributes
import Pyxis.Components.Field.Label as Label
import Pyxis.Components.Toggle as Toggle
import Test exposing (Test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector


type Msg
    = OnToggle Bool


suite : Test
suite =
    Test.describe "Toggle component"
        [ Test.test "has correct class and role" <|
            \() ->
                renderConfig True identity
                    |> Expect.all
                        [ Query.has [ Selector.class "toggle" ]
                        , Query.find [ Selector.tag "input" ]
                            >> Query.has
                                [ Selector.class "toggle__input"
                                , Selector.attribute (Html.Attributes.attribute "role" "switch")
                                , Selector.attribute (Html.Attributes.attribute "type" "checkbox")
                                ]
                        ]
        , Test.test "has `id` and `data-test-id`" <|
            \() ->
                renderConfig False identity
                    |> Query.has
                        [ Selector.id "toggle-id"
                        , Selector.attribute (Html.Attributes.id "toggle-id")
                        , Selector.attribute (Html.Attributes.attribute "data-test-id" "toggle-id")
                        ]
        , Test.test "if a text is passed, it is rendered" <|
            \() ->
                renderConfig True (Toggle.withLabel (Label.config "Label"))
                    |> Query.has [ Selector.class "form-label" ]
        , Test.test "if an aria-label is passed, it is rendered" <|
            \() ->
                renderConfig True (Toggle.withAriaLabel "Label")
                    |> Query.find [ Selector.tag "input" ]
                    |> Query.has [ Selector.attribute (Html.Attributes.attribute "aria-label" "Label") ]
        , Test.test "if checked, has `aria-checked` set to true" <|
            \() ->
                renderConfig True identity
                    |> Query.find [ Selector.tag "input" ]
                    |> Query.has [ Selector.attribute (Html.Attributes.attribute "aria-checked" "true") ]
        , Test.test "if not checked, has `aria-checked` set to false" <|
            \() ->
                renderConfig False identity
                    |> Query.find [ Selector.tag "input" ]
                    |> Query.has [ Selector.attribute (Html.Attributes.attribute "aria-checked" "false") ]
        , Test.test "if disabled, has correct class and attribute" <|
            \() ->
                renderConfig False (Toggle.withDisabled True)
                    |> Expect.all
                        [ Query.has [ Selector.class "toggle--disabled" ]
                        , Query.find [ Selector.tag "input" ]
                            >> Query.has [ Selector.attribute (Html.Attributes.disabled True) ]
                        ]
        , Test.test "has the correct list of class" <|
            \() ->
                renderConfig False
                    (Toggle.withClassList
                        [ ( "my-class", True )
                        , ( "my-other-class", True )
                        ]
                    )
                    |> Query.has [ Selector.classes [ "my-class", "my-other-class" ] ]
        ]


renderConfig : Bool -> (Toggle.Config Msg -> Toggle.Config Msg) -> Query.Single Msg
renderConfig initialState modifiers =
    Toggle.config "toggle-id" OnToggle
        |> modifiers
        |> Toggle.render initialState
        |> Query.fromHtml
