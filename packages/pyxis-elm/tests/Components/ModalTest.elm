module Components.ModalTest exposing (suite)

import Expect
import Html
import Html.Attributes
import Pyxis.Commons.Properties.Theme as CommonsTheme
import Pyxis.Components.Badge as Badge
import Pyxis.Components.Button as Button
import Pyxis.Components.Icon as Icon
import Pyxis.Components.IconSet as Icon
import Pyxis.Components.Modal as Modal
import Pyxis.Components.Modal.Footer as ModalFooter
import Pyxis.Components.Modal.Header as ModalHeader
import Test exposing (Test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector


type Msg
    = ShowModal Bool


suite : Test
suite =
    Test.describe "The Modal component"
        [ Test.describe "render base markup"
            [ Test.test "renders correct attributes" <|
                \() ->
                    initialConfig
                        |> renderConfig
                        |> Query.has
                            [ Selector.class "modal-backdrop"
                            , Selector.attribute (Html.Attributes.id "test")
                            , Selector.attribute (Html.Attributes.attribute "aria-hidden" "true")
                            , Selector.attribute (Html.Attributes.attribute "aria-modal" "true")
                            , Selector.attribute (Html.Attributes.attribute "role" "dialog")
                            ]
            , Test.test "renders correct children" <|
                \() ->
                    initialConfig
                        |> renderConfig
                        |> Expect.all
                            [ Query.findAll [ Selector.class "modal-close" ]
                                >> Query.count (Expect.equal 1)
                            , Query.findAll [ Selector.classes [ "modal", "modal--medium" ] ]
                                >> Query.count (Expect.equal 1)
                            , Query.findAll [ Selector.class "modal__content" ]
                                >> Query.count (Expect.equal 1)
                            ]
            , Test.test "renders show class" <|
                \() ->
                    initialConfig
                        |> Modal.render True
                        |> Query.fromHtml
                        |> Query.has
                            [ Selector.classes [ "modal-backdrop", "modal-backdrop--show" ] ]
            , Test.test "with close button" <|
                \() ->
                    initialConfig
                        |> Modal.withCloseMsg (ShowModal False) "Close"
                        |> Modal.withHeader ModalHeader.config
                        |> renderConfig
                        |> Query.find [ Selector.tag "button" ]
                        |> Query.has
                            [ Selector.classes
                                [ "button", "button--icon-only", "button--tertiary", "button--medium" ]
                            ]
            , Test.test "with size small" <|
                \() ->
                    initialConfig
                        |> Modal.withSize Modal.small
                        |> Modal.withHeader ModalHeader.config
                        |> renderConfig
                        |> Query.has [ Selector.class "modal--small" ]
            , Test.test "with centered position" <|
                \() ->
                    initialConfig
                        |> Modal.withIsCentered True
                        |> Modal.withHeader ModalHeader.config
                        |> renderConfig
                        |> Query.has [ Selector.class "modal--center" ]
            ]
        , Test.describe "render header"
            [ Test.test "with base markup " <|
                \() ->
                    initialConfig
                        |> Modal.withHeader ModalHeader.config
                        |> renderConfig
                        |> Query.find [ Selector.tag "header" ]
                        |> Query.has [ Selector.class "modal__header" ]
            , Test.test "with sticky option" <|
                \() ->
                    initialConfig
                        |> Modal.withHeader
                            (ModalHeader.config
                                |> ModalHeader.withIsSticky True
                            )
                        |> renderConfig
                        |> Query.find [ Selector.tag "header" ]
                        |> Query.has [ Selector.classes [ "modal__header", "modal__header--sticky" ] ]
            , Test.test "with title" <|
                \() ->
                    initialConfig
                        |> Modal.withHeader
                            (ModalHeader.config
                                |> ModalHeader.withTitle "Modal Title"
                            )
                        |> renderConfig
                        |> Query.find
                            [ Selector.tag "h3"
                            , Selector.classes [ "modal__header__title" ]
                            ]
                        >> Query.contains [ Html.text "Modal Title" ]
            , Test.test "with badge" <|
                \() ->
                    initialConfig
                        |> Modal.withHeader
                            (ModalHeader.config
                                |> ModalHeader.withBadge (Badge.brand "Hello Prima")
                            )
                        |> renderConfig
                        |> Query.findAll [ Selector.class "modal__header__badge" ]
                        >> Query.count (Expect.equal 1)
            , Test.test "with icon" <|
                \() ->
                    initialConfig
                        |> Modal.withHeader
                            (ModalHeader.config
                                |> ModalHeader.withIcon
                                    (Icon.Car
                                        |> Icon.config
                                        |> Icon.withClassList [ ( "c-brand-base", True ) ]
                                        |> Icon.withSize Icon.large
                                    )
                            )
                        |> renderConfig
                        |> Query.findAll [ Selector.classes [ "icon", "icon--size-l", "c-brand-base" ] ]
                        >> Query.count (Expect.equal 1)
            ]
        , Test.describe "render footer"
            [ Test.test "with base markup " <|
                \() ->
                    initialConfig
                        |> Modal.withFooter
                            ModalFooter.config
                        |> renderConfig
                        |> Query.find [ Selector.tag "footer" ]
                        |> Query.has [ Selector.class "modal__footer" ]
            , Test.test "with sticky option" <|
                \() ->
                    initialConfig
                        |> Modal.withFooter
                            (ModalFooter.config
                                |> ModalFooter.withIsSticky True
                            )
                        |> renderConfig
                        |> Query.find [ Selector.tag "footer" ]
                        |> Query.has [ Selector.classes [ "modal__footer", "modal__footer--sticky" ] ]
            , Test.test "with text " <|
                \() ->
                    initialConfig
                        |> Modal.withFooter
                            (ModalFooter.config
                                |> ModalFooter.withText (Html.div [] [ Html.text "Text" ])
                            )
                        |> renderConfig
                        |> Query.find [ Selector.class "modal__footer__text" ]
                        |> Query.contains [ Html.div [] [ Html.text "Text" ] ]
            , Test.test "with alternative theme" <|
                \() ->
                    initialConfig
                        |> Modal.withFooter
                            (ModalFooter.config
                                |> ModalFooter.withTheme CommonsTheme.alternative
                            )
                        |> renderConfig
                        |> Query.find [ Selector.tag "footer" ]
                        |> Query.has [ Selector.classes [ "modal__footer", "modal__footer--alt" ] ]
            , Test.test "with buttons" <|
                \() ->
                    initialConfig
                        |> Modal.withFooter
                            (ModalFooter.config
                                |> ModalFooter.withButtons
                                    [ Button.primary
                                        |> Button.withText "Proceed"
                                        |> Button.render
                                    ]
                            )
                        |> renderConfig
                        |> Query.findAll [ Selector.class "modal__footer__buttons" ]
                        >> Query.count (Expect.equal 1)
            , Test.test "with full width buttons" <|
                \() ->
                    initialConfig
                        |> Modal.withFooter
                            (ModalFooter.config
                                |> ModalFooter.withButtons
                                    [ Button.primary
                                        |> Button.withText "Proceed"
                                        |> Button.render
                                    ]
                                |> ModalFooter.withFullWidthButton True
                            )
                        |> renderConfig
                        |> Query.find [ Selector.class "modal__footer__buttons" ]
                        |> Query.has [ Selector.class "modal__footer__buttons--full-width" ]
            ]
        ]


initialConfig : Modal.Config msg
initialConfig =
    Modal.config "test"


renderConfig : Modal.Config msg -> Query.Single msg
renderConfig =
    Modal.render False >> Query.fromHtml
