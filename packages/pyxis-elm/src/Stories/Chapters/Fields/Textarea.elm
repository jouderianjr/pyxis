module Stories.Chapters.Fields.Textarea exposing (Model, docs, init)

import Commons.Properties.Size as Size
import Components.Field.Textarea as Textarea
import ElmBook
import ElmBook.Actions
import ElmBook.Chapter
import Html exposing (Html)


docs : ElmBook.Chapter.Chapter (SharedState x)
docs =
    "Fields/Textarea"
        |> ElmBook.Chapter.chapter
        |> ElmBook.Chapter.withStatefulComponentList componentsList
        |> ElmBook.Chapter.render """
All the properties described below concern the visual implementation of the component.

<component with-label="Textarea" />
```
textareaField : (Textarea.Msg -> msg) -> String -> Html msg
textareaField tagger id =
    Textarea.config tagger id
        |> Textarea.render () (Textarea.init (always Ok))
```

## Size

Sizes set the occupied space of the text-field.
You can set your TextField with a _size_ of default or small.

### Size: Small
<component with-label="Textarea withSize small" />

```
textFieldWithSize : (Textarea.Msg -> msg) -> String -> Html msg
textFieldWithSize tagger id =
    Textarea.config tagger id
        |> Textarea.withSize Size.small
        |> Textarea.render () (Textarea.init (always Ok))

```

## Others

<component with-label="Textarea withPlaceholder" />
```
textFieldWithPlaceholder : (Textarea.Msg -> msg) -> String -> Html msg
textFieldWithPlaceholder tagger id =
    Textarea.config tagger id
        |> Textarea.withPlaceholder "Custom placeholder"
        |> Textarea.render () (Textarea.init (always Ok))

```

<component with-label="Textarea withDisabled" />
```
textFieldWithClassList : (Textarea.Msg -> msg) -> String -> Html msg
textFieldWithClassList tagger id =
    Textarea.config tagger id
        |> Textarea.withDisabled True
        |> Textarea.render () (Textarea.init (always Ok))

```

---
## Accessibility
Whenever possible, please use the label element to associate text with form elements explicitly, with the
`for` attribute of the label that exactly match the id of the form input.
"""


type alias SharedState x =
    { x | textarea : Model }


type alias Model =
    { state : Textarea.Model {}
    }


init : Model
init =
    { state = Textarea.init (always Ok)
    }


componentsList : List ( String, SharedState x -> Html (ElmBook.Msg (SharedState x)) )
componentsList =
    [ ( "Textarea"
      , statelessComponent identity
      )
    , ( "Textarea withSize small"
      , statelessComponent (Textarea.withSize Size.small)
      )
    , ( "Textarea withDisabled"
      , statelessComponent (Textarea.withDisabled True)
      )
    , ( "Textarea withPlaceholder"
      , statelessComponent (Textarea.withPlaceholder "Custom placeholder")
      )
    ]


statelessComponent : (Textarea.Config -> Textarea.Config) -> SharedState x -> Html (ElmBook.Msg (SharedState x))
statelessComponent modifier { textarea } =
    Textarea.config "base"
        |> modifier
        |> Textarea.render identity {} textarea.state
        |> Html.map
            (ElmBook.Actions.mapUpdate
                { toState = \state model -> { state | textarea = model }
                , fromState = .textarea
                , update = \msg model -> { model | state = Textarea.update msg model.state }
                }
            )
