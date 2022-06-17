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


validation : formData -> Maybe String -> Result String Job
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


selectModel : Select.Model formData Job
selectModel =
    Select.init "select-name" Nothing validation
        |> Select.setOptions options


options : List Select.Option
options =
    [ Select.option { value = "DEVELOPER", label = "Developer" }
    , Select.option { value = "DESIGNER", label = "Designer" }
    , Select.option { value = "PRODUCT_MANAGER", label = "Product Manager" }
    , Select.option { value = "CEO", label = "Chief executive officer" }
    ]


isMobile : Bool
isMobile = False


select : formData -> Html Msg
select formData =
    Select.config isMobile
        |> Select.withPlaceholder "Select your role..."
        |> Select.render OnSelectMsg formData selectModel
```

And the native `<select>` on mobile:

<component with-label="Select (mobile)" />
```
Select.config True
    |> Select.render OnSelectMsg formData selectModel
```

### Disabled

<component with-label="Select with disabled=True" />
```
Select.config False
    |> Select.withDisabled True
    |> Select.render OnSelectMsg formData selectModel
```

### Size
Select can have two size: default or small.

<component with-label="Select with size=Small" />
```
Select.config False
    |> Select.withSize Select.small
    |> Select.render OnSelectMsg formData selectModel
```

### With Additional Content

<component with-label="Select with additional content" />
```
Select.config False
    |> Select.withAdditionalContent (Html.text "Additional Content")
    |> Select.render OnSelectMsg formData selectModel
```
"""


type alias SharedState x =
    { x
        | select : Model
    }


type alias Model =
    { base : Select.Model () (Maybe String) Select.Msg
    , mobile : Select.Model () Job Select.Msg
    , disabled : Select.Model () Job Select.Msg
    , small : Select.Model () Job Select.Msg
    , additionalContent : Select.Model () Job Select.Msg
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
    { base = Select.init "base" Nothing (always Ok) |> Select.setOptions options
    , mobile = Select.init "mobile" Nothing requiredValidation |> Select.setOptions options
    , disabled = Select.init "disabled" Nothing requiredValidation |> Select.setOptions options
    , small = Select.init "small" Nothing requiredValidation |> Select.setOptions options
    , additionalContent = Select.init "additional-content" Nothing requiredValidation |> Select.setOptions options
    }


options : List Select.Option
options =
    [ Select.option { value = "DEVELOPER", label = "Developer" }
    , Select.option { value = "DESIGNER", label = "Designer" }
    , Select.option { value = "PRODUCT_MANAGER", label = "Product Manager" }
    , Select.option { value = "CEO", label = "Chief Executive Officer" }
    ]


type Job
    = Developer
    | Designer
    | ProductManager
    | CEO


componentsList : List ( String, SharedState x -> Html (ElmBook.Msg (SharedState x)) )
componentsList =
    [ ( "Select (desktop)"
      , statefulComponent
            { isMobile = False, configModifier = Select.withLabel (Label.config "Label") }
            .base
            updateBase
      )
    , ( "Select (mobile)"
      , statefulComponent
            { isMobile = True, configModifier = identity }
            .mobile
            updateMobile
      )
    , ( "Select with disabled=True"
      , statefulComponent
            { isMobile = False, configModifier = Select.withDisabled True }
            .disabled
            (always (\model -> ( model, Cmd.none )))
      )
    , ( "Select with size=Small"
      , statefulComponent
            { isMobile = False, configModifier = Select.withSize Select.small }
            .small
            updateSmall
      )
    , ( "Select with additional content"
      , statefulComponent
            { isMobile = False, configModifier = Select.withAdditionalContent (Html.text "Additional Content") }
            .small
            updateAdditionalContent
      )
    ]


type alias StatelessConfig =
    { isMobile : Bool
    , configModifier : Select.Config -> Select.Config
    }


statefulComponent :
    StatelessConfig
    -> (Model -> Select.Model () parsed Select.Msg)
    -> (Select.Msg -> Model -> ( Model, Cmd Select.Msg ))
    -> SharedState x
    -> Html (ElmBook.Msg (SharedState x))
statefulComponent { isMobile, configModifier } modelPicker internalUpdate sharedState =
    Select.config isMobile
        |> Select.withPlaceholder "Select your role..."
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
            Select.update identity msg model.base
    in
    ( { model | base = newModel }
    , newCmd
    )


updateMobile : Select.Msg -> Model -> ( Model, Cmd Select.Msg )
updateMobile msg model =
    let
        ( newModel, newCmd ) =
            Select.update identity msg model.mobile
    in
    ( { model | mobile = newModel }
    , newCmd
    )


updateSmall : Select.Msg -> Model -> ( Model, Cmd Select.Msg )
updateSmall msg model =
    let
        ( newModel, newCmd ) =
            Select.update identity msg model.small
    in
    ( { model | small = newModel }
    , newCmd
    )


updateAdditionalContent : Select.Msg -> Model -> ( Model, Cmd Select.Msg )
updateAdditionalContent msg model =
    let
        ( newModel, newCmd ) =
            Select.update identity msg model.additionalContent
    in
    ( { model | additionalContent = newModel }
    , newCmd
    )
