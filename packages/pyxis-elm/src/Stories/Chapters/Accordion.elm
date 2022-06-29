module Stories.Chapters.Accordion exposing (Models, docs, init)

import ElmBook
import ElmBook.Actions
import ElmBook.Chapter
import Html exposing (Html)
import Pyxis.Commons.Properties.Theme as Theme
import Pyxis.Components.Accordion as Accordion
import Pyxis.Components.Accordion.Item as AccordionItem
import Pyxis.Components.IconSet as IconSet


docs : ElmBook.Chapter.Chapter (SharedState x)
docs =
    "Accordion"
        |> ElmBook.Chapter.chapter
        |> ElmBook.Chapter.withStatefulComponentList componentsList
        |> ElmBook.Chapter.render """

An accordion is a vertically stacked list of headers that reveal or hide associated sections of content.

<component with-label="Accordion" />

```
{-| Define your application message.
-}
type Msg =
    AccordionChanged Accordion.Msg


{-| Define your model.
-}
type alias Model =
    { accordion : Accordion.Model
    }


initialModel : Model
initialModel =
    { accordion = Accordion.init (Accordion.singleOpening Nothing)
    }

{-| Define your update.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AccordionChanged subMsg ->
            let
                ( accordionModel, accordionCmd ) =
                    Accordion.update subMsg model.accordion
            in
            ( { model | accordion = accordionModel }
            , Cmd.map Model.AccordionChanged accordionCmd
            )


{-| Define your view.
-}
accordion : Html msg
accordion =
    Accordion.config accordionItems
        |> Accordion.render Model.AccordionChanged model.accordion


accordionItems : List (AccordionItem.Config msg)
accordionItems =
    [ AccordionItem.config "id-one"
        |> AccordionItem.withTitle "Title one"
        |> AccordionItem.withContent
            [ Html.div
                []
                [ Html.text "Lorem ipsum." ]
            ]
    , AccordionItem.config "id-two"
        |> AccordionItem.withTitle "Title two"
        |> AccordionItem.withContent
            [ Html.div
                []
                [ Html.text "Lorem ipsum." ]
            ]
    ]
```

## Opening Type
The accordion component has two different ways of managing the opening of its items.

### Single
The `single` type allows you to open only one item at a time.

<component with-label="Accordion" />
```
initialModel : Model
initialModel =
    { accordion = Accordion.init (Accordion.singleOpening Nothing)
    }
```

You can also open an item by passing its id.
<component with-label="Single Open" />
```
initialModel : Model
initialModel =
    { accordion = Accordion.init (Accordion.singleOpening (Just "first-id"))
    }
```

### Multiple
The `multiple` type allows you to open multiple items at the same time.

<component with-label="Multiple" />
```
initialModel : Model
initialModel =
    { accordion = Accordion.init (Accordion.multipleOpening [])
    }
```

You can also open one or more items, passing their ids.
<component with-label="Multiple Open" />
```
initialModel : Model
initialModel =
    { accordion = Accordion.init (Accordion.multipleOpening ["first-id", "second-id"])
    }
```

## Variant
The variants allow you to change the color scheme of the accordion.

### Light
<component with-label="Light" with-background="#F3F4F4" />
```
accordion : Html msg
accordion =
    Accordion.config accordionItems
        |> Accordion.withLightVariant
        |> Accordion.render Model.AccordionChanged model.accordion
```

## Theme
You can set your Accordion with a default _theme_ or alternative. Alt theme is mandatory in case of a dark background.

### Alternative
<component with-label="Alternative" with-background="#21283B" />
```
accordion : Html msg
accordion =
    Accordion.config accordionItems
        |> Accordion.withTheme Theme.alternative
        |> Accordion.render Model.AccordionChanged model.accordion
```

## Accordion Item
The accordion item must necessarily have a title and a content, but it also allows you to insert some more content.


### Subtitle
The accordion item header can also have an explanatory subtitle.

<component with-label="Subtitle" />
```
accordionItems : List (AccordionItem.Config msg)
accordionItems =
    [ AccordionItem.config "id"
        |> AccordionItem.withTitle "Title one"
        |> AccordionItem.withSubtitle "Subtitle"
        |> AccordionItem.withContent
        [ Html.div
            []
            [ Html.text "Lorem ipsum." ]
        ]
    ]
```

### Action Text
The accordion item header may also have an action text next to the arrow to help understand that the component is "openable" and "closable".

<component with-label="Action Text" />
```
itemActionText : AccordionItem.ActionText
itemActionText =
    { open = "Show more"
    , close = "Show less"
    }

accordionItems : List (AccordionItem.Config msg)
accordionItems =
    [ AccordionItem.config "id"
        |> AccordionItem.withTitle "Title one"
        |> AccordionItem.withActionText itemActionText
        |> AccordionItem.withContent
            [ Html.div
                []
                [ Html.text "Lorem ipsum." ]
            ]
    ]
```

### Addons
The accordion item header can also have two types of addons, an image and an icon.

__Please note:__ this is just an example, within an accordion use only one type of addon at a time.

<component with-label="Addons" />
```
accordionItems : List (AccordionItem.Config msg)
accordionItems =
    [ AccordionItem.config "id-one"
        |> AccordionItem.withTitle "Title one"
        |> AccordionItem.withIcon IconSet.Car
        |> AccordionItem.withContent
            [ Html.div
                []
                [ Html.text "Lorem ipsum." ]
            ]
    , AccordionItem.config "id-two"
        |> AccordionItem.withTitle "Title two"
        |> AccordionItem.withImage "../../../assets/placeholder.svg"
        |> AccordionItem.withContent
            [ Html.div
                []
                [ Html.text "Lorem ipsum." ]
            ]

    ]
```

"""


type alias SharedState x =
    { x | accordion : Models }


type alias Models =
    { base : Accordion.Model
    , singleOpen : Accordion.Model
    , multiple : Accordion.Model
    , multipleOpen : Accordion.Model
    , light : Accordion.Model
    , alternative : Accordion.Model
    , subtitle : Accordion.Model
    , actionText : Accordion.Model
    , addons : Accordion.Model
    }


init : Models
init =
    { base = Accordion.init (Accordion.singleOpening Nothing)
    , singleOpen = Accordion.init (Accordion.singleOpening (Just "single-open-1"))
    , multiple = Accordion.init (Accordion.multipleOpening [])
    , multipleOpen = Accordion.init (Accordion.multipleOpening [ "multiple-open-1", "multiple-open-2" ])
    , light = Accordion.init (Accordion.singleOpening Nothing)
    , alternative = Accordion.init (Accordion.singleOpening Nothing)
    , subtitle = Accordion.init (Accordion.singleOpening Nothing)
    , actionText = Accordion.init (Accordion.singleOpening Nothing)
    , addons = Accordion.init (Accordion.singleOpening Nothing)
    }


componentsList : List ( String, SharedState x -> Html (ElmBook.Msg (SharedState x)) )
componentsList =
    [ ( "Accordion"
      , statefulComponent "default" (accordionItems "default") identity .base updateBase
      )
    , ( "Single Open"
      , statefulComponent "single-open" (accordionItems "single-open") identity .singleOpen updateSingleOpen
      )
    , ( "Multiple"
      , statefulComponent "multiple" (accordionItems "multiple") identity .multiple updateMultiple
      )
    , ( "Multiple Open"
      , statefulComponent "multiple-open" (accordionItems "multiple-open") identity .multipleOpen updateMultipleOpen
      )
    , ( "Light"
      , statefulComponent "light" (accordionItems "light") (Accordion.withVariant Accordion.light) .light updateLight
      )
    , ( "Alternative"
      , statefulComponent "alternative" (accordionItems "alternative") (Accordion.withTheme Theme.alternative) .alternative updateAlternative
      )
    , ( "Subtitle"
      , statefulComponent "subtitle" (accordionItemWithSubtitle "subtitle") identity .subtitle updateSubtitle
      )
    , ( "Action Text"
      , statefulComponent "action-text" (accordionItemWithActionText "action text") identity .actionText updateActionText
      )
    , ( "Addons"
      , statefulComponent "addons" (accordionItemWithAddons "addons") identity .addons updateAddons
      )
    ]


statefulComponent :
    String
    -> List (AccordionItem.Config msg)
    -> (Accordion.Config msg -> Accordion.Config Accordion.Msg)
    -> (Models -> Accordion.Model)
    -> (Accordion.Msg -> Models -> ( Models, Cmd Accordion.Msg ))
    -> SharedState x
    -> Html (ElmBook.Msg (SharedState x))
statefulComponent id items configModifier modelPicker update sharedState =
    Accordion.config id
        |> Accordion.withItems items
        |> configModifier
        |> Accordion.render identity (sharedState.accordion |> modelPicker)
        |> Html.map
            (ElmBook.Actions.mapUpdateWithCmd
                { toState = \state model -> { state | accordion = model }
                , fromState = .accordion
                , update = update
                }
            )


updateBase : Accordion.Msg -> Models -> ( Models, Cmd Accordion.Msg )
updateBase msg models =
    let
        ( accordionModel, accordionCmd ) =
            Accordion.update msg models.base
    in
    ( { models | base = accordionModel }
    , accordionCmd
    )


updateSingleOpen : Accordion.Msg -> Models -> ( Models, Cmd Accordion.Msg )
updateSingleOpen msg models =
    let
        ( accordionModel, accordionCmd ) =
            Accordion.update msg models.singleOpen
    in
    ( { models | singleOpen = accordionModel }
    , accordionCmd
    )


updateMultiple : Accordion.Msg -> Models -> ( Models, Cmd Accordion.Msg )
updateMultiple msg models =
    let
        ( accordionModel, accordionCmd ) =
            Accordion.update msg models.multiple
    in
    ( { models | multiple = accordionModel }
    , accordionCmd
    )


updateMultipleOpen : Accordion.Msg -> Models -> ( Models, Cmd Accordion.Msg )
updateMultipleOpen msg models =
    let
        ( accordionModel, accordionCmd ) =
            Accordion.update msg models.multipleOpen
    in
    ( { models | multipleOpen = accordionModel }
    , accordionCmd
    )


updateLight : Accordion.Msg -> Models -> ( Models, Cmd Accordion.Msg )
updateLight msg models =
    let
        ( accordionModel, accordionCmd ) =
            Accordion.update msg models.light
    in
    ( { models | light = accordionModel }
    , accordionCmd
    )


updateAlternative : Accordion.Msg -> Models -> ( Models, Cmd Accordion.Msg )
updateAlternative msg models =
    let
        ( accordionModel, accordionCmd ) =
            Accordion.update msg models.alternative
    in
    ( { models | alternative = accordionModel }
    , accordionCmd
    )


updateSubtitle : Accordion.Msg -> Models -> ( Models, Cmd Accordion.Msg )
updateSubtitle msg models =
    let
        ( accordionModel, accordionCmd ) =
            Accordion.update msg models.subtitle
    in
    ( { models | subtitle = accordionModel }
    , accordionCmd
    )


updateActionText : Accordion.Msg -> Models -> ( Models, Cmd Accordion.Msg )
updateActionText msg models =
    let
        ( accordionModel, accordionCmd ) =
            Accordion.update msg models.actionText
    in
    ( { models | actionText = accordionModel }
    , accordionCmd
    )


updateAddons : Accordion.Msg -> Models -> ( Models, Cmd Accordion.Msg )
updateAddons msg models =
    let
        ( accordionModel, accordionCmd ) =
            Accordion.update msg models.addons
    in
    ( { models | addons = accordionModel }
    , accordionCmd
    )


accordionItems : String -> List (AccordionItem.Config msg)
accordionItems id =
    [ AccordionItem.config (id ++ "-1")
        |> AccordionItem.withTitle "Title one"
        |> AccordionItem.withContent
            [ Html.div
                []
                [ Html.text "Lorem ipsum." ]
            ]
    , AccordionItem.config (id ++ "-2")
        |> AccordionItem.withTitle "Title two"
        |> AccordionItem.withContent
            [ Html.div
                []
                [ Html.text "Lorem ipsum." ]
            ]
    ]


accordionItemWithSubtitle : String -> List (AccordionItem.Config msg)
accordionItemWithSubtitle id =
    [ AccordionItem.config id
        |> AccordionItem.withTitle "Title one"
        |> AccordionItem.withSubtitle "Subtitle"
        |> AccordionItem.withContent
            [ Html.div
                []
                [ Html.text "Lorem ipsum." ]
            ]
    ]


accordionItemWithActionText : String -> List (AccordionItem.Config msg)
accordionItemWithActionText id =
    [ AccordionItem.config id
        |> AccordionItem.withTitle "Title one"
        |> AccordionItem.withActionText itemActionText
        |> AccordionItem.withContent
            [ Html.div
                []
                [ Html.text "Lorem ipsum." ]
            ]
    ]


accordionItemWithAddons : String -> List (AccordionItem.Config msg)
accordionItemWithAddons id =
    [ AccordionItem.config (id ++ "-1")
        |> AccordionItem.withTitle "Title one"
        |> AccordionItem.withIcon IconSet.Car
        |> AccordionItem.withContent
            [ Html.div
                []
                [ Html.text "Lorem ipsum." ]
            ]
    , AccordionItem.config (id ++ "-2")
        |> AccordionItem.withTitle "Title two"
        |> AccordionItem.withImage "../../../assets/placeholder.svg"
        |> AccordionItem.withContent
            [ Html.div
                []
                [ Html.text "Lorem ipsum." ]
            ]
    ]


itemActionText : AccordionItem.ActionText
itemActionText =
    { open = "Show more"
    , close = "Show less"
    }
