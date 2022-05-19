module Components.TextSwitchTest exposing (suite)

import Expect
import Html.Attributes
import Pyxis.Commons.Attributes as CommonsAttributes
import Pyxis.Commons.Properties.Theme as CommonsTheme
import Pyxis.Components.TextSwitch as TextSwitch
import Test exposing (Test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector


type Option
    = M
    | F


type Msg
    = OnChange Option


suite : Test
suite =
    Test.describe "TextSwitch component"
        [ Test.test "has correct class and role" <|
            \() ->
                textSwitchConfig
                    |> renderConfig
                    |> Expect.all
                        [ Query.has [ Selector.class "text-switch-wrapper" ]
                        , Query.find [ Selector.class "text-switch" ]
                            >> Query.has [ Selector.attribute (Html.Attributes.attribute "role" "radiogroup") ]
                        ]
        , Test.describe "its options"
            [ Test.test "can have equal width" <|
                \() ->
                    textSwitchConfig
                        |> TextSwitch.withOptionsWidth TextSwitch.equalWidth
                        |> renderConfig
                        |> Query.has [ Selector.class "text-switch--equal-option-width" ]
            , Test.test "have correct classes and id" <|
                \() ->
                    textSwitchConfig
                        |> renderConfig
                        |> Query.findAll [ Selector.class "text-switch__option" ]
                        |> Expect.all
                            [ Query.each (Query.has [ Selector.class "text-switch__option-input" ])
                            , Query.first
                                >> Query.has
                                    [ Selector.id "id-name-option-0"
                                    , Selector.attribute (Html.Attributes.attribute "data-test-id" "id-name-option-0")
                                    ]
                            ]
            , Test.describe "with label"
                [ Test.test "renders the label" <|
                    \() ->
                        textSwitchConfig
                            |> TextSwitch.withLabel "Label"
                            |> renderConfig
                            |> Expect.all
                                [ Query.find [ Selector.class "text-switch__label" ]
                                    >> Query.has
                                        [ Selector.id "id-name-label"
                                        , Selector.text "Label"
                                        ]
                                , Query.has [ Selector.attribute (CommonsAttributes.ariaLabelledbyBy "id-name-label") ]
                                ]
                , Test.test "renders the label on top-left position" <|
                    \() ->
                        textSwitchConfig
                            |> TextSwitch.withLabel "Label"
                            |> TextSwitch.withLabelPosition TextSwitch.topLeft
                            |> renderConfig
                            |> Query.has [ Selector.class "text-switch-wrapper--top-left-label" ]
                , Test.test "renders the label on the left" <|
                    \() ->
                        textSwitchConfig
                            |> TextSwitch.withLabel "Label"
                            |> TextSwitch.withLabelPosition TextSwitch.left
                            |> renderConfig
                            |> Query.has [ Selector.class "text-switch-wrapper--left-label" ]
                ]
            , Test.test "can have an aria-label" <|
                \() ->
                    textSwitchConfig
                        |> TextSwitch.withAriaLabel "aria-label"
                        |> renderConfig
                        |> Query.has [ Selector.attribute (CommonsAttributes.ariaLabel "aria-label") ]
            , Test.test "can have the alternative theme" <|
                \() ->
                    textSwitchConfig
                        |> TextSwitch.withTheme CommonsTheme.alternative
                        |> renderConfig
                        |> Query.has [ Selector.class "text-switch-wrapper--alt" ]
            , Test.test "have the correct id" <|
                \() ->
                    textSwitchConfig
                        |> renderConfig
                        |> Query.has
                            [ Selector.id "id-name"
                            , Selector.attribute (Html.Attributes.attribute "data-test-id" "id-name")
                            ]
            , Test.test "can have an personalized id" <|
                \() ->
                    textSwitchConfig
                        |> TextSwitch.withId "custom-id"
                        |> TextSwitch.withLabel "label"
                        |> renderConfig
                        |> Expect.all
                            [ Query.has
                                [ Selector.id "custom-id"
                                , Selector.attribute (Html.Attributes.attribute "data-test-id" "custom-id")
                                ]
                            , Query.find [ Selector.class "text-switch__label" ]
                                >> Query.has [ Selector.id "custom-id-label" ]
                            ]
            , Test.test "can have a classlist" <|
                \() ->
                    textSwitchConfig
                        |> TextSwitch.withClassList
                            [ ( "my-class", True )
                            , ( "my-other-class", True )
                            ]
                        |> renderConfig
                        |> Query.has [ Selector.classes [ "my-class", "my-other-class" ] ]
            ]
        ]


options : List (TextSwitch.Option Option)
options =
    [ TextSwitch.option { value = M, label = "Male" }
    , TextSwitch.option { value = F, label = "Female" }
    ]


textSwitchConfig : TextSwitch.Config Option Msg
textSwitchConfig =
    TextSwitch.config "name" OnChange |> TextSwitch.withOptions options


renderConfig : TextSwitch.Config Option Msg -> Query.Single Msg
renderConfig =
    TextSwitch.render M >> Query.fromHtml
