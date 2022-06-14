module Examples.Form.Views.Faqs exposing (view)

import Examples.Form.Model exposing (Model)
import Examples.Form.Msg as Msg exposing (Msg)
import Html exposing (Html)
import Pyxis.Components.Accordion as Accordion
import Pyxis.Components.Accordion.Item as AccordionItem


view : Model -> Html Msg
view model =
    Accordion.config "accordion-id"
        |> Accordion.withClassList [ ( "padding-v-m", True ) ]
        |> Accordion.withItems
            [ AccordionItem.config "request-opening"
                |> AccordionItem.withTitle "How can I open a request?"
                |> AccordionItem.withSubtitle "Which kind of data do I need?"
                |> AccordionItem.withContent
                    [ Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ultrices libero ac semper cursus.  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ultrices libero ac semper cursus. "
                    ]
            , AccordionItem.config "how-long"
                |> AccordionItem.withTitle "How long will take to be processed?"
                |> AccordionItem.withContent
                    [ Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ultrices libero ac semper cursus.  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ultrices libero ac semper cursus. "
                    ]
            ]
        |> Accordion.render Msg.FaqToggled model.faqs
