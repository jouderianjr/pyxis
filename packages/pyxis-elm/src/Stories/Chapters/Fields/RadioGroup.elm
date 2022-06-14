module Stories.Chapters.Fields.RadioGroup exposing (Model, docs, init)

import ElmBook
import ElmBook.Actions
import ElmBook.Chapter
import Html exposing (Html)
import Pyxis.Components.Field.Label as Label
import Pyxis.Components.Field.RadioGroup as RadioGroup


docs : ElmBook.Chapter.Chapter (SharedState x)
docs =
    "RadioGroup"
        |> ElmBook.Chapter.chapter
        |> ElmBook.Chapter.withStatefulComponentList componentsList
        |> ElmBook.Chapter.render """
A radio group is used to combine and provide structure to group of radio buttons, placing element such as label and error message in a pleasant and clear way.
Radio group have a horizontal layout as default, but with more then two items a vertical layout is recommended.

<component with-label="RadioGroup" />
```
type Option
    = Home
    | Motor


type Msg
    = OnRadioFieldMsg (RadioGroup.Msg Option)


validation : () -> Maybe Option -> Result String Option
validation _ value =
    value
        |> Maybe.map (Ok)
        |> Maybe.withDefault (Err "Invalid selection")


radioGroupModel : RadioGroup.Model (RadioGroup.Msg Option) () Option Option
radioGroupModel =
    RadioGroup.init (Just Home) validation


radioGroupView : () -> Html Msg
radioGroupView formData =
    RadioGroup.config "radio-name"
        |> RadioGroup.withName "insurance-type"
        |> RadioGroup.withLabel (Label.config "Choose the insurance type")
        |> RadioGroup.withOptions
            [ RadioGroup.option { value = Home, label = "Home" }
            , RadioGroup.option { value = Motor, label = "Motor" }
            ]
        |> RadioGroup.render OnRadioFieldMsg formData radioGroupModel
```

# Vertical Layout
A radio group is used to combine and provide structure to group of radio buttons, placing element such as label and error message in a pleasant and clear way. Also, it could display a hint message to help final user fill the group.

Radio group have a horizontal layout as default, but with more then two items a vertical layout is recommended.

<component with-label="RadioGroup vertical" />

```
RadioGroup.config name
    |> RadioGroup.withLayout RadioGroup.vertical
    |> RadioGroup.render
        OnRadioFieldMsg
        formData
        (radioGroupModel |> RadioGroup.setValue Motor)
```


# Disabled
<component with-label="RadioGroup disabled" />
```
RadioGroup.config name
    |> RadioGroup.withDisabled True
    |> RadioGroup.render
        OnRadioFieldMsg
        formData
        (radioGroupModel |> RadioGroup.setValue Home)
```
"""


type alias SharedState x =
    { x | radio : Model }


type Product
    = Home
    | Motor


type alias Model =
    { base : RadioGroup.Model () Product Product (RadioGroup.Msg Product)
    , vertical : RadioGroup.Model () Product Product (RadioGroup.Msg Product)
    , disabled : RadioGroup.Model () Product Product (RadioGroup.Msg Product)
    }


init : Model
init =
    { base =
        RadioGroup.init Nothing (always (Result.fromMaybe "Invalid selection"))
    , vertical =
        RadioGroup.init (Just Motor) (always (Result.fromMaybe "Invalid selection"))
    , disabled =
        RadioGroup.init (Just Home) (always (Result.fromMaybe "Invalid selection"))
    }


componentsList : List ( String, SharedState x -> Html (ElmBook.Msg (SharedState x)) )
componentsList =
    [ ( "RadioGroup"
      , statefulComponent
            { name = "radio-group"
            , configModifier = RadioGroup.withLabel (Label.config "Choose the insurance type")
            , modelPicker = .base
            , update =
                \msg model ->
                    let
                        ( updatedModel, cmd ) =
                            RadioGroup.update msg model.base
                    in
                    ( { model | base = updatedModel }, cmd )
            }
      )
    , ( "RadioGroup vertical"
      , statefulComponent
            { name = "radio-group-vertical"
            , configModifier = RadioGroup.withLayout RadioGroup.vertical
            , modelPicker = .vertical
            , update =
                \msg model ->
                    let
                        ( updatedModel, cmd ) =
                            RadioGroup.update msg model.vertical
                    in
                    ( { model | base = updatedModel }, cmd )
            }
      )
    , ( "RadioGroup disabled"
      , statefulComponent
            { name = "radio-group-disabled"
            , configModifier = RadioGroup.withDisabled True
            , modelPicker = .disabled
            , update = \_ model -> ( model, Cmd.none )
            }
      )
    ]


options : List (RadioGroup.Option Product)
options =
    [ RadioGroup.option { value = Home, label = "Home" }
    , RadioGroup.option { value = Motor, label = "Motor" }
    ]


type alias StatefulConfig =
    { name : String
    , configModifier : RadioGroup.Config Product -> RadioGroup.Config Product
    , modelPicker : Model -> RadioGroup.Model () Product Product (RadioGroup.Msg Product)
    , update : RadioGroup.Msg Product -> Model -> ( Model, Cmd (RadioGroup.Msg Product) )
    }


statefulComponent : StatefulConfig -> SharedState x -> Html (ElmBook.Msg (SharedState x))
statefulComponent { name, configModifier, modelPicker, update } sharedState =
    RadioGroup.config name
        |> RadioGroup.withOptions options
        |> configModifier
        |> RadioGroup.render identity () (sharedState.radio |> modelPicker)
        |> Html.map
            (ElmBook.Actions.mapUpdateWithCmd
                { toState = \sharedState_ model -> { sharedState_ | radio = model }
                , fromState = .radio
                , update = update
                }
            )
