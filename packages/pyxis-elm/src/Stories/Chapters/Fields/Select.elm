module Stories.Chapters.Fields.Select exposing (Model, docs, init)

import ElmBook
import ElmBook.Actions
import ElmBook.Chapter
import Html exposing (Html)
import Pyxis.Components.Field.Label as Label
import Pyxis.Components.Field.Select as Select


docs : ElmBook.Chapter.Chapter (SharedState x)
docs =
    "Select"
        |> ElmBook.Chapter.chapter
        |> ElmBook.Chapter.withStatefulComponentList componentsList
        |> ElmBook.Chapter.render """
Select components enable the selection of one out of at least four options provided in a list.
They are typically used within a form to allow users to make their desired selection from the list of options.

The select component uses a custom wrapper on desktop:

<component with-label="Select (desktop)" />
```
type Job
    = Developer
    | Designer
    | ProductManager
    | CEO


type Msg
    = OnSelectMsg (Select.Msg)


validation : () -> Maybe String -> Result String Job
validation _ maybeValue =
    maybeValue
        |> Maybe.andThen toJob
        |> Result.fromMaybe "Required field"


toJob : String -> Maybe Job
toJob rawValue =
    case rawValue of
        "DEVELOPER" ->
            Just Developer
        [...]
        _ ->
            Nothing


selectModel : Select.Model formData Job
selectModel =
    Select.init Nothing validation


options : List Select.Option
options =
    [ Select.option { value = "DEVELOPER", label = "Developer" }
    , Select.option { value = "DESIGNER", label = "Designer" }
    , Select.option { value = "PRODUCT_MANAGER", label = "Product Manager" }
    , Select.option { value = "CEO", label = "Chief executive officer" }
    ]


isMobile : Bool
isMobile = False


select : formData -> Html Select.Msg
select formData =
    Select.config isMobile "desktop-select"
        |> Select.withPlaceholder "Select your role..."
        |> Select.withOptions options
        |> Select.render OnSelectMsg formData selectModel
```

And the native `<select>` on mobile:

<component with-label="Select (mobile)" />
```
Select.config True "radio-name"
    |> Select.render OnSelectMsg formData selectModel
```

### Disabled

<component with-label="Select with disabled=True" />
```
Select.config False "radio-name"
    |> Select.withDisabled True
    |> Select.render OnSelectMsg formData selectModel
```

### Size
Select can have two size: default or small.

<component with-label="Select with size=Small" />
```
Select.config False "radio-name"
    |> Select.withSize Select.small
    |> Select.render OnSelectMsg formData selectModel
```
"""


type alias SharedState x =
    { x
        | select : Model
    }


type alias Model =
    { base : Select.Model () (Maybe String)
    , withValidation : Select.Model () Job
    }


requiredValidation : formData -> Maybe String -> Result String Job
requiredValidation _ maybeValue =
    maybeValue
        |> Maybe.andThen toJob
        |> Result.fromMaybe "Required field"
        |> Result.andThen
            (\j ->
                if j == ProductManager then
                    Err "This option is not selectable"

                else
                    Ok j
            )


toJob : String -> Maybe Job
toJob rawValue =
    case rawValue of
        "DEVELOPER" ->
            Just Developer

        "DESIGNER" ->
            Just Designer

        "PRODUCT_MANAGER" ->
            Just ProductManager

        "CEO" ->
            Just CEO

        _ ->
            Nothing


init : Model
init =
    { base = Select.init Nothing (always Ok)
    , withValidation = Select.init Nothing requiredValidation
    }


type Job
    = Developer
    | Designer
    | ProductManager
    | CEO


componentsList : List ( String, SharedState x -> Html (ElmBook.Msg (SharedState x)) )
componentsList =
    [ ( "Select (desktop)"
      , statefulComponent
            { name = "desktop-select"
            , isMobile = False
            , configModifier = Select.withLabel (Label.config "Label")
            }
            .withValidation
            updateWithValidation
      )
    , ( "Select (mobile)"
      , statelessComponent
            { name = "mobile-select", isMobile = True, configModifier = identity }
      )
    , ( "Select with disabled=True"
      , statelessComponent
            { name = "disabled-select", isMobile = False, configModifier = Select.withDisabled True }
      )
    , ( "Select with size=Small"
      , statelessComponent
            { name = "small-select", isMobile = False, configModifier = Select.withSize Select.small }
      )
    ]


type alias StatelessConfig =
    { name : String
    , isMobile : Bool
    , configModifier : Select.Config Select.Msg -> Select.Config Select.Msg
    }


statelessComponent :
    StatelessConfig
    -> SharedState x
    -> Html (ElmBook.Msg (SharedState x))
statelessComponent statelessConfig =
    statefulComponent statelessConfig .base updateBase


statefulComponent :
    StatelessConfig
    -> (Model -> Select.Model () parsed)
    -> (Select.Msg -> Model -> ( Model, Cmd Select.Msg ))
    -> SharedState x
    -> Html (ElmBook.Msg (SharedState x))
statefulComponent { name, isMobile, configModifier } modelPicker internalUpdate sharedState =
    Select.config isMobile name
        |> Select.withPlaceholder "Select your role..."
        |> Select.withOptions
            [ Select.option { value = "DEVELOPER", label = "Developer" }
            , Select.option { value = "DESIGNER", label = "Designer" }
            , Select.option { value = "PRODUCT_MANAGER", label = "Product Manager" }
            , Select.option { value = "CEO", label = "Chief Executive Officer" }
            ]
        |> configModifier
        |> Select.render identity () (sharedState.select |> modelPicker)
        |> Html.map
            (ElmBook.Actions.mapUpdateWithCmd
                { toState = \state model -> { state | select = model }
                , fromState = .select
                , update = internalUpdate
                }
            )


updateBase : Select.Msg -> Model -> ( Model, Cmd Select.Msg )
updateBase msg model =
    let
        ( newModel, newCmd ) =
            Select.update msg model.base
    in
    ( { model | base = newModel }
    , newCmd
    )


updateWithValidation : Select.Msg -> Model -> ( Model, Cmd Select.Msg )
updateWithValidation msg model =
    let
        ( newModel, newCmd ) =
            Select.update msg model.withValidation
    in
    ( { model | withValidation = newModel }
    , newCmd
    )
