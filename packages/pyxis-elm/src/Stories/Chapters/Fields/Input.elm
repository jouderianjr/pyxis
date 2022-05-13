module Stories.Chapters.Fields.Input exposing (Model, docs, init)

import Date exposing (Date)
import ElmBook
import ElmBook.Actions
import ElmBook.Chapter
import Html exposing (Html)
import Pyxis.Commons.Properties.Placement as Placement
import Pyxis.Components.Field.Input as Input
import Pyxis.Components.IconSet as IconSet


docs : ElmBook.Chapter.Chapter (SharedState x)
docs =
    "Input"
        |> ElmBook.Chapter.chapter
        |> ElmBook.Chapter.withStatefulComponentList componentsList
        |> ElmBook.Chapter.render """
All the properties described below concern the visual implementation of the component.

<component with-label="Input" />
```
type Msg
    = OnInputFieldMsg Input.Msg


type alias FormData =
    { name : String
    }


validation : FormData -> String -> Result String String
validation _ value =
    if String.isEmpty value then
        Err "Required field"

    else
        Ok value


textFieldModel : Input.Model FormData
textFieldModel =
    Input.init "" validation


textField : FormData -> Html Msg
textField formData =
    Input.text "text-name"
        |> Input.withLabel (Label.config "Name")
        |> Input.render OnInputFieldMsg formData textFieldModel
```

## Types

Input field can have several types such as `text`, `number`, `date`, `password` and `email`.

### Type: Text
<component with-label="Input with type text" />
```
Input.text "input-text-name"
    |> Input.render OnInputFieldMsg formData textFieldModel
```

### Type: Number
<component with-label="Input with type number" />
```
Input.number "input-number-id"
    |> Input.render OnInputFieldMsg formData numberFieldModel
```

### Type: Date
<component with-label="Input with type date" />
```
Input.date "input-date-id"
    |> Input.render OnInputFieldMsg formData dateFieldModel
```

### Type: Password
<component with-label="Input with type password" />
```
Input.password "input-password-id"
    |> Input.render OnInputFieldMsg formData passwordFieldModel
```

### Type: Email
<component with-label="Input with type email" />
```
Input.email "input-email-id"
    |> Input.render OnInputFieldMsg formData emailFieldModel
```


## Addon

Input field can have several addons, such as icons or texts. They are used to make the user understand the purpose of the field better.
**Please Note**: use these addons one at a time.

### Addon: Prepend text
<component with-label="Input withAddon prepend text" />

```
Input.text "text-name"
    |> Input.withAddon Placement.prepend (Input.textAddon "mq")
    |> Input.render OnInputFieldMsg formData textFieldModel
```

### Addon: Append text
<component with-label="Input withAddon append text" />

```
Input.text "text-name"
    |> Input.withAddon Placement.append (Input.textAddon "€")
    |> Input.render OnInputFieldMsg formData textFieldModel
```

### Addon: Prepend Icon
<component with-label="Input withAddon prepend icon" />

```
Input.text "text-name"
    |> Input.withAddon Placement.prepend (Input.iconAddon IconSet.AccessKey)
    |> Input.render OnInputFieldMsg formData textFieldModel
```

### Addon: Append Icon
<component with-label="Input withAddon append icon" />

```
Input.text "text-name"
    |> Input.withAddon Placement.append (Input.iconAddon IconSet.Bell)
    |> Input.render OnInputFieldMsg formData textFieldModel
```

## Size

Sizes set the occupied space of the text-field.
You can set your InputField with a _size_ of default or small.

### Size: Small
<component with-label="Input withSize small" />

```
Input.text "text-name"
    |> Input.withSize Input.small
    |> Input.render OnInputFieldMsg formData textFieldModel
```

## Others

<component with-label="Input withPlaceholder" />
```
Input.text "text-name"
    |> Input.withPlaceholder "Custom placeholder"
    |> Input.render OnInputFieldMsg formData textFieldModel
```

<component with-label="Input withDisabled" />
```
Input.text "text-name"
    |> Input.withDisabled True
    |> Input.render OnInputFieldMsg formData textFieldModel
```

<component with-label="Input date withStep, withMin and withMax" />
```
Input.date "date-id"
    |> Input.withMin "2020-01-01"
    |> Input.withMax "2022-12-31"
    |> Input.withStep "1"
    |> Input.render OnInputFieldMsg formData textFieldModel
```
"""


type alias SharedState x =
    { x | input : Model }


type alias Msg x =
    ElmBook.Msg (SharedState x)


type alias Model =
    { base : Input.Model () String
    , date : Input.Model () Date
    , email : Input.Model () String
    , number : Input.Model () Float
    , password : Input.Model () String
    , text : Input.Model () String
    , withValidation : Input.Model () String
    }


init : Model
init =
    { base = Input.init "" (always Ok)
    , date = Input.init "" (always Date.fromIsoString)
    , email = Input.init "" (always Ok)
    , number = Input.init "" (always (String.toFloat >> Result.fromMaybe "Invalid number"))
    , password = Input.init "" (always Ok)
    , text = Input.init "" (always Ok)
    , withValidation = Input.init "" validation
    }


validation : () -> String -> Result String String
validation _ value =
    if String.isEmpty value then
        Err "Required field"

    else
        Ok value


componentsList : List ( String, SharedState x -> Html (ElmBook.Msg (SharedState x)) )
componentsList =
    [ ( "Input"
      , \sharedState ->
            Input.text "input"
                |> Input.render identity () sharedState.input.withValidation
                |> statefulComponent updateWithValidation
      )
    , ( "Input with type text"
      , \sharedState ->
            Input.text "text"
                |> Input.withPlaceholder "Name"
                |> Input.render identity () sharedState.input.text
                |> statefulComponent updateText
      )
    , ( "Input with type number"
      , \sharedState ->
            Input.number "number"
                |> Input.withPlaceholder "Age"
                |> Input.render identity () sharedState.input.number
                |> statefulComponent updateNumber
      )
    , ( "Input with type date"
      , \sharedState ->
            Input.date "date"
                |> Input.render identity () sharedState.input.date
                |> statefulComponent updateDate
      )
    , ( "Input with type password"
      , \sharedState ->
            Input.password "password"
                |> Input.withPlaceholder "Password"
                |> Input.render identity () sharedState.input.password
                |> statefulComponent updatePassword
      )
    , ( "Input with type email"
      , \sharedState ->
            Input.email "email"
                |> Input.withPlaceholder "Email"
                |> Input.render identity () sharedState.input.email
                |> statefulComponent updateEmail
      )
    , ( "Input withAddon prepend text"
      , \sharedState ->
            Input.text "with-addon-prepend-text"
                |> Input.withAddon Placement.prepend (Input.textAddon "mq")
                |> Input.render identity () sharedState.input.base
                |> statelessComponent
      )
    , ( "Input withAddon append text"
      , \sharedState ->
            Input.text "with-addon-append-text"
                |> Input.withAddon Placement.append (Input.textAddon "€")
                |> Input.render identity () sharedState.input.base
                |> statelessComponent
      )
    , ( "Input withAddon prepend icon"
      , \sharedState ->
            Input.text "with-addon-prepend-icon"
                |> Input.withAddon Placement.prepend (Input.iconAddon IconSet.AccessKey)
                |> Input.render identity () sharedState.input.base
                |> statelessComponent
      )
    , ( "Input withAddon append icon"
      , \sharedState ->
            Input.text "with-addon-append-icon"
                |> Input.withAddon Placement.append (Input.iconAddon IconSet.Bell)
                |> Input.render identity () sharedState.input.base
                |> statelessComponent
      )
    , ( "Input withSize small"
      , \sharedState ->
            Input.text "small"
                |> Input.withSize Input.small
                |> Input.render identity () sharedState.input.base
                |> statelessComponent
      )
    , ( "Input withDisabled"
      , \sharedState ->
            Input.text "disabled"
                |> Input.withDisabled True
                |> Input.render identity () sharedState.input.base
                |> statelessComponent
      )
    , ( "Input withPlaceholder"
      , \sharedState ->
            Input.text "placeholder"
                |> Input.withPlaceholder "Custom placeholder"
                |> Input.render identity () sharedState.input.base
                |> statelessComponent
      )
    , ( "Input date withStep, withMin and withMax"
      , \sharedState ->
            Input.date "date"
                |> Input.withMin "2020-01-01"
                |> Input.withMax "2022-12-31"
                |> Input.withStep "1"
                |> Input.render identity () sharedState.input.base
                |> statelessComponent
      )
    ]


statelessComponent : Html Input.Msg -> Html (Msg x)
statelessComponent =
    Html.map
        (ElmBook.Actions.mapUpdate
            { toState = toState
            , fromState = .input
            , update = updateBase
            }
        )


statefulComponent :
    (Input.Msg -> Model -> Model)
    -> Html Input.Msg
    -> Html (Msg x)
statefulComponent update =
    Html.map
        (ElmBook.Actions.mapUpdate
            { toState = toState
            , fromState = .input
            , update = update
            }
        )


toState : SharedState x -> Model -> SharedState x
toState state model =
    { state | input = model }


updateBase : Input.Msg -> Model -> Model
updateBase msg model =
    { model | base = Input.update msg model.base }


updateText : Input.Msg -> Model -> Model
updateText msg model =
    { model | text = Input.update msg model.text }


updateNumber : Input.Msg -> Model -> Model
updateNumber msg model =
    { model | number = Input.update msg model.number }


updateEmail : Input.Msg -> Model -> Model
updateEmail msg model =
    { model | email = Input.update msg model.email }


updatePassword : Input.Msg -> Model -> Model
updatePassword msg model =
    { model | password = Input.update msg model.password }


updateDate : Input.Msg -> Model -> Model
updateDate msg model =
    { model | date = Input.update msg model.date }


updateWithValidation : Input.Msg -> Model -> Model
updateWithValidation msg model =
    { model | withValidation = Input.update msg model.withValidation }
