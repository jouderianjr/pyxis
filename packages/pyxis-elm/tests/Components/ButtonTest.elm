module Components.ButtonTest exposing (suite)

import Html.Attributes
import Pyxis.Commons.Properties.Theme as CommonsTheme
import Pyxis.Components.Button as Button
import Pyxis.Components.IconSet as IconSet
import Test exposing (Test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector


type Msg
    = OnClick


suite : Test
suite =
    Test.describe "The Button component"
        [ Test.describe "Button tag"
            [ Test.test "is <button>" <|
                \() ->
                    Button.primary
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.has [ Selector.tag "button" ]
            , Test.test "is <a>" <|
                \() ->
                    Button.primary
                        |> Button.withType (Button.link "https://www.prima.it")
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.has
                            [ Selector.tag "a"
                            , Selector.attribute (Html.Attributes.href "https://www.prima.it")
                            ]
            ]
        , Test.describe "Button emphasis"
            [ Test.test "is primary" <|
                \() ->
                    Button.primary
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.has [ Selector.classes [ "button", "button--primary" ] ]
            , Test.test "is secondary" <|
                \() ->
                    Button.secondary
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.has [ Selector.classes [ "button", "button--secondary" ] ]
            , Test.test "is tertiary" <|
                \() ->
                    Button.tertiary
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.has [ Selector.classes [ "button", "button--tertiary" ] ]
            , Test.test "is brand" <|
                \() ->
                    Button.brand
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.has [ Selector.classes [ "button", "button--brand" ] ]
            , Test.test "is ghost" <|
                \() ->
                    Button.ghost
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.has [ Selector.classes [ "button", "button--ghost" ] ]
            ]
        , Test.describe "Button theme"
            [ Test.test "is light" <|
                \() ->
                    Button.primary
                        |> Button.withTheme CommonsTheme.default
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.hasNot [ Selector.classes [ "button--alt" ] ]
            , Test.test "is dark" <|
                \() ->
                    Button.primary
                        |> Button.withTheme CommonsTheme.alternative
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.has [ Selector.classes [ "button", "button--alt" ] ]
            ]
        , Test.describe "Button size"
            [ Test.test "is huge" <|
                \() ->
                    Button.primary
                        |> Button.withSize Button.huge
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.has [ Selector.classes [ "button", "button--huge" ] ]
            , Test.test "is large" <|
                \() ->
                    Button.primary
                        |> Button.withSize Button.large
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.has [ Selector.classes [ "button", "button--large" ] ]
            , Test.test "is medium" <|
                \() ->
                    Button.primary
                        |> Button.withSize Button.medium
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.has [ Selector.classes [ "button", "button--medium" ] ]
            , Test.test "is small" <|
                \() ->
                    Button.secondary
                        |> Button.withSize Button.small
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.has [ Selector.classes [ "button", "button--small" ] ]
            ]
        , Test.describe "Button type"
            [ Test.test "is submit by default" <|
                \() ->
                    Button.primary
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.has [ Selector.attribute (Html.Attributes.type_ "submit") ]
            , Test.test "is button" <|
                \() ->
                    Button.primary
                        |> Button.withType Button.button
                        |> Button.withOnClick OnClick
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.has [ Selector.attribute (Html.Attributes.type_ "button") ]
            , Test.test "is reset" <|
                \() ->
                    Button.primary
                        |> Button.withType Button.reset
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.has [ Selector.attribute (Html.Attributes.type_ "reset") ]
            , Test.test "has no type when tag is <a>" <|
                \() ->
                    Button.primary
                        |> Button.withType (Button.link "https://www.prima.it")
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.hasNot
                            [ Selector.attribute (Html.Attributes.type_ "submit")
                            , Selector.attribute (Html.Attributes.type_ "button")
                            , Selector.attribute (Html.Attributes.type_ "reset")
                            ]
            , Test.test "is <a>" <|
                \() ->
                    Button.primary
                        |> Button.withType (Button.link "https://www.prima.it")
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.has
                            [ Selector.tag "a"
                            , Selector.attribute (Html.Attributes.href "https://www.prima.it")
                            ]
            ]
        , Test.describe "Button icon"
            [ Test.test "is prepend" <|
                \() ->
                    Button.primary
                        |> Button.withIconPrepend IconSet.Car
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.has [ Selector.classes [ "button", "button--prepend-icon" ] ]
            , Test.test "is append" <|
                \() ->
                    Button.primary
                        |> Button.withIconAppend IconSet.Motorcycle
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.has [ Selector.classes [ "button", "button--append-icon" ] ]
            , Test.test "is icon only" <|
                \() ->
                    Button.primary
                        |> Button.withSize Button.large
                        |> Button.withIconOnly IconSet.Van
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.has [ Selector.classes [ "button", "button--icon-only" ] ]
            ]
        , Test.describe "Button events"
            [ Test.test "has onClick" <|
                \() ->
                    Button.primary
                        |> Button.withType Button.button
                        |> Button.withOnClick OnClick
                        |> Button.render
                        |> Query.fromHtml
                        |> Event.simulate Event.click
                        |> Event.expect OnClick
            ]
        , Test.describe "Button generics"
            [ Test.test "has textual content" <|
                \() ->
                    Button.primary
                        |> Button.withText "Click me!"
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.has [ Selector.text "Click me!" ]
            , Test.test "has an id" <|
                \() ->
                    Button.primary
                        |> Button.withId "jsButton"
                        |> Button.withText "Click me!"
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.has
                            [ Selector.attribute (Html.Attributes.attribute "id" "jsButton")
                            , Selector.attribute (Html.Attributes.attribute "data-test-id" "jsButton")
                            ]
            , Test.test "has a classList" <|
                \() ->
                    Button.primary
                        |> Button.withClassList
                            [ ( "my-class", True )
                            , ( "my-other-class", True )
                            ]
                        |> Button.withText "Click me!"
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.has [ Selector.classes [ "my-class", "my-other-class" ] ]
            , Test.test "is disabled" <|
                \() ->
                    Button.primary
                        |> Button.withDisabled True
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.has [ Selector.disabled True ]
            , Test.test "has shadow" <|
                \() ->
                    Button.brand
                        |> Button.withShadow
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.has [ Selector.classes [ "button", "button--shadow" ] ]
            , Test.test "has limited content width" <|
                \() ->
                    Button.tertiary
                        |> Button.withContentWidth
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.has [ Selector.classes [ "button", "button--content-width" ] ]
            , Test.test "is loading" <|
                \() ->
                    Button.brand
                        |> Button.withLoading True
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.has [ Selector.classes [ "button", "button--loading" ] ]
            , Test.test "has an accessible label" <|
                \() ->
                    Button.primary
                        |> Button.withAriaLabel "Login button"
                        |> Button.withText "Login"
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.has [ Selector.attribute (Html.Attributes.attribute "aria-label" "Login button") ]
            , Test.test "has alternative theme" <|
                \() ->
                    Button.brand
                        |> Button.withTheme CommonsTheme.alternative
                        |> Button.render
                        |> Query.fromHtml
                        |> Query.has [ Selector.classes [ "button", "button--alt" ] ]
            ]
        ]
