module Components.MessageTest exposing (suite)

import Expect
import Html
import Html.Attributes
import Pyxis.Commons.Attributes as CommonsAttributes
import Pyxis.Components.IconSet as IconSet
import Pyxis.Components.Message as Message
import Test exposing (Test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector


type Msg
    = OnClick


suite : Test
suite =
    Test.describe "Message component"
        [ Test.test "renders correct content" <|
            \() ->
                Message.neutral
                    |> Message.withContent [ Html.text "Message description" ]
                    |> renderConfig
                    |> Query.contains
                        [ Html.div
                            [ Html.Attributes.class "message__text" ]
                            [ Html.text "Message description" ]
                        ]
        , Test.describe "when neutral"
            [ hasProperClassAndRoleTest "message" "status" neutralMessageConfig
            , hasCorrectIconTest IconSet.ExclamationCircle neutralMessageConfig
            ]
        , Test.describe "when brand"
            [ brandMessageConfig Message.defaultBackground |> hasProperClassAndRoleTest "message--brand" "status"
            , brandMessageConfig Message.coloredBackground |> hasColoredBackgroundTest
            , brandMessageConfig Message.defaultBackground |> hasCorrectIconTest IconSet.ThumbUp
            ]
        , Test.describe "when success"
            [ successMessageConfig Message.defaultBackground |> hasProperClassAndRoleTest "message--success" "status"
            , successMessageConfig Message.coloredBackground |> hasColoredBackgroundTest
            , successMessageConfig Message.defaultBackground |> hasCorrectIconTest IconSet.CheckCircle
            ]
        , Test.describe "when alert"
            [ Test.test "has proper classes, `status` role and a colored background" <|
                \() ->
                    alertMessageConfig
                        |> renderConfig
                        |> Query.has
                            [ Selector.classes [ "message--with-background-color", "message--alert" ]
                            , Selector.attribute (Html.Attributes.attribute "role" "status")
                            ]
            , hasCorrectIconTest IconSet.Alert alertMessageConfig
            ]
        , Test.describe "when error"
            [ errorMessageConfig Message.defaultBackground |> hasProperClassAndRoleTest "message--error" "alert"
            , errorMessageConfig Message.coloredBackground |> hasColoredBackgroundTest
            , errorMessageConfig Message.defaultBackground |> hasCorrectIconTest IconSet.ExclamationCircle
            ]
        , Test.describe "when ghost"
            [ hasProperClassAndRoleTest "message--ghost" "status" ghostMessageConfig
            , ghostMessageConfig |> hasCorrectIconTest IconSet.ExclamationCircle
            ]
        , Test.describe "when is dismissible"
            [ Test.test "has a closing icon" <|
                \() ->
                    neutralMessageConfig
                        |> Message.withOnDismiss OnClick "Close message"
                        |> renderConfig
                        |> Query.has [ Selector.class "message__close" ]
            , Test.test "send Msg when is clicked" <|
                \() ->
                    neutralMessageConfig
                        |> Message.withOnDismiss OnClick "Close message"
                        |> renderConfig
                        |> Query.find [ Selector.tag "button" ]
                        |> Event.simulate Event.click
                        |> Event.expect OnClick
            ]
        , Test.test "renders correct Icon if one is set" <|
            \() ->
                neutralMessageConfig
                    |> Message.withIcon IconSet.PrimaLogo
                    |> renderConfig
                    |> Query.has
                        [ Selector.attribute (CommonsAttributes.testId (IconSet.toLabel IconSet.PrimaLogo))
                        , Selector.class "message__icon"
                        ]
        , Test.test "renders correct title if one is set" <|
            \() ->
                neutralMessageConfig
                    |> Message.withTitle "Message title"
                    |> renderConfig
                    |> Query.contains
                        [ Html.div
                            [ Html.Attributes.class "message__title" ]
                            [ Html.text "Message title" ]
                        ]
        , Test.test "has `id` and `data-test-id` if one is set" <|
            \() ->
                neutralMessageConfig
                    |> Message.withId "message-id"
                    |> renderConfig
                    |> Query.has
                        [ Selector.attribute (Html.Attributes.attribute "id" "message-id")
                        , Selector.attribute (Html.Attributes.attribute "data-test-id" "message-id")
                        ]
        , Test.test "has the correct list of class" <|
            \() ->
                neutralMessageConfig
                    |> Message.withClassList
                        [ ( "my-class", True )
                        , ( "my-other-class", True )
                        ]
                    |> renderConfig
                    |> Query.has [ Selector.classes [ "my-class", "my-other-class" ] ]
        ]


neutralMessageConfig : Message.Config msg
neutralMessageConfig =
    Message.neutral
        |> Message.withContent [ Html.text "Message description" ]


brandMessageConfig : Message.Style -> Message.Config msg
brandMessageConfig =
    Message.brand >> Message.withContent [ Html.text "Message description" ]


successMessageConfig : Message.Style -> Message.Config msg
successMessageConfig =
    Message.success >> Message.withContent [ Html.text "Message description" ]


alertMessageConfig : Message.Config msg
alertMessageConfig =
    Message.alert
        |> Message.withContent [ Html.text "Message description" ]


errorMessageConfig : Message.Style -> Message.Config msg
errorMessageConfig =
    Message.error >> Message.withContent [ Html.text "Message description" ]


ghostMessageConfig : Message.Config msg
ghostMessageConfig =
    Message.ghost
        |> Message.withContent [ Html.text "Message description" ]


renderConfig : Message.Config msg -> Query.Single msg
renderConfig =
    Message.render >> Query.fromHtml


hasCorrectIconTest : IconSet.Icon -> Message.Config msg -> Test
hasCorrectIconTest icon config =
    Test.test ("should render the " ++ IconSet.toLabel icon ++ " icon") <|
        \() ->
            config
                |> renderConfig
                |> Query.has
                    [ Selector.attribute (CommonsAttributes.testId (IconSet.toLabel icon))
                    , Selector.class "message__icon"
                    ]


hasColoredBackgroundTest : Message.Config msg -> Test
hasColoredBackgroundTest config =
    Test.test "has colored background if set" <|
        \() ->
            config
                |> renderConfig
                |> Query.has [ Selector.class "message--with-background-color" ]


hasProperClassAndRoleTest : String -> String -> Message.Config msg -> Test
hasProperClassAndRoleTest classes role config =
    Test.test "has proper classes and `status` role" <|
        \() ->
            config
                |> renderConfig
                |> Expect.all
                    [ Query.has
                        [ Selector.class classes
                        , Selector.attribute (Html.Attributes.attribute "role" role)
                        ]
                    , Query.hasNot [ Selector.class "message--with-background-color" ]
                    ]
