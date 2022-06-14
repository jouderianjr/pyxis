module Stories.Chapters.Fields.CheckboxCardGroup exposing (Model, docs, init)

import ElmBook
import ElmBook.Actions
import ElmBook.Chapter
import Html exposing (Html)
import Pyxis.Components.Field.CheckboxCardGroup as CheckboxCardGroup
import Pyxis.Components.Field.Label as Label
import Pyxis.Components.IconSet as IconSet


docs : ElmBook.Chapter.Chapter (SharedState x)
docs =
    "CheckboxCardGroup"
        |> ElmBook.Chapter.chapter
        |> ElmBook.Chapter.withStatefulComponentList componentsList
        |> ElmBook.Chapter.render """
Checkbox Card lets the user make zero or multiple selection from a list of options.
In comparison to a normal checkbox, it's more graphical and appealing, as it can display an image or an icon and also has a slot for a more descriptive label.
As normal checkbox, checkbox cards can be combined together in groups too, in order to have a clean user experience.

<component with-label="CheckboxCardGroup" />
```
type Option
    = Home
    | Motor


type Msg
    = OnCheckboxFieldMsg (CheckboxCardGroup.Msg Option)

validation : () -> Maybe Option -> Result String Option
validation _ value =
    value
        |> Maybe.map (Ok)
        |> Maybe.withDefault (Err "Invalid selection")

checkboxCardGroupModel : Model () Option Option (CheckboxCardGroup.Msg Option)
checkboxCardGroupModel =
    CheckboxCardGroup.init [] validation


checkboxCardGroupView : () -> Html Msg
checkboxCardGroupView formData =
    CheckboxCardGroup.config "checkboxCard-name"
        |> CheckboxCardGroup.withLabel (Label.config "Choose the area")
        |> CheckboxCardGroup.withName "area"
        |> CheckboxCardGroup.withOptions
            [ CheckboxCardGroup.option
                { value = M
                , title = Just "Motor"
                , text = Just "Lorem ipsum dolor"
                , addon = Nothing
                }
            , CheckboxCardGroup.option
                { value = F
                , title = Just "Home"
                , text = Just "Lorem ipsum dolor"
                , addon = Nothing
                }
            ]
        |> CheckboxCardGroup.render OnCheckboxFieldMsg formData checkboxCardGroupModel
```
## Vertical
<component with-label="CheckboxCardGroup vertical" />
```
CheckboxGroup.config "checkboxgroup-name"
    |> CheckboxCardGroup.withLayout CheckboxCardGroup.vertical
    |> CheckboxCardGroup.render OnCheckboxFieldMsg formData checkboxCardModel
```
## Large Size
Please note that with large layout you need to configure an image addon.
<component with-label="CheckboxCardGroup large" />
```
optionsWithImage : List (CheckboxCardGroup.Option Option)
optionsWithImage =
    [ CheckboxCardGroup.option
        { value = M
        , title = Just "Motor"
        , text = Just "Lorem ipsum dolor"
        , addon = CheckboxCardGroup.imgAddon "../assets/placeholder.svg"
        }
    , CheckboxCardGroup.option
        { value = F
        , title = Just "Home"
        , text = Just "Lorem ipsum dolor"
        , addon = CheckboxCardGroup.imgAddon "../assets/placeholder.svg"
        }
    ]

CheckboxGroup.config "checkbox-id"
    |> CheckboxCardGroup.withSize CheckboxCardGroup.large
    |> CheckboxCardGroup.withOptions optionsWithImage
    |> CheckboxCardGroup.render OnCheckboxFieldMsg formData checkboxCardModel
```
## Icon addon
<component with-label="CheckboxCardGroup with icon" />
```
optionsWithIcon : List (CheckboxCardGroup.Option Option)
optionsWithIcon =
    [ CheckboxCardGroup.option
        { value = M
        , title = Just "Motor"
        , text = Just "Lorem ipsum dolor"
        , addon = CheckboxCardGroup.iconAddon IconSet.Car
        }
    , CheckboxCardGroup.option
        { value = F
        , title = Just "Home"
        , text = Just "Lorem ipsum dolor"
        , addon = CheckboxCardGroup.iconAddon IconSet.Home
        }
    ]

CheckboxGroup.config "checkboxgroup-name"
    |> CheckboxCardGroup.withOptions optionsWithIcon
    |> CheckboxCardGroup.render OnCheckboxFieldMsg formData checkboxCardModel
```
## Text addon
<component with-label="CheckboxCardGroup with text" />
```
optionsWithTextAddon : List (CheckboxCardGroup.Option Option)
optionsWithTextAddon =
    [ CheckboxCardGroup.option
        { value = M
        , title = Just "Motor"
        , text = Just "Lorem ipsum dolor"
        , addon = CheckboxCardGroup.textAddon "€ 800,00"
        }
    , CheckboxCardGroup.option
        { value = F
        , title = Just "Home"
        , text = Just "Lorem ipsum dolor"
        , addon = CheckboxCardGroup.textAddon "€ 1.000,00"
        }
    ]

CheckboxGroup.config "checkboxgroup-name"
    |> CheckboxCardGroup.withOptions optionsWithTextAddon
    |> CheckboxCardGroup.render OnCheckboxFieldMsg formData checkboxCardModel
```
"""


type alias SharedState x =
    { x | checkboxCard : Model }


type alias Msg x =
    ElmBook.Msg (SharedState x)


type Product
    = Motor
    | Household


type alias Model =
    { base : CheckboxCardGroup.Model () Product (NonemptyList Product) (CheckboxCardGroup.Msg Product)
    , vertical : CheckboxCardGroup.Model () Product (List Product) (CheckboxCardGroup.Msg Product)
    , disabled : CheckboxCardGroup.Model () Product (List Product) (CheckboxCardGroup.Msg Product)
    , large : CheckboxCardGroup.Model () Product (List Product) (CheckboxCardGroup.Msg Product)
    , icon : CheckboxCardGroup.Model () Product (List Product) (CheckboxCardGroup.Msg Product)
    , text : CheckboxCardGroup.Model () Product (List Product) (CheckboxCardGroup.Msg Product)
    }


init : Model
init =
    { base =
        CheckboxCardGroup.init [] validationRequired
    , vertical =
        CheckboxCardGroup.init [] (always Ok)
    , disabled =
        CheckboxCardGroup.init [] (always Ok)
    , large =
        CheckboxCardGroup.init [] (always Ok)
    , icon =
        CheckboxCardGroup.init [] (always Ok)
    , text =
        CheckboxCardGroup.init [] (always Ok)
    }


type alias NonemptyList a =
    ( a, List a )


validationRequired : () -> List Product -> Result String (NonemptyList Product)
validationRequired () langs =
    case langs of
        [] ->
            Err "You must select at least one option"

        hd :: tl ->
            Ok ( hd, tl )


optionsWithImage : List (CheckboxCardGroup.Option Product)
optionsWithImage =
    [ CheckboxCardGroup.option
        { value = Motor
        , title = Just "Motor"
        , text = Just "Lorem ipsum dolor"
        , addon = CheckboxCardGroup.imgAddon "../assets/placeholder.svg"
        }
    , CheckboxCardGroup.option
        { value = Household
        , title = Just "Home"
        , text = Just "Lorem ipsum dolor"
        , addon = CheckboxCardGroup.imgAddon "../assets/placeholder.svg"
        }
    ]


optionsWithIcon : List (CheckboxCardGroup.Option Product)
optionsWithIcon =
    [ CheckboxCardGroup.option
        { value = Motor
        , title = Just "Motor"
        , text = Just "Lorem ipsum dolor"
        , addon = CheckboxCardGroup.iconAddon IconSet.Car
        }
    , CheckboxCardGroup.option
        { value = Household
        , title = Just "Home"
        , text = Just "Lorem ipsum dolor"
        , addon = CheckboxCardGroup.iconAddon IconSet.Home
        }
    ]


optionsWithTextAddon : List (CheckboxCardGroup.Option Product)
optionsWithTextAddon =
    [ CheckboxCardGroup.option
        { value = Motor
        , title = Just "Motor"
        , text = Just "Lorem ipsum dolor"
        , addon = CheckboxCardGroup.textAddon "€ 800,00"
        }
    , CheckboxCardGroup.option
        { value = Household
        , title = Just "Home"
        , text = Just "Lorem ipsum dolor"
        , addon = CheckboxCardGroup.textAddon "€ 1.000,00"
        }
    ]


type alias StatefulConfig parsed =
    { name : String
    , configModifier : CheckboxCardGroup.Config Product -> CheckboxCardGroup.Config Product
    , modelPicker : Model -> CheckboxCardGroup.Model () Product parsed (CheckboxCardGroup.Msg Product)
    , update : CheckboxCardGroup.Msg Product -> Model -> ( Model, Cmd (CheckboxCardGroup.Msg Product) )
    }


statefulComponent : StatefulConfig parsed -> SharedState x -> Html (Msg x)
statefulComponent { name, configModifier, modelPicker, update } sharedState =
    CheckboxCardGroup.config name
        |> CheckboxCardGroup.withOptions
            [ CheckboxCardGroup.option
                { value = Motor
                , title = Just "Motor"
                , text = Just "Lorem ipsum dolor"
                , addon = Nothing
                }
            , CheckboxCardGroup.option
                { value = Household
                , title = Just "Home"
                , text = Just "Lorem ipsum dolor"
                , addon = Nothing
                }
            ]
        |> configModifier
        |> CheckboxCardGroup.render identity () (sharedState.checkboxCard |> modelPicker)
        |> Html.map
            (ElmBook.Actions.mapUpdateWithCmd
                { toState = \sharedState_ models -> { sharedState_ | checkboxCard = models }
                , fromState = .checkboxCard
                , update = update
                }
            )


componentsList : List ( String, SharedState x -> Html (Msg x) )
componentsList =
    [ ( "CheckboxCardGroup"
      , statefulComponent
            { name = "base"
            , configModifier = CheckboxCardGroup.withLabel (Label.config "Choose the area")
            , modelPicker = .base
            , update =
                \msg models ->
                    ( { models | base = Tuple.first (CheckboxCardGroup.update msg models.base) }
                    , Tuple.second (CheckboxCardGroup.update msg models.base)
                    )
            }
      )
    , ( "CheckboxCardGroup vertical"
      , statefulComponent
            { name = "vertical"
            , configModifier = CheckboxCardGroup.withLayout CheckboxCardGroup.vertical
            , modelPicker = .vertical
            , update =
                \msg models ->
                    ( { models | vertical = Tuple.first (CheckboxCardGroup.update msg models.vertical) }
                    , Tuple.second (CheckboxCardGroup.update msg models.vertical)
                    )
            }
      )
    , ( "CheckboxCardGroup large"
      , statefulComponent
            { name = "large"
            , configModifier = CheckboxCardGroup.withSize CheckboxCardGroup.large >> CheckboxCardGroup.withOptions optionsWithImage
            , modelPicker = .large
            , update =
                \msg models ->
                    ( { models | large = Tuple.first (CheckboxCardGroup.update msg models.large) }
                    , Tuple.second (CheckboxCardGroup.update msg models.large)
                    )
            }
      )
    , ( "CheckboxCardGroup with icon"
      , statefulComponent
            { name = "icon"
            , configModifier = CheckboxCardGroup.withOptions optionsWithIcon
            , modelPicker = .icon
            , update =
                \msg models ->
                    ( { models | icon = Tuple.first (CheckboxCardGroup.update msg models.icon) }
                    , Tuple.second (CheckboxCardGroup.update msg models.icon)
                    )
            }
      )
    , ( "CheckboxCardGroup with text"
      , statefulComponent
            { name = "with-text"
            , configModifier = CheckboxCardGroup.withOptions optionsWithTextAddon
            , modelPicker = .text
            , update =
                \msg models ->
                    ( { models | text = Tuple.first (CheckboxCardGroup.update msg models.text) }
                    , Tuple.second (CheckboxCardGroup.update msg models.text)
                    )
            }
      )
    ]
