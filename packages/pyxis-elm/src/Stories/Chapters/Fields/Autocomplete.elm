module Stories.Chapters.Fields.Autocomplete exposing (Models, docs, init)

import ElmBook
import ElmBook.Actions
import ElmBook.Chapter
import Html exposing (Html)
import Pyxis.Components.Button as Button
import Pyxis.Components.Field.Autocomplete as Autocomplete
import Pyxis.Components.Field.Label as Label
import Pyxis.Components.IconSet as IconSet
import RemoteData


docs : ElmBook.Chapter.Chapter (SharedState x)
docs =
    "Autocomplete"
        |> ElmBook.Chapter.chapter
        |> ElmBook.Chapter.withStatefulComponentList componentsList
        |> ElmBook.Chapter.render """
Autocomplete is used to search data across both predefined and dynamic data source.
It allows you to handle your data via a generic _value_.

Data is provided by the user so autocomplete only handles its logic without executing a query o reading a datasource.

<component with-label="Autocomplete" />
```
{-| Provide your data type the way its best represented.
-}
type Job
    = Developer
    | Designer
    | ProductManager


{-| Provide your own filter function.
-}
jobMatches : String -> Job -> Bool
jobMatches searchTerm =
    jobToLabel
        >> String.toLower
        >> String.contains (String.toLower searchTerm)


{-| Provide a way to get a label from your value.
-}
jobToLabel : Job -> String
jobToLabel job =
    case job of
        Developer ->
            "Developer"
        Designer ->
            "Designer"
        ProductManager ->
            "ProductManager"


{-| Define your application message.
-}
type Msg
    = JobFetched (RemoteData () (List Job))
    | AutocompleteMsg (Autocomplete.Msg Job)


{-| Define your model.
-}
type alias Model = {
    job : Autocomplete.Model Job (Autocomplete.Msg Job)
}


initialModel : Model
initialModel =
    { job = Autocomplete.init jobToLabel jobMatches
    }


{-| The autocomplete receives suggestions from you representing them via a RemoteData wrapper.
Setting suggestions is up to you.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        JobFetched remoteData ->
            ( { model | job = Autocomplete.setOptions remoteData model.job }, Cmd.none )

        AutocompleteMsg subMsg ->
            let
                ( autocompleteModel, autocompleteCmd ) =
                    Autocomplete.update subMsg model.job
            in
            ( { model | job = autocompleteModel }, autocompleteCmd )


validation : Maybe Job -> Result String Job
validation =
    Result.fromMaybe "Required field"


{-| Render your autocomplete.
-}
view : Bool -> Model -> Html Msg
view isSubmitted model =
    Autocomplete.config "autocomplete-name"
        |> Autocomplete.withValidationOnBlur validation isSubmitted
        |> Autocomplete.withPlaceholder "Choose your job role"
        |> Autocomplete.render AutocompleteMsg model.job
```

## Generics

<component with-label="Additional content" />
```
Autocomplete.config "autocomplete-name"
    |> Autocomplete.withAdditionalContent (Html.text "Additional content to the Autocomplete")
    |> Autocomplete.render AutocompleteMsg model.job
```

<component with-label="Hint" />
```
Autocomplete.config "autocomplete-name"
    |> Autocomplete.withHint "This is an hint for the autocomplete"
    |> Autocomplete.render AutocompleteMsg model.job
```

<component with-label="Disabled" />
```
Autocomplete.config "autocomplete-name"
    |> Autocomplete.withDisabled True
    |> Autocomplete.render AutocompleteMsg model.job
```

<component with-label="Label" />
```
Autocomplete.config "autocomplete-name"
    |> Autocomplete.withLabel (Label.config "Label")
    |> Autocomplete.render AutocompleteMsg model.job
```

<component with-label="No Results Found Message" />
```
Autocomplete.config "autocomplete-name"
    |> Autocomplete.withNoResultsFoundMessage "No result for this search!"
    |> Autocomplete.render AutocompleteMsg model.job
```

<component with-label="Placeholder" />
```
Autocomplete.config "autocomplete-name"
    |> Autocomplete.withPlaceholder "Placeholder"
    |> Autocomplete.render AutocompleteMsg model.job
```

<component with-label="Size small" />
```
Autocomplete.config "autocomplete-name"
    |> Autocomplete.withSize Autocomplete.small
    |> Autocomplete.render AutocompleteMsg model.job
```

## Addon

### No Result Found Action
A button or link that appears at the end of the list of options, in case that the list is empty (there are no results).
<component with-label="NoResultFoundAction" />
```
Autocomplete.config "autocomplete-name"
    |> Autocomplete.withNoResultFoundAction
        (Button.ghost
            |> Button.withText "Visit the page"
            |> Button.withType (Button.link "https://www.google.com")
            |> Button.render
        )
    |> Autocomplete.render AutocompleteMsg model.job
```

### Header Text
A text that appears at the begging of the list of options.
<component with-label="HeaderText" />
```
Autocomplete.config "autocomplete-name"
    |> Autocomplete.withHeaderText "Choose a role:"
    |> Autocomplete.render AutocompleteMsg model.job
```

### Suggestion
A hint composed by title and subtitle that appears in the dropdown before starting to type.
<component with-label="Suggestion" />
```
Autocomplete.config "autocomplete-name"
    |> Autocomplete.withSuggestion { title = "Suggestion", subtitle = Just "Subtitle", icon = IconSet.Search }
    |> Autocomplete.render AutocompleteMsg model.job
```
"""


type alias SharedState x =
    { x | autocomplete : Models }


type Msg
    = OnSelect StoryType
    | AutocompleteMsg StoryType (Autocomplete.Msg Job)


type StoryType
    = Base
    | NoResult


type Job
    = Developer
    | Designer
    | ProductManager


type alias Model =
    Autocomplete.Model Job Msg


type alias Models =
    { base : Model
    , noResult : Model
    }


initAutocomplete : StoryType -> Model
initAutocomplete type_ =
    Autocomplete.init
        jobToLabel
        optionsFilter
        |> Autocomplete.setOnSelect (OnSelect type_)


required : Maybe Job -> Result String Job
required =
    Result.fromMaybe "Required field"


init : Models
init =
    { base = initAutocomplete Base
    , noResult = initAutocomplete NoResult
    }


jobToLabel : Job -> String
jobToLabel job =
    case job of
        Developer ->
            "Developer"

        Designer ->
            "Designer"

        ProductManager ->
            "Product manager"


componentsList : List ( String, SharedState x -> Html (ElmBook.Msg (SharedState x)) )
componentsList =
    [ ( "Autocomplete"
      , statefulComponent
            "autocomplete-default"
            Base
            (Autocomplete.withLabel (Label.config "Label"))
            .base
      )
    , ( "Additional content"
      , statefulComponent
            "autocomplete-additional-content"
            Base
            (Autocomplete.withAdditionalContent (Html.text "Additional content to the Autocomplete"))
            .base
      )
    , ( "Hint"
      , statefulComponent
            "autocomplete-hint"
            Base
            (Autocomplete.withHint "This is an hint for the autocomplete")
            .base
      )
    , ( "Disabled"
      , statefulComponent
            "autocomplete-disabled"
            Base
            (Autocomplete.withDisabled True)
            .base
      )
    , ( "Label"
      , statefulComponent
            "autocomplete-label"
            Base
            (Autocomplete.withLabel (Label.config "Label"))
            .base
      )
    , ( "No Results Found Message"
      , statefulComponent
            "autocomplete-message"
            NoResult
            (Autocomplete.withNoResultsFoundMessage "No result for this search!")
            .noResult
      )
    , ( "Placeholder"
      , statefulComponent
            "autocomplete-placeholder"
            Base
            (Autocomplete.withPlaceholder "Placeholder")
            .base
      )
    , ( "Size small"
      , statefulComponent
            "autocomplete-small"
            Base
            (Autocomplete.withSize Autocomplete.small)
            .base
      )
    , ( "NoResultFoundAction"
      , statefulComponent
            "autocomplete-action"
            Base
            (Autocomplete.withNoResultFoundAction
                (Button.ghost
                    |> Button.withText "Visit the page"
                    |> Button.withType (Button.link "https://www.google.com")
                    |> Button.render
                )
            )
            .base
      )
    , ( "HeaderText"
      , statefulComponent
            "autocomplete-header"
            Base
            (Autocomplete.withHeaderText "Choose a role:")
            .base
      )
    , ( "Suggestion"
      , statefulComponent
            "autocomplete-suggestion"
            NoResult
            (Autocomplete.withSuggestion { title = "Suggestion", subtitle = Just "Subtitle", icon = IconSet.Search })
            .noResult
      )
    ]


update : Msg -> Models -> ( Models, Cmd Msg )
update msg model =
    case msg of
        OnSelect Base ->
            ( { model | base = model.base |> Autocomplete.setDropdownClosed }, Cmd.none )

        OnSelect NoResult ->
            ( { model | noResult = model.noResult |> Autocomplete.setDropdownClosed }, Cmd.none )

        AutocompleteMsg Base internalMsg ->
            let
                ( autocompleteModel, autocompleteCmd ) =
                    Autocomplete.update internalMsg model.base
            in
            ( { model
                | base =
                    autocompleteModel
                        |> Autocomplete.setOptions (RemoteData.Success [ Designer, Developer, ProductManager ])
              }
            , autocompleteCmd
            )

        AutocompleteMsg NoResult internalMsg ->
            let
                ( autocompleteModel, autocompleteCmd ) =
                    Autocomplete.update internalMsg model.noResult
            in
            ( { model
                | noResult =
                    autocompleteModel
                        |> Autocomplete.setOptions (RemoteData.Success [])
              }
            , autocompleteCmd
            )


statefulComponent :
    String
    -> StoryType
    -> (Autocomplete.Config Job Job Msg -> Autocomplete.Config Job Job Msg)
    -> (Models -> Model)
    -> SharedState x
    -> Html (ElmBook.Msg (SharedState x))
statefulComponent name storyType mapper modelPicker sharedState =
    Autocomplete.config name
        |> Autocomplete.withValidationOnBlur required False
        |> mapper
        |> Autocomplete.render (AutocompleteMsg storyType) (sharedState.autocomplete |> modelPicker)
        |> Html.map
            (ElmBook.Actions.mapUpdateWithCmd
                { toState = \state model -> { state | autocomplete = model }
                , fromState = .autocomplete
                , update = update
                }
            )


optionsFilter : String -> Job -> Bool
optionsFilter filter =
    jobToLabel
        >> String.toLower
        >> String.contains (String.toLower filter)
