module Stories.Chapters.Fields.Input exposing (Model, docs, init)

import Date exposing (Date)
import ElmBook
import ElmBook.Actions
import ElmBook.Chapter
import Html exposing (Html)
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


validation : String -> Result String String
validation value =
    if String.isEmpty value then
        Err "Required field"

    else
        Ok value


textFieldModel : Input.Model Msg
textFieldModel =
    Input.init 


textField : Bool -> Html Msg
textField isSubmitted =
    Input.text "text-name"
        |> Input.withLabel (Label.config "Name")
        |> Input.withValidationOnBlur validation isSubmitted
        |> Input.render OnInputFieldMsg textFieldModel
```

## Types

Input field can have several types such as `text`, `number`, `date`, `password` and `email`.

### Type: Text
<component with-label="Input with type text" />
```
Input.text "input-text-name"
    |> Input.render OnInputFieldMsg textFieldModel
```

### Type: Number
<component with-label="Input with type number" />
```
Input.number "input-number-id"
    |> Input.render OnInputFieldMsg numberFieldModel
```

### Type: Date
<component with-label="Input with type date" />
```
Input.date "input-date-id"
    |> Input.render OnInputFieldMsg dateFieldModel
```

### Type: Password
<component with-label="Input with type password" />
```
Input.password "input-password-id"
    |> Input.render OnInputFieldMsg passwordFieldModel
```

### Type: Email
<component with-label="Input with type email" />
```
Input.email "input-email-id"
    |> Input.render OnInputFieldMsg emailFieldModel
```


## Addon

Input field can have several addons, such as icons or texts. They are used to make the user understand the purpose of the field better.
**Please Note**: use these addons one at a time.

### Addon: Prepend text
<component with-label="Input withAddon prepend text" />

```
Input.text "text-name"
    |> Input.withTextPrepend "mq"
    |> Input.render OnInputFieldMsg textFieldModel
```

### Addon: Append text
<component with-label="Input withAddon append text" />

```
Input.text "text-name"
    |> Input.withTextAppend "€"
    |> Input.render OnInputFieldMsg textFieldModel
```

### Addon: Prepend Icon
<component with-label="Input withAddon prepend icon" />

```
Input.text "text-name"
    |> Input.withIconPrepend IconSet.AccessKey
    |> Input.render OnInputFieldMsg textFieldModel
```

### Addon: Append Icon
<component with-label="Input withAddon append icon" />

```
Input.text "text-name"
    |> Input.withIconAppend IconSet.Bell
    |> Input.render OnInputFieldMsg textFieldModel
```

## Size

Sizes set the occupied space of the text-field.
You can set your InputField with a _size_ of default or small.

### Size: Small
<component with-label="Input withSize small" />

```
Input.text "text-name"
    |> Input.withSize Input.small
    |> Input.render OnInputFieldMsg textFieldModel
```

## Others

<component with-label="Input withPlaceholder" />
```
Input.text "text-name"
    |> Input.withPlaceholder "Custom placeholder"
    |> Input.render OnInputFieldMsg textFieldModel
```

<component with-label="Input withDisabled" />
```
Input.text "text-name"
    |> Input.withDisabled True
    |> Input.render OnInputFieldMsg textFieldModel
```


<component with-label="Input withAdditionalContent" />
```
Input.text "text-name"
    |> Input.withAdditionalContent (Html.text "Additional Content")
    |> Input.render OnInputFieldMsg textFieldModel
```

<component with-label="Input date withStep, withMin and withMax" />
```
Input.date "date-id"
    |> Input.withMin "2020-01-01"
    |> Input.withMax "2022-12-31"
    |> Input.withStep "1"
    |> Input.render OnInputFieldMsg textFieldModel
```
"""


type alias SharedState x =
    { x | input : Model }


type alias Msg x =
    ElmBook.Msg (SharedState x)


type alias Model =
    { base : Input.Model Input.Msg
    , date : Input.Model Input.Msg
    , email : Input.Model Input.Msg
    , number : Input.Model Input.Msg
    , password : Input.Model Input.Msg
    , text : Input.Model Input.Msg
    , withValidation : Input.Model Input.Msg
    , additionalContent : Input.Model Input.Msg
    }


init : Model
init =
    { base = Input.init
    , date = Input.init
    , email = Input.init
    , number = Input.init
    , password = Input.init
    , text = Input.init
    , additionalContent = Input.init
    , withValidation = Input.init
    }


floatValidation : String -> Result String Float
floatValidation =
    String.toFloat >> Result.fromMaybe "Invalid number"


dateValidation : String -> Result String Date
dateValidation =
    Date.fromIsoString


validation : String -> Result String String
validation value =
    if String.isEmpty value then
        Err "Required field"

    else
        Ok value


componentsList : List ( String, SharedState x -> Html (ElmBook.Msg (SharedState x)) )
componentsList =
    [ ( "Input"
      , \sharedState ->
            Input.text "input"
                |> Input.withValidationOnBlur validation False
                |> Input.render identity sharedState.input.withValidation
                |> statefulComponent updateWithValidation
      )
    , ( "Input with type text"
      , \sharedState ->
            Input.text "text"
                |> Input.withPlaceholder "Name"
                |> Input.render identity sharedState.input.text
                |> statefulComponent updateText
      )
    , ( "Input with type number"
      , \sharedState ->
            Input.number "number"
                |> Input.withPlaceholder "Age"
                |> Input.withValidationOnBlur floatValidation False
                |> Input.render identity sharedState.input.number
                |> statefulComponent updateNumber
      )
    , ( "Input with type date"
      , \sharedState ->
            Input.date "date"
                |> Input.withValidationOnBlur dateValidation False
                |> Input.render identity sharedState.input.date
                |> statefulComponent updateDate
      )
    , ( "Input with type password"
      , \sharedState ->
            Input.password "password"
                |> Input.withPlaceholder "Password"
                |> Input.render identity sharedState.input.password
                |> statefulComponent updatePassword
      )
    , ( "Input with type email"
      , \sharedState ->
            Input.email "email"
                |> Input.withPlaceholder "Email"
                |> Input.render identity sharedState.input.email
                |> statefulComponent updateEmail
      )
    , ( "Input withAddon prepend text"
      , \sharedState ->
            Input.text "with-addon-prepend-text"
                |> Input.withTextPrepend "mq"
                |> Input.render identity sharedState.input.base
                |> statelessComponent
      )
    , ( "Input withAddon append text"
      , \sharedState ->
            Input.text "with-addon-append-text"
                |> Input.withTextAppend "€"
                |> Input.render identity sharedState.input.base
                |> statelessComponent
      )
    , ( "Input withAddon prepend icon"
      , \sharedState ->
            Input.text "with-addon-prepend-icon"
                |> Input.withIconPrepend IconSet.AccessKey
                |> Input.render identity sharedState.input.base
                |> statelessComponent
      )
    , ( "Input withAddon append icon"
      , \sharedState ->
            Input.text "with-addon-append-icon"
                |> Input.withIconAppend IconSet.Bell
                |> Input.render identity sharedState.input.base
                |> statelessComponent
      )
    , ( "Input withSize small"
      , \sharedState ->
            Input.text "small"
                |> Input.withSize Input.small
                |> Input.render identity sharedState.input.base
                |> statelessComponent
      )
    , ( "Input withDisabled"
      , \sharedState ->
            Input.text "disabled"
                |> Input.withDisabled True
                |> Input.render identity sharedState.input.base
                |> statelessComponent
      )
    , ( "Input withPlaceholder"
      , \sharedState ->
            Input.text "placeholder"
                |> Input.withPlaceholder "Custom placeholder"
                |> Input.render identity sharedState.input.base
                |> statelessComponent
      )
    , ( "Input withAdditionalContent"
      , \sharedState ->
            Input.text "additional-content"
                |> Input.withAdditionalContent (Html.text "Additional Content")
                |> Input.render identity sharedState.input.base
                |> statelessComponent
      )
    , ( "Input date withStep, withMin and withMax"
      , \sharedState ->
            Input.date "date"
                |> Input.withMin "2020-01-01"
                |> Input.withMax "2022-12-31"
                |> Input.withStep "1"
                |> Input.render identity sharedState.input.base
                |> statelessComponent
      )
    ]


statelessComponent : Html Input.Msg -> Html (Msg x)
statelessComponent =
    Html.map
        (ElmBook.Actions.mapUpdateWithCmd
            { toState = toState
            , fromState = .input
            , update = updateBase
            }
        )


statefulComponent :
    (Input.Msg -> Model -> ( Model, Cmd Input.Msg ))
    -> Html Input.Msg
    -> Html (Msg x)
statefulComponent update =
    Html.map
        (ElmBook.Actions.mapUpdateWithCmd
            { toState = toState
            , fromState = .input
            , update = update
            }
        )


toState : SharedState x -> Model -> SharedState x
toState state model =
    { state | input = model }


updateBase : Input.Msg -> Model -> ( Model, Cmd Input.Msg )
updateBase msg model =
    let
        ( updatedModel, cmd ) =
            Input.update msg model.base
    in
    ( { model | base = updatedModel }, cmd )


updateText : Input.Msg -> Model -> ( Model, Cmd Input.Msg )
updateText msg model =
    let
        ( updatedModel, cmd ) =
            Input.update msg model.text
    in
    ( { model | text = updatedModel }, cmd )


updateNumber : Input.Msg -> Model -> ( Model, Cmd Input.Msg )
updateNumber msg model =
    let
        ( updatedModel, cmd ) =
            Input.update msg model.number
    in
    ( { model | number = updatedModel }, cmd )


updateEmail : Input.Msg -> Model -> ( Model, Cmd Input.Msg )
updateEmail msg model =
    let
        ( updatedModel, cmd ) =
            Input.update msg model.email
    in
    ( { model | email = updatedModel }, cmd )


updatePassword : Input.Msg -> Model -> ( Model, Cmd Input.Msg )
updatePassword msg model =
    let
        ( updatedModel, cmd ) =
            Input.update msg model.password
    in
    ( { model | password = updatedModel }, cmd )


updateDate : Input.Msg -> Model -> ( Model, Cmd Input.Msg )
updateDate msg model =
    let
        ( updatedModel, cmd ) =
            Input.update msg model.date
    in
    ( { model | date = updatedModel }, cmd )


updateWithValidation : Input.Msg -> Model -> ( Model, Cmd Input.Msg )
updateWithValidation msg model =
    let
        ( updatedModel, cmd ) =
            Input.update msg model.withValidation
    in
    ( { model | withValidation = updatedModel }, cmd )
