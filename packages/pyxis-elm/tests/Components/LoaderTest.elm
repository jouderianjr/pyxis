module Components.LoaderTest exposing (suite)

import Html.Attributes
import Pyxis.Commons.Properties.Theme as CommonsTheme
import Pyxis.Components.Loaders.Loader as Loader
import Test exposing (Test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector


suite : Test
suite =
    Test.describe "Loader component"
        [ Test.test "renders correct classes when spinner" <|
            \() ->
                Loader.spinner
                    |> renderConfig
                    |> Query.has
                        [ Selector.class "loader"
                        , Selector.tag "div"
                        , Selector.class "loader__spinner"
                        ]
        , Test.test "renders correct classes when spinner small" <|
            \() ->
                Loader.spinnerSmall
                    |> renderConfig
                    |> Query.has
                        [ Selector.classes [ "loader", "loader--small" ]
                        , Selector.tag "div"
                        , Selector.class "loader__spinner"
                        ]
        , Test.test "renders correct classes when car" <|
            \() ->
                Loader.car
                    |> renderConfig
                    |> Query.has
                        [ Selector.class "loader"
                        , Selector.tag "div"
                        , Selector.class "loader__car"
                        , Selector.tag "svg"
                        ]
        , Test.test "has a description if a text is set" <|
            \() ->
                Loader.spinner
                    |> Loader.withText "Loading description"
                    |> renderConfig
                    |> Query.has
                        [ Selector.class "loader__text"
                        , Selector.text "Loading description"
                        ]
        , Test.test "has a the proper class if theme is alternative" <|
            \() ->
                Loader.spinner
                    |> Loader.withTheme CommonsTheme.alternative
                    |> renderConfig
                    |> Query.has [ Selector.class "loader--alt" ]
        , Test.test "has `id` and `data-test-id` if one is set" <|
            \() ->
                Loader.spinner
                    |> Loader.withId "message-id"
                    |> renderConfig
                    |> Query.has
                        [ Selector.attribute (Html.Attributes.attribute "id" "message-id")
                        , Selector.attribute (Html.Attributes.attribute "data-test-id" "message-id")
                        ]
        , Test.test "has the correct list of class" <|
            \() ->
                Loader.spinner
                    |> Loader.withClassList
                        [ ( "my-class", True )
                        , ( "my-other-class", True )
                        ]
                    |> renderConfig
                    |> Query.has [ Selector.classes [ "my-class", "my-other-class" ] ]
        ]


renderConfig : Loader.Config -> Query.Single msg
renderConfig =
    Loader.render >> Query.fromHtml
