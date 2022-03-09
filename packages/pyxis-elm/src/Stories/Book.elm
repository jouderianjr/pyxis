module Stories.Book exposing (main)

import ElmBook
import ElmBook.StatefulOptions
import ElmBook.ThemeOptions
import Html
import Html.Attributes
import Stories.Chapters.Buttons as ButtonChapter
import Stories.Chapters.Fields.CheckboxCardGroup as CheckboxCardGroupChapter
import Stories.Chapters.Fields.CheckboxGroup as CheckboxChapter
import Stories.Chapters.Fields.Date as DateFieldChapter
import Stories.Chapters.Fields.Label as LabelChapter
import Stories.Chapters.Fields.Number as NumberFieldChapter
import Stories.Chapters.Fields.RadioCardGroup as RadioCardFieldChapter
import Stories.Chapters.Fields.RadioGroup as RadioFieldChapter
import Stories.Chapters.Fields.Select as SelectChapter
import Stories.Chapters.Fields.Text as TextFieldChapter
import Stories.Chapters.Fields.Textarea as TextareaChapter
import Stories.Chapters.FormGrid as FormGrid
import Stories.Chapters.Icon as IconChapter
import Stories.Chapters.IconSet as IconSetChapter
import Stories.Chapters.Loader as Loader
import Stories.Chapters.Message as Message


type alias SharedState =
    { text : TextFieldChapter.Model
    , textarea : TextareaChapter.Model
    , number : NumberFieldChapter.Model
    , date : DateFieldChapter.Model
    , select : SelectChapter.Model
    , radio : RadioFieldChapter.Model
    , checkbox : CheckboxChapter.Model
    , radioCard : RadioCardFieldChapter.Model
    , checkboxCard : CheckboxCardGroupChapter.Model
    }


initialState : SharedState
initialState =
    { text = TextFieldChapter.init
    , textarea = TextareaChapter.init
    , number = NumberFieldChapter.init
    , date = DateFieldChapter.init
    , select = SelectChapter.init
    , radio = RadioFieldChapter.init
    , checkbox = CheckboxChapter.init
    , radioCard = RadioCardFieldChapter.init
    , checkboxCard = CheckboxCardGroupChapter.init
    }


main : ElmBook.Book SharedState
main =
    ElmBook.book "Book"
        |> ElmBook.withStatefulOptions
            [ ElmBook.StatefulOptions.initialState initialState
            ]
        |> ElmBook.withThemeOptions
            [ ElmBook.ThemeOptions.globals
                [ Html.node "link" [ Html.Attributes.href "pyxis.css", Html.Attributes.rel "stylesheet" ] []
                ]
            , ElmBook.ThemeOptions.backgroundGradient "#8334c2" "#f2eaf8"
            , ElmBook.ThemeOptions.navBackground "#5b2488"
            , ElmBook.ThemeOptions.navAccent "#ffffff"
            , ElmBook.ThemeOptions.navAccentHighlight "#ffffff"
            , ElmBook.ThemeOptions.header (Html.h1 [] [ Html.text "Pyxis" ])
            ]
        |> ElmBook.withChapters
            [ ButtonChapter.docs
            , IconChapter.docs
            , IconSetChapter.docs
            , Message.docs
            , FormGrid.docs
            , LabelChapter.docs
            , TextFieldChapter.docs
            , RadioFieldChapter.docs
            , RadioCardFieldChapter.docs
            , TextareaChapter.docs
            , NumberFieldChapter.docs
            , DateFieldChapter.docs
            , SelectChapter.docs
            , CheckboxChapter.docs
            , Loader.docs
            , CheckboxCardGroupChapter.docs
            ]
