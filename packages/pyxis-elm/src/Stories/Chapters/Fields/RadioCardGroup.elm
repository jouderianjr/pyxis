module Stories.Chapters.Fields.RadioCardGroup exposing (Model, docs, init)

import ElmBook
import ElmBook.Actions
import ElmBook.Chapter
import Html exposing (Html)
import Pyxis.Components.Field.Label as Label
import Pyxis.Components.Field.RadioCardGroup as RadioCardGroup
import Pyxis.Components.IconSet as IconSet


docs : ElmBook.Chapter.Chapter (SharedState x)
docs =
    "RadioCardGroup"
        |> ElmBook.Chapter.chapter
        |> ElmBook.Chapter.withStatefulComponentList componentsList
        |> ElmBook.Chapter.render """
<component with-label="RadioCardGroup" />
```
type Option
    = Home
    | Motor


type Msg
    = OnRadioCardFieldMsg (RadioCardGroup.Msg Option)

validation : () -> Maybe Option -> Result String Option
validation _ value =
    value
        |> Maybe.map (Ok)
        |> Maybe.withDefault (Err "Invalid selection")

radioCardGroupModel : RadioCardGroup.Model () Option Option (RadioCardGroup.Msg Option)
radioCardGroupModel =
    RadioCardGroup.init (Just Motor) validation


radioCardGroupView : () -> Html Msg
radioCardGroupView formData =
    RadioCardGroup.config "radioCard-name"
        |> RadioCardGroup.withLabel (Label.config "Choose the insurance type")
        |> RadioCardGroup.withName "insurance-type"
        |> RadioCardGroup.withOptions
            [ RadioCardGroup.option
                { value = Motor
                , title = Just "Motor"
                , text = Just "Lorem ipsum dolor"
                , addon = Nothing
                }
            , RadioCardGroup.option
                { value = Home
                , title = Just "Home"
                , text = Just "Lorem ipsum dolor"
                , addon = Nothing
                }
            ]
        |> RadioCardGroup.render OnRadioCardFieldMsg formData radioCardGroupModel

```
## Vertical Layout
<component with-label="RadioCardGroup vertical" />
```
RadioCardGroup.config name
    |> RadioCardGroup.withLayout RadioCardGroup.vertical
    |> RadioCardGroup.render
        OnRadioCardFieldMsg
        formData
        (radioCardModel )
```
## Large Size
Please note that with large layout you need to configure an image addon.
<component with-label="RadioCardGroup large" />
```
optionsWithImage : List (RadioCardGroup.Option Option)
optionsWithImage =
    [ RadioCardGroup.option
        { value = Motor
        , title = Just "Motor"
        , text = Just "Lorem ipsum dolor"
        , addon = RadioCardGroup.imgAddon "../assets/placeholder.svg"
        }
    , RadioCardGroup.option
        { value = Home
        , title = Just "Home"
        , text = Just "Lorem ipsum dolor"
        , addon = RadioCardGroup.imgAddon "../assets/placeholder.svg"
        }
    ]

RadioCardGroup.config name
    |> RadioCardGroup.withSize RadioCardGroup.large
    |> RadioCardGroup.withOptions optionsWithImage
    |> RadioCardGroup.render
        OnRadioCardFieldMsg
        formData
        (radioCardModel )
```
## Icon addon
<component with-label="RadioCardGroup with icon" />
```
optionsWithIcon : List (RadioCardGroup.Option Option)
optionsWithIcon =
    [ RadioCardGroup.option
        { value = Motor
        , title = Just "Motor"
        , text = Just "Lorem ipsum dolor"
        , addon = RadioCardGroup.iconAddon IconSet.Car
        }
    , RadioCardGroup.option
        { value = Home
        , title = Just "Home"
        , text = Just "Lorem ipsum dolor"
        , addon = RadioCardGroup.iconAddon IconSet.Home
        }
    ]


RadioCardGroup.config name
    |> RadioCardGroup.withOptions optionsWithIcon
    |> RadioCardGroup.render
        OnRadioCardFieldMsg
        formData
        (radioCardModel )
```
## Text addon
<component with-label="RadioCardGroup with text" />
```
optionsWithTextAddon : List (RadioCardGroup.Option Option)
optionsWithTextAddon =
    [ RadioCardGroup.option
        { value = Motor
        , title = Just "Motor"
        , text = Just "Lorem ipsum dolor"
        , addon = RadioCardGroup.textAddon "€ 800,00"
        }
    , RadioCardGroup.option
        { value = Home
        , title = Just "Home"
        , text = Just "Lorem ipsum dolor"
        , addon = RadioCardGroup.textAddon "€ 1.000,00"
        }
    ]


RadioCardGroup.config name
    |> RadioCardGroup.withOptions optionsWithTextAddon
    |> RadioCardGroup.render
        OnRadioCardFieldMsg
        formData
        (radioCardModel )
```
## Additional Content
<component with-label="RadioCardGroup with additional content" />
```
RadioCardGroup.config name
    |> RadioCardGroup.withAdditionalContent (Html.text "Additional content")
    |> RadioCardGroup.render
        OnRadioCardFieldMsg
        formData
        (radioCardModel )
```
"""


type alias SharedState x =
    { x | radioCard : Model }


type Product
    = Household
    | Motor


type alias Model =
    { base : RadioCardGroup.Model () Product Product (RadioCardGroup.Msg Product)
    , vertical : RadioCardGroup.Model () Product Product (RadioCardGroup.Msg Product)
    , disabled : RadioCardGroup.Model () Product Product (RadioCardGroup.Msg Product)
    , large : RadioCardGroup.Model () Product Product (RadioCardGroup.Msg Product)
    , icon : RadioCardGroup.Model () Product Product (RadioCardGroup.Msg Product)
    , text : RadioCardGroup.Model () Product Product (RadioCardGroup.Msg Product)
    , additionalContent : RadioCardGroup.Model () Product Product (RadioCardGroup.Msg Product)
    }


init : Model
init =
    { base =
        RadioCardGroup.init (Just Motor) (always (Result.fromMaybe "Invalid selection"))
    , vertical =
        RadioCardGroup.init (Just Motor) (always (Result.fromMaybe "Invalid selection"))
    , disabled =
        RadioCardGroup.init (Just Motor) (always (Result.fromMaybe "Invalid selection"))
    , large =
        RadioCardGroup.init (Just Motor) (always (Result.fromMaybe "Invalid selection"))
    , icon =
        RadioCardGroup.init (Just Motor) (always (Result.fromMaybe "Invalid selection"))
    , text =
        RadioCardGroup.init (Just Motor) (always (Result.fromMaybe "Invalid selection"))
    , additionalContent =
        RadioCardGroup.init (Just Motor) (always (Result.fromMaybe "Invalid selection"))
    }


options : List (RadioCardGroup.Option Product)
options =
    [ RadioCardGroup.option
        { value = Motor
        , title = Just "Motor"
        , text = Just "Lorem ipsum dolor"
        , addon = Nothing
        }
    , RadioCardGroup.option
        { value = Household
        , title = Just "Home"
        , text = Just "Lorem ipsum dolor"
        , addon = Nothing
        }
    ]


optionsWithImage : List (RadioCardGroup.Option Product)
optionsWithImage =
    [ RadioCardGroup.option
        { value = Motor
        , title = Just "Motor"
        , text = Just "Lorem ipsum dolor"
        , addon = RadioCardGroup.imgAddon "../assets/placeholder.svg"
        }
    , RadioCardGroup.option
        { value = Household
        , title = Just "Home"
        , text = Just "Lorem ipsum dolor"
        , addon = RadioCardGroup.imgAddon "../assets/placeholder.svg"
        }
    ]


optionsWithIcon : List (RadioCardGroup.Option Product)
optionsWithIcon =
    [ RadioCardGroup.option
        { value = Motor
        , title = Just "Motor"
        , text = Just "Lorem ipsum dolor"
        , addon = RadioCardGroup.iconAddon IconSet.Car
        }
    , RadioCardGroup.option
        { value = Household
        , title = Just "Home"
        , text = Just "Lorem ipsum dolor"
        , addon = RadioCardGroup.iconAddon IconSet.Home
        }
    ]


optionsWithTextAddon : List (RadioCardGroup.Option Product)
optionsWithTextAddon =
    [ RadioCardGroup.option
        { value = Motor
        , title = Just "Motor"
        , text = Just "Lorem ipsum dolor"
        , addon = RadioCardGroup.textAddon "€ 800,00"
        }
    , RadioCardGroup.option
        { value = Household
        , title = Just "Home"
        , text = Just "Lorem ipsum dolor"
        , addon = RadioCardGroup.textAddon "€ 1.000,00"
        }
    ]


type alias StatefulConfig =
    { name : String
    , configModifier : RadioCardGroup.Config Product -> RadioCardGroup.Config Product
    , modelPicker : Model -> RadioCardGroup.Model () Product Product (RadioCardGroup.Msg Product)
    , update : RadioCardGroup.Msg Product -> Model -> ( Model, Cmd (RadioCardGroup.Msg Product) )
    }


statefulComponent : StatefulConfig -> SharedState x -> Html (ElmBook.Msg (SharedState x))
statefulComponent { name, configModifier, modelPicker, update } sharedState =
    RadioCardGroup.config name
        |> RadioCardGroup.withOptions options
        |> configModifier
        |> RadioCardGroup.render identity () (sharedState.radioCard |> modelPicker)
        |> Html.map
            (ElmBook.Actions.mapUpdateWithCmd
                { toState = \sharedState_ models -> { sharedState_ | radioCard = models }
                , fromState = .radioCard
                , update = update
                }
            )


componentsList : List ( String, SharedState x -> Html (ElmBook.Msg (SharedState x)) )
componentsList =
    [ ( "RadioCardGroup"
      , statefulComponent
            { name = "radio-group"
            , configModifier = RadioCardGroup.withLabel (Label.config "Choose the insurance type")
            , modelPicker = .base
            , update =
                \msg models ->
                    let
                        ( updatedModel, cmd ) =
                            RadioCardGroup.update msg models.base
                    in
                    ( { models | base = updatedModel }, cmd )
            }
      )
    , ( "RadioCardGroup vertical"
      , statefulComponent
            { name = "radio-group-vertical"
            , configModifier = RadioCardGroup.withLayout RadioCardGroup.vertical
            , modelPicker = .vertical
            , update =
                \msg models ->
                    let
                        ( updatedModel, cmd ) =
                            RadioCardGroup.update msg models.vertical
                    in
                    ( { models | vertical = updatedModel }, cmd )
            }
      )
    , ( "RadioCardGroup disabled"
      , statefulComponent
            { name = "radio-group-disabled"
            , configModifier = RadioCardGroup.withDisabled True
            , modelPicker = .disabled
            , update =
                \msg models ->
                    let
                        ( updatedModel, cmd ) =
                            RadioCardGroup.update msg models.disabled
                    in
                    ( { models | disabled = updatedModel }, cmd )
            }
      )
    , ( "RadioCardGroup large"
      , statefulComponent
            { name = "radio-group-large"
            , configModifier = RadioCardGroup.withSize RadioCardGroup.large >> RadioCardGroup.withOptions optionsWithImage
            , modelPicker = .large
            , update =
                \msg models ->
                    let
                        ( updatedModel, cmd ) =
                            RadioCardGroup.update msg models.large
                    in
                    ( { models | large = updatedModel }, cmd )
            }
      )
    , ( "RadioCardGroup with icon"
      , statefulComponent
            { name = "radio-group-icon"
            , configModifier = RadioCardGroup.withOptions optionsWithIcon
            , modelPicker = .icon
            , update =
                \msg models ->
                    let
                        ( updatedModel, cmd ) =
                            RadioCardGroup.update msg models.icon
                    in
                    ( { models | icon = updatedModel }, cmd )
            }
      )
    , ( "RadioCardGroup with text"
      , statefulComponent
            { name = "radio-group-text"
            , configModifier = RadioCardGroup.withOptions optionsWithTextAddon
            , modelPicker = .text
            , update =
                \msg models ->
                    let
                        ( updatedModel, cmd ) =
                            RadioCardGroup.update msg models.text
                    in
                    ( { models | text = updatedModel }, cmd )
            }
      )
    , ( "RadioCardGroup with additional content"
      , statefulComponent
            { name = "radio-group-additional-content"
            , configModifier = RadioCardGroup.withAdditionalContent (Html.text "Additional content")
            , modelPicker = .additionalContent
            , update =
                \msg models ->
                    let
                        ( updatedModel, cmd ) =
                            RadioCardGroup.update msg models.additionalContent
                    in
                    ( { models | additionalContent = updatedModel }, cmd )
            }
      )
    ]
