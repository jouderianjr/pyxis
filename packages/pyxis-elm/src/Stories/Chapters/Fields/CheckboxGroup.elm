module Stories.Chapters.Fields.CheckboxGroup exposing (Model, docs, init)

import ElmBook
import ElmBook.Actions
import ElmBook.Chapter
import Html exposing (Html)
import Pyxis.Components.Field.CheckboxGroup as CheckboxGroup
import Pyxis.Components.Field.Label as Label


docs : ElmBook.Chapter.Chapter (SharedState x)
docs =
    "CheckboxGroup"
        |> ElmBook.Chapter.chapter
        |> ElmBook.Chapter.withStatefulComponentList componentsList
        |> ElmBook.Chapter.render """
Checkbox lets the user make zero or multiple selection from a list of options.

<component with-label="CheckboxGroup" />
```
type Option
    = Elm
    | Typescript
    | Rust
    | Elixir


type Msg
    = OnCheckboxGroupMsg (CheckboxGroup.Msg Option)


validation : () -> List Option -> Result String (List Option)
validation _ selected =
    case selected of
        [] ->
            Err "You must select at least one option"

        _ ->
            Ok selected


checkboxGroupModel : CheckboxGroup.Model () Option (CheckboxGroup.Msg Option)
checkboxGroupModel =
    CheckboxGroup.init [] validation


checkboxGroup : () -> Html Msg
checkboxGroup formData =
    CheckboxGroup.config "checkbox-name"
        |> CheckboxGroup.withOptions
            [ CheckboxGroup.option { value = Elm, label = Html.text "Elm" }
            , CheckboxGroup.option { value = Typescript, label = Html.text "Typescript" }
            , CheckboxGroup.option { value = Rust, label = Html.text "Rust" }
            , CheckboxGroup.option { value = Elixir, label = Html.text "Elixir" }
            ]
        |> CheckboxGroup.render OnCheckboxGroupMsg formData checkboxGroupModel
```

# Vertical Layout

<component with-label="CheckboxGroup with vertical layout" />
```
CheckboxGroup.config "checkbox-name"
    |> CheckboxGroup.withLayout CheckboxGroup.vertical
    |> CheckboxGroup.render
        OnCheckboxGroupMsg
        formData
        checkboxGroupModel
```
# With an option disabled

<component with-label="CheckboxGroup with a disabled option" />
```
options : List (CheckboxGroup.Option Option msg)
options =
    [ CheckboxGroup.option { value = Elm, label = Html.text "Elm" }
    , CheckboxGroup.option { value = Typescript, label = Html.text "Typescript" }
    , CheckboxGroup.option { value = Rust, label = Html.text "Rust" }
    , CheckboxGroup.option { value = Elixir, label = Html.text "Elixir" }
        |> CheckboxGroup.withDisabledOption True
    ]

CheckboxGroup.config "checkbox-name"
    |> CheckboxGroup.withOptions options
    |> CheckboxGroup.render
        OnCheckboxGroupMsg
        formData
        checkboxGroupModel
```

# With Additional Content

<component with-label="CheckboxGroup with additional content" />
```
CheckboxGroup.config "checkbox-name"
    |> CheckboxGroup.withAdditionalContent (Html.text "Additional Content")
    |> CheckboxGroup.render
        OnCheckboxGroupMsg
        formData
        checkboxGroupModel
"""


type alias SharedState x =
    { x | checkbox : Model }


type Language
    = Elm
    | Typescript
    | Rust
    | Elixir


type alias Model =
    { base : CheckboxGroup.Model () Language (CheckboxGroup.Msg Language)
    , noValidation : CheckboxGroup.Model () Language (CheckboxGroup.Msg Language)
    , disabled : CheckboxGroup.Model () Language (CheckboxGroup.Msg Language)
    , additionalContent : CheckboxGroup.Model () Language (CheckboxGroup.Msg Language)
    }


init : Model
init =
    { base = CheckboxGroup.init [] validation
    , noValidation = CheckboxGroup.init [] validation
    , disabled = CheckboxGroup.init [] validation
    , additionalContent = CheckboxGroup.init [] validation
    }


validation : () -> List Language -> Result String (List Language)
validation _ selected =
    case selected of
        [] ->
            Err "You must select at least one option"

        _ ->
            Ok selected


options : List (CheckboxGroup.Option Language msg)
options =
    [ CheckboxGroup.option { value = Elm, label = Html.text "Elm" }
    , CheckboxGroup.option { value = Typescript, label = Html.text "Typescript" }
    , CheckboxGroup.option { value = Rust, label = Html.text "Rust" }
    , CheckboxGroup.option { value = Elixir, label = Html.text "Elixir" }
    ]


optionsWithDisabled : List (CheckboxGroup.Option Language msg)
optionsWithDisabled =
    [ CheckboxGroup.option { value = Elm, label = Html.text "Elm" }
    , CheckboxGroup.option { value = Typescript, label = Html.text "Typescript" }
    , CheckboxGroup.option { value = Rust, label = Html.text "Rust" }
    , CheckboxGroup.option { value = Elixir, label = Html.text "Elixir" }
        |> CheckboxGroup.withDisabledOption True
    ]


type alias StatefulConfig msg =
    { name : String
    , configModifier : CheckboxGroup.Config Language msg -> CheckboxGroup.Config Language msg
    , modelPicker : Model -> CheckboxGroup.Model () Language (CheckboxGroup.Msg Language)
    , update : CheckboxGroup.Msg Language -> Model -> ( Model, Cmd (CheckboxGroup.Msg Language) )
    }


statefulComponent : StatefulConfig (CheckboxGroup.Msg Language) -> SharedState x -> Html (ElmBook.Msg (SharedState x))
statefulComponent { name, configModifier, modelPicker, update } sharedState =
    CheckboxGroup.config name
        |> CheckboxGroup.withOptions options
        |> configModifier
        |> CheckboxGroup.render identity () (sharedState.checkbox |> modelPicker)
        |> Html.map
            (ElmBook.Actions.mapUpdateWithCmd
                { toState = \sharedState_ models -> { sharedState_ | checkbox = models }
                , fromState = .checkbox
                , update = update
                }
            )


componentsList : List ( String, SharedState x -> Html (ElmBook.Msg (SharedState x)) )
componentsList =
    [ ( "CheckboxGroup"
      , statefulComponent
            { name = "checkbox-group"
            , configModifier = CheckboxGroup.withLabel (Label.config "Choose at least one language")
            , modelPicker = .base
            , update =
                \msg models ->
                    ( { models | base = Tuple.first (CheckboxGroup.update msg models.base) }
                    , Tuple.second (CheckboxGroup.update msg models.base)
                    )
            }
      )
    , ( "CheckboxGroup with vertical layout"
      , statefulComponent
            { name = "checkbox-group-vertical"
            , configModifier = CheckboxGroup.withLayout CheckboxGroup.vertical
            , modelPicker = .noValidation
            , update =
                \msg models ->
                    ( { models | noValidation = Tuple.first (CheckboxGroup.update msg models.noValidation) }
                    , Tuple.second (CheckboxGroup.update msg models.noValidation)
                    )
            }
      )
    , ( "CheckboxGroup with a disabled option"
      , statefulComponent
            { name = "checkbox-group-disabled"
            , configModifier = CheckboxGroup.withOptions optionsWithDisabled
            , modelPicker = .disabled
            , update =
                \msg models ->
                    ( { models | disabled = Tuple.first (CheckboxGroup.update msg models.disabled) }
                    , Tuple.second (CheckboxGroup.update msg models.disabled)
                    )
            }
      )
    , ( "CheckboxGroup with additional content"
      , statefulComponent
            { name = "checkbox-group-with-additional-content"
            , configModifier = CheckboxGroup.withAdditionalContent (Html.text "Additional Content")
            , modelPicker = .additionalContent
            , update =
                \msg models ->
                    ( { models | additionalContent = Tuple.first (CheckboxGroup.update msg models.additionalContent) }
                    , Tuple.second (CheckboxGroup.update msg models.additionalContent)
                    )
            }
      )
    ]
