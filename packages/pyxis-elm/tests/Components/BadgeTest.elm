module Components.BadgeTest exposing (suite)

import Expect
import Html
import Html.Attributes
import Pyxis.Commons.Properties.Theme as CommonsTheme
import Pyxis.Components.Badge as Badge
import Test exposing (Test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector


suite : Test
suite =
    Test.describe "Badge component"
        [ Test.test "renders correct content" <|
            \() ->
                Badge.neutral badgeText
                    |> renderConfig
                    |> Query.contains
                        [ Html.text badgeText ]
        , Test.describe "with variants"
            [ Test.test "has proper class when neutral" <|
                (Badge.neutral badgeText |> hasProperClass "badge")
            , Test.test "has proper class when brand" <|
                (Badge.brand badgeText |> hasProperClass "badge--brand")
            , Test.test "has proper class when action" <|
                (Badge.action badgeText |> hasProperClass "badge--action")
            , Test.test "has proper class when success" <|
                (Badge.success badgeText |> hasProperClass "badge--success")
            , Test.test "has proper class when alert" <|
                (Badge.alert badgeText |> hasProperClass "badge--alert")
            , Test.test "has proper class when error" <|
                (Badge.error badgeText |> hasProperClass "badge--error")
            , Test.test "has proper class when neutralGradient" <|
                (Badge.neutralGradient badgeText |> hasProperClass "badge--neutral-gradient")
            , Test.test "has proper class when brandGradient" <|
                (Badge.brandGradient badgeText |> hasProperClass "badge--brand-gradient")
            , Test.test "has proper class when ghost" <|
                (Badge.ghost badgeText |> hasProperClass "badge--ghost")
            ]
        , Test.test "has proper class with alternative theme" <|
            (Badge.neutral badgeText
                |> Badge.withTheme CommonsTheme.alternative
                |> hasProperClass "badge--alt"
            )
        , Test.test "has `id` and `data-test-id` if one is set" <|
            \() ->
                Badge.neutral badgeText
                    |> Badge.withId "badge-id"
                    |> renderConfig
                    |> Query.has
                        [ Selector.attribute (Html.Attributes.attribute "id" "badge-id")
                        , Selector.attribute (Html.Attributes.attribute "data-test-id" "badge-id")
                        ]
        , Test.test "has the correct list of class" <|
            \() ->
                Badge.neutral badgeText
                    |> Badge.withClassList
                        [ ( "my-class", True )
                        , ( "my-other-class", True )
                        ]
                    |> renderConfig
                    |> Query.has [ Selector.classes [ "my-class", "my-other-class" ] ]
        ]


badgeText : String
badgeText =
    "badge text"


renderConfig : Badge.Config -> Query.Single msg
renderConfig =
    Badge.render >> Query.fromHtml


hasProperClass : String -> Badge.Config -> () -> Expect.Expectation
hasProperClass classes config =
    \() ->
        config
            |> renderConfig
            |> Query.has [ Selector.class classes ]
