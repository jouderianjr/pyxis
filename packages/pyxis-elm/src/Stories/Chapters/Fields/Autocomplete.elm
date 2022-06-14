module Stories.Chapters.Fields.Autocomplete exposing (Models, docs, init)

import ElmBook
import ElmBook.Actions
import ElmBook.Chapter
import Html exposing (Html)
import PrimaFunction
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
    jobToLabel >> String.toLower >> String.contains (String.toLower searchTerm)

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
    job : Autocomplete.Model () Job (Autocomplete.Msg Job)
}

initialModel : Model
initialModel =
    { job =
        Autocomplete.init
            Nothing
            jobToLabel
            jobMatches
            (always (Result.fromMaybe ""))
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


{-| Render your autocomplete.
-}
view : Model -> Html Msg
view model =
    Autocomplete.config "autocomplete-name"
        |> Autocomplete.withPlaceholder "Choose your job role"
        |> Autocomplete.render AutocompleteMsg () model.job
```

## Generics

<component with-label="Additional content" />
```
Autocomplete.config "autocomplete-name"
    |> Autocomplete.withAdditionalContent (Html.text "Additional content to the Autocomplete")
    |> Autocomplete.render AutocompleteMsg () model.job
```

<component with-label="Hint" />
```
Autocomplete.config "autocomplete-name"
    |> Autocomplete.withHint "This is an hint for the autocomplete"
    |> Autocomplete.render AutocompleteMsg () model.job
```

<component with-label="Disabled" />
```
Autocomplete.config "autocomplete-name"
    |> Autocomplete.withDisabled True
    |> Autocomplete.render AutocompleteMsg () model.job
```

<component with-label="Label" />
```
Autocomplete.config "autocomplete-name"
    |> Autocomplete.withLabel (Label.config "Label")
    |> Autocomplete.render AutocompleteMsg () model.job
```

<component with-label="No Results Found Message" />
```
Autocomplete.config "autocomplete-name"
    |> Autocomplete.withNoResultsFoundMessage "No result for this search!"
    |> Autocomplete.render AutocompleteMsg () model.job
```

<component with-label="Placeholder" />
```
Autocomplete.config "autocomplete-name"
    |> Autocomplete.withPlaceholder "Placeholder"
    |> Autocomplete.render AutocompleteMsg () model.job
```

<component with-label="Size small" />
```
Autocomplete.config "autocomplete-name"
    |> Autocomplete.withSize Autocomplete.small
    |> Autocomplete.render AutocompleteMsg () model.job
```

## Addon
<component with-label="Action" />
```
Autocomplete.config "autocomplete-name"
    |> Autocomplete.withAddonAction
        (Button.ghost
            |> Button.withText "Visit the page"
            |> Button.withType (Button.link "https://www.google.com")
            |> Button.render
        )
    |> Autocomplete.render AutocompleteMsg () model.job
```

<component with-label="Header" />
```
Autocomplete.config "autocomplete-name"
    |> Autocomplete.withAddonHeader "Choose a role:"
    |> Autocomplete.render AutocompleteMsg () model.job
```

<component with-label="Suggestion" />
```
Autocomplete.config "autocomplete-name"
    |> Autocomplete.withAddonSuggestion { title = "Suggestion", subtitle = Just "Subtitle", icon = IconSet.Search }
    |> Autocomplete.render AutocompleteMsg () model.job
```
"""


type alias SharedState x =
    { x | autocomplete : Models }


type Job
    = Developer
    | Designer
    | ProductManager


type alias Model =
    Autocomplete.Model () Job (Autocomplete.Msg Job)


type alias Models =
    { base : Model
    , noResult : Model
    }


initAutocomplete : Model
initAutocomplete =
    Autocomplete.init
        Nothing
        jobToLabel
        optionsFilter
        (always (Result.fromMaybe "Required field"))


init : Models
init =
    { base = initAutocomplete
    , noResult = initAutocomplete
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
      , statefulComponent (Autocomplete.withLabel (Label.config "Label")) .base updateBase
      )
    , ( "Additional content"
      , statefulComponent
            (Autocomplete.withAdditionalContent (Html.text "Additional content to the Autocomplete"))
            .base
            updateBase
      )
    , ( "Hint"
      , statefulComponent (Autocomplete.withHint "This is an hint for the autocomplete") .base updateBase
      )
    , ( "Disabled"
      , statefulComponent (Autocomplete.withDisabled True) .base updateBase
      )
    , ( "Label"
      , statefulComponent (Autocomplete.withLabel (Label.config "Label")) .base updateBase
      )
    , ( "No Results Found Message"
      , statefulComponent (Autocomplete.withNoResultsFoundMessage "No result for this search!") .noResult updateNoResult
      )
    , ( "Placeholder"
      , statefulComponent (Autocomplete.withPlaceholder "Placeholder") .base updateBase
      )
    , ( "Size small"
      , statefulComponent (Autocomplete.withSize Autocomplete.small) .base updateBase
      )
    , ( "Action"
      , statefulComponent
            (Autocomplete.withAddonAction
                (Button.ghost
                    |> Button.withText "Visit the page"
                    |> Button.withType (Button.link "https://www.google.com")
                    |> Button.render
                )
            )
            .base
            updateBase
      )
    , ( "Header"
      , statefulComponent
            (Autocomplete.withAddonHeader "Choose a role:")
            .base
            updateBase
      )
    , ( "Suggestion"
      , statefulComponent
            (Autocomplete.withAddonSuggestion { title = "Suggestion", subtitle = Just "Subtitle", icon = IconSet.Search })
            .base
            updateBase
      )
    ]


type alias ConfigMapper =
    Autocomplete.Config Job (Autocomplete.Msg Job) -> Autocomplete.Config Job (Autocomplete.Msg Job)


updateBase : Autocomplete.Msg Job -> Models -> ( Models, Cmd (Autocomplete.Msg Job) )
updateBase msg model =
    let
        ( autocompleteModel, autocompleteCmd ) =
            Autocomplete.update msg model.base

        hasReachedThreshold : String -> Bool
        hasReachedThreshold str =
            String.length str > 3
    in
    ( { model
        | base =
            autocompleteModel
                |> PrimaFunction.ifThenElseMap (Autocomplete.getFilter >> hasReachedThreshold)
                    (Autocomplete.setOptions (RemoteData.Success [ Designer, Developer, ProductManager ]))
                    (Autocomplete.setOptions RemoteData.Loading)
      }
    , autocompleteCmd
    )


updateNoResult : Autocomplete.Msg Job -> Models -> ( Models, Cmd (Autocomplete.Msg Job) )
updateNoResult msg model =
    let
        ( autocompleteModel, autocompleteCmd ) =
            Autocomplete.update msg model.noResult

        hasReachedThreshold : String -> Bool
        hasReachedThreshold str =
            String.length str > 3
    in
    ( { model
        | noResult =
            autocompleteModel
                |> PrimaFunction.ifThenElseMap (Autocomplete.getFilter >> hasReachedThreshold)
                    (Autocomplete.setOptions (RemoteData.Success []))
                    (Autocomplete.setOptions RemoteData.Loading)
      }
    , autocompleteCmd
    )


statefulComponent :
    ConfigMapper
    -> (Models -> Model)
    -> (Autocomplete.Msg Job -> Models -> ( Models, Cmd (Autocomplete.Msg Job) ))
    -> SharedState x
    -> Html (ElmBook.Msg (SharedState x))
statefulComponent mapper modelPicker update sharedState =
    Autocomplete.config
        "autocomplete-config"
        |> mapper
        |> Autocomplete.render identity () (sharedState.autocomplete |> modelPicker)
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
