module Stories.Chapters.Fields.CheckboxGroup exposing (Model, docs, init)

import ElmBook
import ElmBook.Actions
import ElmBook.Chapter
import Html exposing (Html)
import Html.Attributes
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


validation : formData -> List Option -> Result String (List Option)
validation _ selected =
    case selected of
        [] ->
            Err "You must select at least one option"

        _ ->
            Ok selected


checkboxGroupModel : CheckboxGroup.Model formdata Option (List Option)
checkboxGroupModel =
    CheckboxGroup.init [] validation


checkboxGroup : formData -> Html Msg
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

# With a single option
<component with-label="CheckboxGroup with a single option" />
```
CheckboxGroup.single
    (Html.div []
     [ Html.text
         "Dichiaro di aver letto l’"
     , Html.a
         [ Html.Attributes.href "https://www.prima.it/app/privacy-policy"
         , Html.Attributes.target "blank"
         , Html.Attributes.class "link"
         ]
         [ Html.text "Informativa Privacy" ]
     , Html.text
         ", disposta ai sensi degli articoli 13 e 14 del Regolamento UE 2016/679. "
     ]
    )
    "checkbox-name"
    |> CheckboxGroup.render
        OnCheckboxGroupMsg
        formData
        checkboxGroupModel
```
"""


type alias SharedState x =
    { x
        | checkbox : CheckboxFieldModels
    }


type Option
    = Elm
    | Typescript
    | Rust
    | Elixir


type alias CheckboxFieldModels =
    { base : CheckboxGroup.Model () Option (List Option)
    , noValidation : CheckboxGroup.Model () Option (List Option)
    , disabled : CheckboxGroup.Model () Option (List Option)
    , single : CheckboxGroup.Model () () Bool
    }


type alias Model =
    CheckboxFieldModels


validation : () -> List Option -> Result String (List Option)
validation _ selected =
    case selected of
        [] ->
            Err "You must select at least one option"

        _ ->
            Ok selected


singleOptionValidation : () -> List () -> Result error Bool
singleOptionValidation () =
    List.member () >> Ok


init : CheckboxFieldModels
init =
    { base = CheckboxGroup.init [] validation
    , noValidation = CheckboxGroup.init [] (always Ok)
    , disabled = CheckboxGroup.init [] (always Ok)
    , single = CheckboxGroup.init [] singleOptionValidation
    }


options : List (CheckboxGroup.Option Option msg)
options =
    [ CheckboxGroup.option { value = Elm, label = Html.text "Elm" }
    , CheckboxGroup.option { value = Typescript, label = Html.text "Typescript" }
    , CheckboxGroup.option { value = Rust, label = Html.text "Rust" }
    , CheckboxGroup.option { value = Elixir, label = Html.text "Elixir" }
    ]


optionsWithDisabled : List (CheckboxGroup.Option Option msg)
optionsWithDisabled =
    [ CheckboxGroup.option { value = Elm, label = Html.text "Elm" }
    , CheckboxGroup.option { value = Typescript, label = Html.text "Typescript" }
    , CheckboxGroup.option { value = Rust, label = Html.text "Rust" }
    , CheckboxGroup.option { value = Elixir, label = Html.text "Elixir" }
        |> CheckboxGroup.withDisabledOption True
    ]


componentsList : List ( String, SharedState x -> Html (ElmBook.Msg (SharedState x)) )
componentsList =
    [ ( "CheckboxGroup"
      , statefulComponent
            { name = "checkbox-group"
            , configModifier = CheckboxGroup.withLabel (Label.config "Choose at least one language")
            , modelPicker = .base
            , update = \msg models -> { models | base = CheckboxGroup.update msg models.base }
            }
      )
    , ( "CheckboxGroup with vertical layout"
      , statefulComponent
            { name = "checkbox-group-vertical"
            , configModifier = CheckboxGroup.withLayout CheckboxGroup.vertical
            , modelPicker = .noValidation
            , update = \msg models -> { models | noValidation = CheckboxGroup.update msg models.noValidation }
            }
      )
    , ( "CheckboxGroup with a disabled option"
      , statefulComponent
            { name = "checkbox-group-disabled"
            , configModifier = CheckboxGroup.withOptions optionsWithDisabled
            , modelPicker = .disabled
            , update = \msg models -> { models | disabled = CheckboxGroup.update msg models.disabled }
            }
      )
    , ( "CheckboxGroup with a single option"
      , \sharedState ->
            CheckboxGroup.single
                (Html.div []
                    [ Html.text
                        "Dichiaro di aver letto l’"
                    , Html.a
                        [ Html.Attributes.href "https://www.prima.it/app/privacy-policy"
                        , Html.Attributes.target "blank"
                        , Html.Attributes.class "link"
                        ]
                        [ Html.text "Informativa Privacy" ]
                    , Html.text
                        ", disposta ai sensi degli articoli 13 e 14 del Regolamento UE 2016/679. "
                    ]
                )
                "checkbox-name"
                |> CheckboxGroup.render identity () sharedState.checkbox.single
                |> Html.map
                    (ElmBook.Actions.mapUpdate
                        { toState = \sharedState_ models -> { sharedState_ | checkbox = models }
                        , fromState = .checkbox
                        , update = \msg models -> { models | single = CheckboxGroup.update msg models.single }
                        }
                    )
      )
    ]


type alias StatefulConfig msg =
    { name : String
    , configModifier : CheckboxGroup.Config Option msg -> CheckboxGroup.Config Option msg
    , modelPicker : CheckboxFieldModels -> CheckboxGroup.Model () Option (List Option)
    , update : CheckboxGroup.Msg Option -> CheckboxFieldModels -> CheckboxFieldModels
    }


statefulComponent : StatefulConfig (CheckboxGroup.Msg Option) -> SharedState x -> Html (ElmBook.Msg (SharedState x))
statefulComponent { name, configModifier, modelPicker, update } sharedState =
    CheckboxGroup.config name
        |> CheckboxGroup.withOptions options
        |> configModifier
        |> CheckboxGroup.render identity () (sharedState.checkbox |> modelPicker)
        |> Html.map
            (ElmBook.Actions.mapUpdate
                { toState = \sharedState_ models -> { sharedState_ | checkbox = models }
                , fromState = .checkbox
                , update = update
                }
            )
