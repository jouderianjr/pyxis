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


selectModel : Select.Model Job
selectModel =
    Select.init
        |> Select.setOptions options


options : List Select.Option
options =
    [ Select.option { value = "DEVELOPER", label = "Developer" }
    , Select.option { value = "DESIGNER", label = "Designer" }
    , Select.option { value = "PRODUCT_MANAGER", label = "Product Manager" }
    , Select.option { value = "CEO", label = "Chief executive officer" }
    ]


isMobile : Bool
isMobile =
    False


select : Bool -> formData -> Html Msg
select isSubmitted formData =
    Select.config "fuzz" isMobile
        |> Select.withValidationOnBlur validation isSubmitted
        |> Select.withPlaceholder "Select your role..."
        |> Select.render OnSelectMsg formData selectModel
```

And the native `<select>` on mobile:

<component with-label="Select (mobile)" />
```
Select.config "fuzz" True
    |> Select.render OnSelectMsg formData selectModel
```

### Disabled

<component with-label="Select with disabled=True" />
```
Select.config "fuzz" False
    |> Select.withDisabled True
    |> Select.render OnSelectMsg formData selectModel
```

### Size
Select can have two size: default or small.

<component with-label="Select with size=Small" />
```
Select.config "fuzz" False
    |> Select.withSize Select.small
    |> Select.render OnSelectMsg formData selectModel
```

### With Additional Content

<component with-label="Select with additional content" />
```
Select.config "fuzz" False
    |> Select.withAdditionalContent (Html.text "Additional Content")
    |> Select.render OnSelectMsg formData selectModel
```
"""


type alias SharedState x =
    { x
        | select : Model
    }


type alias Model =
    { base : Select.Model Select.Msg
    , mobile : Select.Model Select.Msg
    , disabled : Select.Model Select.Msg
    , small : Select.Model Select.Msg
    , additionalContent : Select.Model Select.Msg
    }


required : formData -> Maybe String -> Result String Job
required _ maybeValue =
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
    { base = Select.init |> Select.setOptions options
    , mobile = Select.init |> Select.setOptions options
    , disabled = Select.init |> Select.setOptions options
    , small = Select.init |> Select.setOptions options
    , additionalContent = Select.init |> Select.setOptions options
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
            { isMobile = True, configModifier = Select.withValidationOnBlur required False }
            .mobile
            updateMobile
      )
    , ( "Select with disabled=True"
      , statefulComponent
            { isMobile = False
            , configModifier =
                Select.withDisabled True
                    >> Select.withValidationOnBlur required False
            }
            .disabled
            (always (\model -> ( model, Cmd.none )))
      )
    , ( "Select with size=Small"
      , statefulComponent
            { isMobile = False
            , configModifier =
                Select.withSize Select.small
                    >> Select.withValidationOnBlur required False
            }
            .small
            updateSmall
      )
    , ( "Select with additional content"
      , statefulComponent
            { isMobile = False
            , configModifier =
                Select.withAdditionalContent (Html.text "Additional Content")
                    >> Select.withValidationOnBlur required False
            }
            .additionalContent
            updateAdditionalContent
      )
    ]


type alias StatelessConfig =
    { isMobile : Bool
    , configModifier : Select.Config () Job -> Select.Config () Job
    }


statefulComponent :
    StatelessConfig
    -> (Model -> Select.Model Select.Msg)
    -> (Select.Msg -> Model -> ( Model, Cmd Select.Msg ))
    -> SharedState x
    -> Html (ElmBook.Msg (SharedState x))
statefulComponent { isMobile, configModifier } modelPicker internalUpdate sharedState =
    Select.config "example" isMobile
        |> Select.withPlaceholder "Select your role..."
        |> Select.withValidationOnBlur required False
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


updateMobile : Select.Msg -> Model -> ( Model, Cmd Select.Msg )
updateMobile msg model =
    let
        ( newModel, newCmd ) =
            Select.update msg model.mobile
    in
    ( { model | mobile = newModel }
    , newCmd
    )


updateSmall : Select.Msg -> Model -> ( Model, Cmd Select.Msg )
updateSmall msg model =
    let
        ( newModel, newCmd ) =
            Select.update msg model.small
    in
    ( { model | small = newModel }
    , newCmd
    )


updateAdditionalContent : Select.Msg -> Model -> ( Model, Cmd Select.Msg )
updateAdditionalContent msg model =
    let
        ( newModel, newCmd ) =
            Select.update msg model.additionalContent
    in
    ( { model | additionalContent = newModel }
    , newCmd
    )
