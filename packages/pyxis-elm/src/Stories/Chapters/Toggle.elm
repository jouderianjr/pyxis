module Stories.Chapters.Toggle exposing (Model, docs, init)

import ElmBook
import ElmBook.Actions
import ElmBook.Chapter
import Html exposing (Html)
import Pyxis.Components.Field.Label as Label
import Pyxis.Components.Toggle as Toggle


docs : ElmBook.Chapter.Chapter (SharedState x)
docs =
    "Toggle"
        |> ElmBook.Chapter.chapter
        |> ElmBook.Chapter.withStatefulComponentList componentsList
        |> ElmBook.Chapter.render """

Toggle allow users to choose between two mutually exclusive options, and they should provide immediate results.
<component with-label="Default" />
```
type Msg =
    OnToggle Bool

toggle : String -> Bool -> Html Msg
toggle id initialState =
    Toggle.config id OnToggle
        |> Toggle.render initialState
```
## With Label
<component with-label="WithText" />
```
Toggle.config id OnToggle
    |> Toggle.withLabel (Label.config "Label")
    |> Toggle.render initialState
```
## With AriaLabel
<component with-label="WithAriaLabel" />
```
Toggle.config id OnToggle
    |> Toggle.withAriaLabel "Label"
    |> Toggle.render initialState
```
## With Disabled
<component with-label="WithDisabled" />
```
Toggle.config id OnToggle
    |> Toggle.withDisabled True
    |> Toggle.render initialState
```
"""


type alias SharedState x =
    { x | toggle : Model }


type alias Model =
    { base : Bool
    , disabled : Bool
    , label : Bool
    , ariaLabel : Bool
    }


init : Model
init =
    { base = True
    , disabled = False
    , label = False
    , ariaLabel = False
    }


componentsList : List ( String, SharedState x -> Html (ElmBook.Msg (SharedState x)) )
componentsList =
    [ ( "Default"
      , statefulComponent "toggle-id" identity .base setBase
      )
    , ( "WithDisabled"
      , statefulComponent "toggle-id-disabled" (Toggle.withDisabled True) .disabled setDisabled
      )
    , ( "WithText"
      , statefulComponent "toggle-id-label" (Toggle.withLabel (Label.config "Label")) .label setLabel
      )
    , ( "WithAriaLabel"
      , statefulComponent "toggle-id-aria-label" (Toggle.withAriaLabel "Label") .ariaLabel setAriaLabel
      )
    ]


statefulComponent :
    String
    -> (Toggle.Config (ElmBook.Msg (SharedState x)) -> Toggle.Config (ElmBook.Msg (SharedState x)))
    -> (Model -> Bool)
    -> (Bool -> Model -> Model)
    -> SharedState x
    -> Html (ElmBook.Msg (SharedState x))
statefulComponent id configModifier modelPicker updater sharedState =
    Toggle.config id (ElmBook.Actions.updateStateWith (updater >> mapModel))
        |> configModifier
        |> Toggle.render (sharedState.toggle |> modelPicker)


mapModel : (Model -> Model) -> SharedState x -> SharedState x
mapModel updateModel sharedState =
    { sharedState | toggle = updateModel sharedState.toggle }


setBase : Bool -> Model -> Model
setBase value model =
    { model | base = value }


setDisabled : Bool -> Model -> Model
setDisabled value model =
    { model | disabled = value }


setLabel : Bool -> Model -> Model
setLabel value model =
    { model | label = value }


setAriaLabel : Bool -> Model -> Model
setAriaLabel value model =
    { model | ariaLabel = value }
