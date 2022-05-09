module Stories.Chapters.Fields.Textarea exposing (Model, docs, init)

import Components.Field.Label as Label
import Components.Field.Textarea as Textarea
import ElmBook
import ElmBook.Actions
import ElmBook.Chapter
import Html exposing (Html)


docs : ElmBook.Chapter.Chapter (SharedState x)
docs =
    "Textarea"
        |> ElmBook.Chapter.chapter
        |> ElmBook.Chapter.withStatefulComponentList componentsList
        |> ElmBook.Chapter.render """
All the properties described below concern the visual implementation of the component.

<component with-label="Textarea" />
```
type Msg
    = OnTextareaMsg Textarea.Msg


textareaModel : Textarea.Model formData
textareaModel =
    Textarea.init "" validation


validation : formData -> String -> Result String String
validation _ value =
    if String.isEmpty value then
        Err "Required"

    else
        Ok value


textareaField : String -> formData -> Html Msg
textareaField name formData =
    Textarea.config name
        |> Textarea.withLabel (Label.config "Textarea")
        |> Textarea.render OnTextareaMsg formData textareaModel
```

## Size

Sizes set the occupied space of the text-field.
You can set your TextField with a _size_ of default or small.

### Size: Small
<component with-label="Textarea withSize small" />

```
Textarea.config name
    |> Textarea.withSize Textarea.small
    |> Textarea.render OnTextareaMsg formData textareaModel
```

## Others

<component with-label="Textarea withPlaceholder" />
```
Textarea.config name
    |> Textarea.withPlaceholder "Custom placeholder"
    |> Textarea.render OnTextareaMsg formData textareaModel
```

<component with-label="Textarea withDisabled" />
```
Textarea.config name
    |> Textarea.withDisabled True
    |> Textarea.render OnTextareaMsg formData textareaModel
```

---
## Accessibility
Whenever possible, please use the label element to associate text with form elements explicitly, with the
`for` attribute of the label that exactly match the id of the form input.
"""


type alias SharedState x =
    { x | textarea : Model }


type alias Model =
    { base : Textarea.Model ()
    , withValidation : Textarea.Model ()
    }


init : Model
init =
    { base = Textarea.init "" (always Ok)
    , withValidation = Textarea.init "" validation
    }


validation : formData -> String -> Result String String
validation _ value =
    if String.isEmpty value then
        Err "Required"

    else
        Ok value


componentsList : List ( String, SharedState x -> Html (ElmBook.Msg (SharedState x)) )
componentsList =
    [ ( "Textarea"
      , statefulComponent "Textarea"
            .withValidation
            (\msg model -> { model | withValidation = Textarea.update msg model.withValidation })
      )
    , ( "Textarea withSize small"
      , statelessComponent "Small" (Textarea.withSize Textarea.small)
      )
    , ( "Textarea withDisabled"
      , statelessComponent "Disabled" (Textarea.withDisabled True)
      )
    , ( "Textarea withPlaceholder"
      , statelessComponent "Placeholder" (Textarea.withPlaceholder "Custom placeholder")
      )
    ]


statelessComponent : String -> (Textarea.Config -> Textarea.Config) -> SharedState x -> Html (ElmBook.Msg (SharedState x))
statelessComponent name configModifier { textarea } =
    Textarea.config name
        |> configModifier
        |> Textarea.render identity () textarea.base
        |> Html.map
            (ElmBook.Actions.mapUpdate
                { toState = \state model -> { state | textarea = model }
                , fromState = .textarea
                , update = \msg model -> { model | base = Textarea.update msg model.base }
                }
            )


statefulComponent :
    String
    -> (Model -> Textarea.Model ())
    -> (Textarea.Msg -> Model -> Model)
    -> SharedState x
    -> Html (ElmBook.Msg (SharedState x))
statefulComponent name modelPicker update sharedState =
    Textarea.config name
        |> Textarea.withLabel (Label.config name)
        |> Textarea.render identity () (sharedState.textarea |> modelPicker)
        |> Html.map
            (ElmBook.Actions.mapUpdate
                { toState = \state model -> { state | textarea = model }
                , fromState = .textarea
                , update = update
                }
            )
