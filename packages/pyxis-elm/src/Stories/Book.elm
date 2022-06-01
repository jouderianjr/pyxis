module Stories.Book exposing (main)

import ElmBook
import ElmBook.StatefulOptions
import ElmBook.ThemeOptions
import Html
import Html.Attributes
import Stories.Chapters.Accordion as AccordionChapter
import Stories.Chapters.Badge as Badge
import Stories.Chapters.Buttons as ButtonChapter
import Stories.Chapters.Fields.Autocomplete as AutocompleteChapter
import Stories.Chapters.Fields.CheckboxCardGroup as CheckboxCardGroupChapter
import Stories.Chapters.Fields.CheckboxGroup as CheckboxChapter
import Stories.Chapters.Fields.Input as InputChapter
import Stories.Chapters.Fields.Label as LabelChapter
import Stories.Chapters.Fields.RadioCardGroup as RadioCardFieldChapter
import Stories.Chapters.Fields.RadioGroup as RadioFieldChapter
import Stories.Chapters.Fields.Select as SelectChapter
import Stories.Chapters.Fields.Textarea as TextareaChapter
import Stories.Chapters.Form as Form
import Stories.Chapters.Icon as IconChapter
import Stories.Chapters.IconSet as IconSetChapter
import Stories.Chapters.Introduction as Introduction
import Stories.Chapters.Legend as LegendChapter
import Stories.Chapters.Loader as Loader
import Stories.Chapters.Message as Message
import Stories.Chapters.Modal as ModalChapter
import Stories.Chapters.TextSwitch as TextSwitchChapter
import Stories.Chapters.Toggle as ToggleChapter


type alias SharedState =
    { autocomplete : AutocompleteChapter.Models
    , textarea : TextareaChapter.Model
    , select : SelectChapter.Model
    , radio : RadioFieldChapter.Model
    , checkbox : CheckboxChapter.Model
    , radioCard : RadioCardFieldChapter.Model
    , checkboxCard : CheckboxCardGroupChapter.Model
    , toggle : ToggleChapter.Model
    , textSwitch : TextSwitchChapter.Model
    , modal : ModalChapter.Model
    , input : InputChapter.Model
    , accordion : AccordionChapter.Models
    }


initialState : SharedState
initialState =
    { autocomplete = AutocompleteChapter.init
    , textarea = TextareaChapter.init
    , select = SelectChapter.init
    , radio = RadioFieldChapter.init
    , checkbox = CheckboxChapter.init
    , radioCard = RadioCardFieldChapter.init
    , checkboxCard = CheckboxCardGroupChapter.init
    , input = InputChapter.init
    , toggle = ToggleChapter.init
    , textSwitch = TextSwitchChapter.init
    , modal = ModalChapter.init
    , accordion = AccordionChapter.init
    }


main : ElmBook.Book SharedState
main =
    ElmBook.book "Book"
        |> ElmBook.withStatefulOptions
            [ ElmBook.StatefulOptions.initialState initialState
            ]
        |> ElmBook.withThemeOptions
            [ ElmBook.ThemeOptions.globals
                [ Html.node "link" [ Html.Attributes.href "/pyxis.css", Html.Attributes.rel "stylesheet" ] []
                , Html.node "meta"
                    [ Html.Attributes.name "viewport"
                    , Html.Attributes.attribute "content" "width=device-width, initial-scale=1"
                    ]
                    []
                ]
            , ElmBook.ThemeOptions.backgroundGradient "#21283b" "#595d6a"
            , ElmBook.ThemeOptions.accent "#f2eaf8"
            , ElmBook.ThemeOptions.navAccent "#dddee1"
            , ElmBook.ThemeOptions.navAccentHighlight "#f3f4f4"
            , ElmBook.ThemeOptions.header (Html.h1 [] [ Html.text "Pyxis" ])
            ]
        |> ElmBook.withChapterGroups
            [ ( "Pyxis Design System"
              , [ Introduction.docs
                ]
              )
            , ( "Generic components"
              , [ ButtonChapter.docs
                , Loader.docs
                , Message.docs
                , ModalChapter.docs
                , Badge.docs
                , AccordionChapter.docs
                ]
              )
            , ( "Form"
              , [ Form.docs
                , LegendChapter.docs
                , AutocompleteChapter.docs
                , LabelChapter.docs
                , CheckboxChapter.docs
                , CheckboxCardGroupChapter.docs
                , InputChapter.docs
                , RadioFieldChapter.docs
                , RadioCardFieldChapter.docs
                , SelectChapter.docs
                , TextareaChapter.docs
                , ToggleChapter.docs
                , TextSwitchChapter.docs
                ]
              )
            , ( "Icons"
              , [ IconChapter.docs
                , IconSetChapter.docs
                ]
              )
            ]
