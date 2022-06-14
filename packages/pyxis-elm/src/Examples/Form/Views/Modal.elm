module Examples.Form.Views.Modal exposing (view)

import Examples.Form.Msg as Msg exposing (Msg)
import Html exposing (Html)
import Pyxis.Commons.Properties.Theme as Theme
import Pyxis.Components.Badge as Badge
import Pyxis.Components.Button as Button
import Pyxis.Components.Icon as Icon
import Pyxis.Components.IconSet as IconSet
import Pyxis.Components.Modal as Modal
import Pyxis.Components.Modal.Footer as ModalFooter
import Pyxis.Components.Modal.Header as ModalHeader


view : Bool -> Html Msg
view show =
    Modal.config "test-modal"
        |> Modal.withClassList [ ( "class-custom", True ) ]
        |> Modal.withSize Modal.large
        |> Modal.withHeader modalHeader
        |> Modal.withContent modalContent
        |> Modal.withFooter modalFooter
        |> Modal.withCloseMsg (Msg.ShowModal False) "Close"
        |> Modal.withAriaDescribedBy "Screen Reader Description"
        |> Modal.render show


modalHeader : ModalHeader.Config Msg
modalHeader =
    ModalHeader.config
        |> ModalHeader.withIsSticky True
        |> ModalHeader.withTitle "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
        |> ModalHeader.withBadge (Badge.brand "Hello Prima")
        |> ModalHeader.withIcon
            (IconSet.Car
                |> Icon.config
                |> Icon.withClassList [ ( "c-brand-base", True ) ]
                |> Icon.withSize Icon.large
            )


modalContent : List (Html msg)
modalContent =
    [ Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ultrices libero ac semper cursus. Integer scelerisque mi at blandit vestibulum. Vivamus nec nibh id lacus lacinia facilisis vel nec felis. Duis rhoncus rutrum volutpat. Quisque at pulvinar enim. Vestibulum ut posuere erat. Quisque cursus ut odio vel faucibus. Duis semper venenatis finibus. Morbi iaculis ligula at justo lobortis vulputate. Duis vestibulum neque at neque fringilla malesuada. Nulla vitae nunc sed lectus varius facilisis in eu nisi. Aliquam erat volutpat. Phasellus sapien elit, suscipit id eleifend sed, posuere ac nulla. Duis volutpat, mauris sit amet tincidunt ornare, nunc erat semper ex, quis rhoncus eros nulla et metus. Vestibulum eu egestas felis, quis porta lectus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ultrices libero ac semper cursus. Integer scelerisque mi at blandit vestibulum. Vivamus nec nibh id lacus lacinia facilisis vel nec felis. Duis rhoncus rutrum volutpat. Quisque at pulvinar enim. Vestibulum ut posuere erat. Quisque cursus ut odio vel faucibus. Duis semper venenatis finibus. Morbi iaculis ligula at justo lobortis vulputate. Duis vestibulum neque at neque fringilla malesuada. Nulla vitae nunc sed lectus varius facilisis in eu nisi. Aliquam erat volutpat. Phasellus sapien elit, suscipit id eleifend sed, posuere ac nulla. Duis volutpat, mauris sit amet tincidunt ornare, nunc erat semper ex, quis rhoncus eros nulla et metus. Vestibulum eu egestas felis, quis porta lectus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ultrices libero ac semper cursus. Integer scelerisque mi at blandit vestibulum. Vivamus nec nibh id lacus lacinia facilisis vel nec felis. Duis rhoncus rutrum volutpat. Quisque at pulvinar enim. Vestibulum ut posuere erat. Quisque cursus ut odio vel faucibus. Duis semper venenatis finibus. Morbi iaculis ligula at justo lobortis vulputate. Duis vestibulum neque at neque fringilla malesuada. Nulla vitae nunc sed lectus varius facilisis in eu nisi. Aliquam erat volutpat. Phasellus sapien elit, suscipit id eleifend sed, posuere ac nulla. Duis volutpat, mauris sit amet tincidunt ornare, nunc erat semper ex, quis rhoncus eros nulla et metus. Vestibulum eu egestas felis, quis porta lectus." ]


modalFooter : ModalFooter.Config Msg
modalFooter =
    ModalFooter.config
        |> ModalFooter.withText (Html.div [] [ Html.text "Lorem" ])
        |> ModalFooter.withTheme Theme.alternative
        |> ModalFooter.withFullWidthButton True
        |> ModalFooter.withButtons
            [ Button.secondary
                |> Button.withText "I agree"
                |> Button.render
            , Button.primary
                |> Button.withText "Close"
                |> Button.withType Button.button
                |> Button.withOnClick (Msg.ShowModal False)
                |> Button.render
            ]
