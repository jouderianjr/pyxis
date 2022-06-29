module Components.AccordionTest exposing (suite)

import Expect
import Html exposing (Html)
import Html.Attributes
import Pyxis.Commons.Properties.Theme as CommonsTheme
import Pyxis.Components.Accordion as Accordion
import Pyxis.Components.Accordion.Item as AccordionItem
import Pyxis.Components.IconSet as IconSet
import Test exposing (Test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import Test.Simulation as Simulation


suite : Test
suite =
    Test.describe "The Accordion component"
        [ Test.describe "wrapper markup"
            [ Test.test "renders accordion div" <|
                \() ->
                    accordionItems
                        |> initialConfig
                        |> renderConfig
                        |> Query.has
                            [ Selector.class "accordion"
                            , Selector.id "accordion"
                            ]
            , Test.test "renders accordion div with custom class" <|
                \() ->
                    accordionItems
                        |> initialConfig
                        |> Accordion.withClassList [ ( "custom-class", True ) ]
                        |> renderConfig
                        |> Query.has [ Selector.exactClassName "accordion custom-class" ]
            ]
        , Test.describe "item markup"
            [ Test.test "renders item div" <|
                \() ->
                    accordionItems
                        |> initialConfig
                        |> renderConfig
                        |> Query.findAll [ Selector.class "accordion-item" ]
                        >> Query.count (Expect.equal 1)
            , Test.test "renders item heading" <|
                \() ->
                    accordionItems
                        |> initialConfig
                        |> renderConfig
                        |> Query.find [ Selector.class "accordion-item" ]
                        |> Query.children [ Selector.tag "h6" ]
                        |> Query.count (Expect.equal 1)
            , Test.test "renders item button" <|
                \() ->
                    accordionItems
                        |> initialConfig
                        |> renderConfig
                        |> Query.find [ Selector.tag "h6" ]
                        |> Query.children [ Selector.tag "button" ]
                        |> Query.count (Expect.equal 1)
            , Test.test "renders item button attributes" <|
                \() ->
                    accordionItems
                        |> initialConfig
                        |> renderConfig
                        |> Query.find [ Selector.tag "button" ]
                        |> Query.has
                            [ Selector.class "accordion-item__header"
                            , Selector.attribute (Html.Attributes.attribute "aria-controls" "id-section")
                            , Selector.attribute (Html.Attributes.attribute "aria-expanded" "false")
                            , Selector.attribute (Html.Attributes.id "id-header")
                            ]
            , Test.test "renders item header wrapper" <|
                \() ->
                    accordionItems
                        |> initialConfig
                        |> renderConfig
                        |> Query.find [ Selector.tag "button" ]
                        |> Query.children [ Selector.class "accordion-item__header__content-wrapper" ]
                        |> Query.count (Expect.equal 1)
            , Test.test "renders item title" <|
                \() ->
                    accordionItems
                        |> initialConfig
                        |> renderConfig
                        |> Query.find [ Selector.class "accordion-item__header__content-wrapper" ]
                        |> Query.children [ Selector.class "accordion-item__header__title" ]
                        |> Query.count (Expect.equal 1)
            , Test.test "renders item title content" <|
                \() ->
                    accordionItems
                        |> initialConfig
                        |> renderConfig
                        |> Query.find [ Selector.class "accordion-item__header__title" ]
                        >> Query.contains [ Html.text "Title" ]
            , Test.test "renders item section" <|
                \() ->
                    accordionItems
                        |> initialConfig
                        |> renderConfig
                        |> Query.find [ Selector.tag "section" ]
                        |> Query.has
                            [ Selector.class "accordion-item__panel"
                            , Selector.attribute (Html.Attributes.attribute "aria-labelledby" "id-header")
                            , Selector.attribute (Html.Attributes.id "id-section")
                            ]
            , Test.test "renders item section wrapper" <|
                \() ->
                    accordionItems
                        |> initialConfig
                        |> renderConfig
                        |> Query.find [ Selector.class "accordion-item__panel__inner-wrapper" ]
                        |> Query.has
                            [ Selector.attribute (Html.Attributes.id "id-content")
                            ]
            , Test.test "renders item section content" <|
                \() ->
                    accordionItems
                        |> initialConfig
                        |> renderConfig
                        |> Query.find [ Selector.class "accordion-item__panel__inner-wrapper" ]
                        >> Query.contains [ Html.div [] [ Html.text "Lorem ipsum." ] ]
            , Test.test "renders item subtitle" <|
                \() ->
                    AccordionItem.withSubtitle "subtitle"
                        |> accordionItemsWithAdditionalContent
                        |> initialConfig
                        |> renderConfig
                        |> Query.find [ Selector.class "accordion-item__header__content-wrapper" ]
                        |> Query.children [ Selector.class "accordion-item__header__subtitle" ]
                        |> Query.count (Expect.equal 1)
            , Test.test "renders item subtitle content" <|
                \() ->
                    AccordionItem.withSubtitle "subtitle"
                        |> accordionItemsWithAdditionalContent
                        |> initialConfig
                        |> renderConfig
                        |> Query.find [ Selector.class "accordion-item__header__subtitle" ]
                        >> Query.contains [ Html.text "subtitle" ]
            , Test.test "renders item action" <|
                \() ->
                    AccordionItem.withActionText actionText
                        |> accordionItemsWithAdditionalContent
                        |> initialConfig
                        |> renderConfig
                        |> Query.find [ Selector.class "accordion-item__header__action-wrapper" ]
                        |> Query.children [ Selector.class "accordion-item__header__action-label" ]
                        |> Query.count (Expect.equal 1)
            , Test.test "renders item action content" <|
                \() ->
                    AccordionItem.withActionText actionText
                        |> accordionItemsWithAdditionalContent
                        |> initialConfig
                        |> renderConfig
                        |> Query.find [ Selector.class "accordion-item__header__action-label" ]
                        >> Query.contains [ Html.text "show" ]
            , Test.test "renders item with addon wrapper" <|
                \() ->
                    AccordionItem.withIcon IconSet.Car
                        |> accordionItemsWithAdditionalContent
                        |> initialConfig
                        |> renderConfig
                        |> Query.find [ Selector.class "accordion-item__header" ]
                        |> Query.children [ Selector.class "accordion-item__header__addon" ]
                        |> Query.count (Expect.equal 1)
            , Test.test "renders item with icon addon" <|
                \() ->
                    AccordionItem.withIcon IconSet.Car
                        |> accordionItemsWithAdditionalContent
                        |> initialConfig
                        |> renderConfig
                        |> Query.find [ Selector.class "accordion-item__header__addon" ]
                        |> Query.children [ Selector.exactClassName "icon icon--size-l" ]
                        |> Query.count (Expect.equal 1)
            , Test.test "renders item with image addon" <|
                \() ->
                    AccordionItem.withImage "../../../assets/placeholder.svg"
                        |> accordionItemsWithAdditionalContent
                        |> initialConfig
                        |> renderConfig
                        |> Query.find [ Selector.class "accordion-item__header__addon" ]
                        |> Query.children [ Selector.tag "img" ]
                        |> Query.count (Expect.equal 1)
            , Test.test "renders item with alternative theme" <|
                \() ->
                    accordionItems
                        |> initialConfig
                        |> Accordion.withTheme CommonsTheme.alternative
                        |> renderConfig
                        |> Query.find [ Selector.class "accordion-item" ]
                        |> Query.has [ Selector.class "accordion-item--alt" ]
            , Test.test "renders item with light variant" <|
                \() ->
                    accordionItems
                        |> initialConfig
                        |> Accordion.withVariant Accordion.light
                        |> renderConfig
                        |> Query.find [ Selector.class "accordion-item" ]
                        |> Query.has [ Selector.class "accordion-item--light" ]
            ]
        , Test.describe "on click simulation"
            [ Test.test "renders item action content on close" <|
                \() ->
                    simulation
                        |> Simulation.simulate ( Event.click, [ Selector.class "accordion-item__header" ] )
                        |> Simulation.expectHtml
                            (Query.find [ Selector.class "accordion-item__header__action-label" ]
                                >> Query.contains [ Html.text "close" ]
                            )
                        |> Simulation.run
            , Test.test "renders item header open class" <|
                \() ->
                    simulation
                        |> Simulation.simulate ( Event.click, [ Selector.class "accordion-item__header" ] )
                        |> Simulation.expectHtml
                            (Query.find [ Selector.class "accordion-item__panel" ]
                                >> Query.has [ Selector.class "accordion-item__panel--open" ]
                            )
                        |> Simulation.run
            , Test.test "renders item aria expanded" <|
                \() ->
                    simulation
                        |> Simulation.simulate ( Event.click, [ Selector.class "accordion-item__header" ] )
                        |> Simulation.expectHtml
                            (Query.find [ Selector.tag "button" ]
                                >> Query.has
                                    [ Selector.class "accordion-item__header"
                                    , Selector.attribute (Html.Attributes.attribute "aria-expanded" "true")
                                    ]
                            )
                        |> Simulation.run
            ]
        ]


init : Accordion.Model
init =
    Accordion.init (Accordion.singleOpening Nothing)


initialConfig : List (AccordionItem.Config Accordion.Msg) -> Accordion.Config Accordion.Msg
initialConfig items =
    Accordion.config "accordion"
        |> Accordion.withItems items


renderConfig : Accordion.Config Accordion.Msg -> Query.Single Accordion.Msg
renderConfig =
    Accordion.render identity init >> Query.fromHtml


accordionItems : List (AccordionItem.Config Accordion.Msg)
accordionItems =
    [ AccordionItem.config "id"
        |> AccordionItem.withTitle "Title"
        |> AccordionItem.withContent
            [ Html.div
                []
                [ Html.text "Lorem ipsum." ]
            ]
    ]


accordionItemsWithAdditionalContent : (AccordionItem.Config Accordion.Msg -> AccordionItem.Config Accordion.Msg) -> List (AccordionItem.Config Accordion.Msg)
accordionItemsWithAdditionalContent additionalContent =
    [ AccordionItem.config "id"
        |> AccordionItem.withTitle "Title"
        |> AccordionItem.withContent
            [ Html.div
                []
                [ Html.text "Lorem ipsum." ]
            ]
        |> additionalContent
    ]


simulation : Simulation.Simulation Accordion.Model Accordion.Msg
simulation =
    Simulation.fromElement
        { init = simulationInit
        , update = simulationUpdate
        , view = simulationView
        }


simulationInit : ( Accordion.Model, Cmd Accordion.Msg )
simulationInit =
    ( init
    , Cmd.none
    )


simulationUpdate : Accordion.Msg -> Accordion.Model -> ( Accordion.Model, Cmd Accordion.Msg )
simulationUpdate msg model =
    Accordion.update msg model


simulationView : Accordion.Model -> Html Accordion.Msg
simulationView model =
    Accordion.config "accordion"
        |> Accordion.withItems
            (actionText
                |> AccordionItem.withActionText
                |> accordionItemsWithAdditionalContent
            )
        |> Accordion.render identity model


actionText : AccordionItem.ActionText
actionText =
    { open = "show"
    , close = "close"
    }
