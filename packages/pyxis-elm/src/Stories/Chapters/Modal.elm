module Stories.Chapters.Modal exposing (Model, docs, init)

import ElmBook
import ElmBook.Actions
import ElmBook.Chapter
import Html exposing (Html)
import Pyxis.Commons.Properties.Theme as Theme
import Pyxis.Components.Badge as Badge
import Pyxis.Components.Button as Button
import Pyxis.Components.Icon as Icon
import Pyxis.Components.IconSet as IconSet
import Pyxis.Components.Modal as Modal
import Pyxis.Components.Modal.Footer as ModalFooter
import Pyxis.Components.Modal.Header as ModalHeader


docs : ElmBook.Chapter.Chapter (SharedState x)
docs =
    "Modal"
        |> ElmBook.Chapter.chapter
        |> ElmBook.Chapter.withStatefulComponentList componentsList
        |> ElmBook.Chapter.render """       
Modal
<component with-label="Default" />
```
type Msg = OnOpenModal | OnCloseModal

modalHeader : ModalHeader.Config Msg
modalHeader =
    ModalHeader.config
        |> ModalHeader.withTitle "Title Modal"


modalContent : List (Html msg)
modalContent =
    [ Html.text "Lorem ipsum dolor sit amet..." ]


modalFooter : ModalFooter.Config Msg
modalFooter =
    ModalFooter.config
        |> ModalFooter.withButtons
            [ Button.primary
                |> Button.withText "Ok"
                |> Button.withType (Button.button OnClose)
                |> Button.render
            ]

modal : Bool -> Html Msg
modal initialState =
    Modal.config id
        |> Modal.withCloseMsg OnCloseModal "Close"
        |> Modal.withHeader modalHeader
        |> Modal.withContent modalContent
        |> Modal.withFooter modalFooter
        |> Modal.render initialState

buttonWithModal : List (Html Msg)
buttonWithModal =
    Html.div []
        [ Button.primary
            |> Button.withText "Open modal"
            |> Button.withType (Button.button OnOpenModal)
            |> Button.render
        , modal False
        ]
```

## General modal configuration
Follow the example above to configure the modal correctly. Please note that omitting the modifier `withOnCloseMsg`
will result in a modal that is not closable clicking outside and without the closing button in the header.

### Size
Size available are Small, Medium (default) and Large
<component with-label="WithSize" />
```
modal initialState =
    Modal.config id
        |> Modal.withSize Modal.small
        |> Modal.withCloseMsg OnCloseModal "Close"
        |> Modal.withHeader modalHeader
        |> Modal.withContent modalContent
        |> Modal.withFooter modalFooter
        |> Modal.render initialState
```

### Centered
By default modal is always positioned in the top of the screen, but it is also possible to center it vertically. This use is recommended only if the modal is not high.
<component with-label="WithCentered" />
```
modal initialState =
    Modal.config id
        |> Modal.withIsCentered True
        |> Modal.withCloseMsg OnCloseModal "Close"
        |> Modal.withHeader modalHeader
        |> Modal.withContent modalContent
        |> Modal.withFooter modalFooter
        |> Modal.render initialState
```

### WithAriaDescribedBy
<component with-label="WithAriaDescribedBy" />
```
modal initialState =
    Modal.config id
        |> Modal.withAriaDescribedBy "Description for assistive technology"
        |> Modal.withCloseMsg OnCloseModal "Close"
        |> Modal.withHeader modalHeader
        |> Modal.withContent modalContent
        |> Modal.withFooter modalFooter
        |> Modal.render initialState
```

## Header configuration
### With a Badge
<component with-label="WithBadge" />
```
modalHeader =
    ModalHeader.config
        |> ModalHeader.withBadge (Badge.brand "badge")
        |> ModalHeader.withTitle "Title Modal"
```

### With an Icon
<component with-label="WithIcon" />
```
modalHeader =
    ModalHeader.config
        |> ModalHeader.withIcon (IconSet.Car |> Icon.config)
        |> ModalHeader.withTitle "Title Modal"
```

### Sticky Header
<component with-label="WithIsSticky" />
```
modalHeader =
    ModalHeader.config
        |> ModalHeader.withIsSticky True
        |> ModalHeader.withTitle "Title Modal"
```

### Custom Header
<component with-label="WithCustomHeader" />
```
modalHeader =
    ModalHeader.config
        |> ModalHeader.withCustomContent [ Html.text "Custom Header Title" ]
        |> ModalHeader.withTitle "Title Modal"
```


## Footer configuration
### With Full Width Button
On bottomsheet, buttons will be full-width.
<component with-label="WithFullWidthButton" />
```
modalFooter =
    ModalFooter.config
        |> ModalFooter.withFullWidthButton True
        |> ModalFooter.withButtons
            [ Button.primary
                |> Button.withText "Ok"
                |> Button.withType (Button.button OnClose)
                |> Button.render
            ]
```

### With Text
<component with-label="WithText" />
```
modalFooter =
    ModalFooter.config
        |> ModalFooter.withText (Html.text "Footer Text")
        |> ModalFooter.withButtons
            [ Button.primary
                |> Button.withText "Ok"
                |> Button.withType (Button.button OnClose)
                |> Button.render
            ]
```

### With Theme
<component with-label="WithTheme" />
```
modalFooter =
    ModalFooter.config
        |> ModalFooter.withTheme Theme.alternative
        |> ModalFooter.withButtons
            [ Button.primary
                |> Button.withText "Ok"
                |> Button.withType (Button.button OnClose)
                |> Button.render
            ]
```

### Sticky Footer
<component with-label="WithStickyFooter" />
```
modalFooter =
    ModalFooter.config
        |> ModalFooter.withIsSticky True
        |> ModalFooter.withButtons
            [ Button.primary
                |> Button.withText "Ok"
                |> Button.withType (Button.button OnClose)
                |> Button.render
            ]
```

### Custom Footer
<component with-label="WithCustomFooter" />
```
modalFooter =
    ModalFooter.config
        |> ModalFooter.withCustomContent [ Html.text "Custom Footer Content" ]
        |> ModalFooter.withButtons
            [ Button.primary
                |> Button.withText "Ok"
                |> Button.withType (Button.button OnClose)
                |> Button.render
            ]
```

"""


type alias SharedState x =
    { x | modal : Model }


type alias Model =
    { base : Bool
    , size : Bool
    , centered : Bool
    , ariaDescribed : Bool
    , badge : Bool
    , icon : Bool
    , sticky : Bool
    , customHeader : Bool
    , fullWidthButton : Bool
    , footerText : Bool
    , theme : Bool
    , stickyFooter : Bool
    , customFooter : Bool
    }


init : Model
init =
    { base = False
    , size = False
    , centered = False
    , ariaDescribed = False
    , badge = False
    , icon = False
    , sticky = False
    , customHeader = False
    , fullWidthButton = False
    , footerText = False
    , theme = False
    , stickyFooter = False
    , customFooter = False
    }


modalHeader :
    (ModalHeader.Config (ElmBook.Msg (SharedState x)) -> ModalHeader.Config (ElmBook.Msg (SharedState x)))
    -> ModalHeader.Config (ElmBook.Msg (SharedState x))
modalHeader configModifier =
    ModalHeader.config
        |> configModifier
        |> ModalHeader.withTitle "Title Modal"


modalContent : List (Html msg)
modalContent =
    [ Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec commodo massa at velit ullamcorper semper. Duis vel sapien in magna pellentesque ullamcorper. Sed congue vehicula hendrerit. Donec commodo purus magna, vel tincidunt risus tristique nec." ]


modalFooter :
    (ModalFooter.Config (ElmBook.Msg (SharedState x)) -> ModalFooter.Config (ElmBook.Msg (SharedState x)))
    -> (SharedState x -> Model -> Model)
    -> SharedState x
    -> ModalFooter.Config (ElmBook.Msg (SharedState x))
modalFooter configModifier updater sharedState =
    ModalFooter.config
        |> configModifier
        |> ModalFooter.withButtons
            [ Button.primary
                |> Button.withText "Ok"
                |> Button.withType Button.button
                |> Button.withOnClick (toggleVisibility updater sharedState)
                |> Button.render
            ]


toggleVisibility : (SharedState x -> Model -> Model) -> SharedState x -> ElmBook.Msg (SharedState x)
toggleVisibility updater =
    ElmBook.Actions.updateStateWith (updater >> mapModel)


componentsList : List ( String, SharedState x -> Html (ElmBook.Msg (SharedState x)) )
componentsList =
    [ ( "Default"
      , statefulComponent "default" identity identity identity .base setBase
      )
    , ( "WithSize"
      , statefulComponent "withSize" (Modal.withSize Modal.small) identity identity .size setSize
      )
    , ( "WithCentered"
      , statefulComponent "WithCentered" (Modal.withIsCentered True) identity identity .centered setCentered
      )
    , ( "WithAriaDescribedBy"
      , statefulComponent
            "withAriaDescribedBy"
            (Modal.withAriaDescribedBy "Description for assistive technology")
            identity
            identity
            .ariaDescribed
            setAriaDescribed
      )
    , ( "WithBadge"
      , statefulComponent
            "withBadge"
            identity
            (ModalHeader.withBadge (Badge.brand "badge"))
            identity
            .badge
            setBadge
      )
    , ( "WithIcon"
      , statefulComponent
            "withIcon"
            identity
            (ModalHeader.withIcon (IconSet.Car |> Icon.config))
            identity
            .icon
            setIcon
      )
    , ( "WithIsSticky"
      , statefulComponent
            "withIsSticky"
            identity
            (ModalHeader.withIsSticky True)
            identity
            .sticky
            setSticky
      )
    , ( "WithCustomHeader"
      , statefulComponent
            "withCustomHeader"
            identity
            (ModalHeader.withCustomContent [ Html.text "Custom Header Title" ])
            identity
            .customHeader
            setCustomHeader
      )
    , ( "WithFullWidthButton"
      , statefulComponent
            "withFullWidthButton"
            identity
            identity
            (ModalFooter.withFullWidthButton True)
            .fullWidthButton
            setFullWidthButton
      )
    , ( "WithText"
      , statefulComponent
            "withText"
            identity
            identity
            (ModalFooter.withText (Html.text "Footer Text"))
            .footerText
            setFooterText
      )
    , ( "WithTheme"
      , statefulComponent
            "withTheme"
            identity
            identity
            (ModalFooter.withTheme Theme.alternative)
            .theme
            setTheme
      )
    , ( "WithStickyFooter"
      , statefulComponent
            "withStickyFooter"
            identity
            identity
            (ModalFooter.withIsSticky True)
            .stickyFooter
            setStickyFooter
      )
    , ( "WithCustomFooter"
      , statefulComponent
            "withCustomFooter"
            identity
            identity
            (ModalFooter.withCustomContent [ Html.text "Custom Footer Content" ])
            .customFooter
            setCustomFooter
      )
    ]


statefulComponent :
    String
    -> (Modal.Config (ElmBook.Msg (SharedState x)) -> Modal.Config (ElmBook.Msg (SharedState x)))
    -> (ModalHeader.Config (ElmBook.Msg (SharedState x)) -> ModalHeader.Config (ElmBook.Msg (SharedState x)))
    -> (ModalFooter.Config (ElmBook.Msg (SharedState x)) -> ModalFooter.Config (ElmBook.Msg (SharedState x)))
    -> (Model -> Bool)
    -> (SharedState x -> Model -> Model)
    -> SharedState x
    -> Html (ElmBook.Msg (SharedState x))
statefulComponent id configModifier headerModifier footerModifier modelPicker updater sharedState =
    Html.div []
        [ Button.primary
            |> Button.withText "Open modal"
            |> Button.withType Button.button
            |> Button.withOnClick (toggleVisibility updater sharedState)
            |> Button.render
        , Modal.config id
            |> Modal.withCloseMsg (toggleVisibility updater sharedState) "Close"
            |> Modal.withHeader (modalHeader headerModifier)
            |> Modal.withContent modalContent
            |> Modal.withFooter (modalFooter footerModifier updater sharedState)
            |> configModifier
            |> Modal.render (sharedState.modal |> modelPicker)
        ]


mapModel : (Model -> Model) -> SharedState x -> SharedState x
mapModel updateModel sharedState =
    { sharedState | modal = updateModel sharedState.modal }


setBase : SharedState x -> Model -> Model
setBase _ model =
    { model | base = not model.base }


setSize : SharedState x -> Model -> Model
setSize _ model =
    { model | size = not model.size }


setCentered : SharedState x -> Model -> Model
setCentered _ model =
    { model | centered = not model.centered }


setAriaDescribed : SharedState x -> Model -> Model
setAriaDescribed _ model =
    { model | ariaDescribed = not model.ariaDescribed }


setBadge : SharedState x -> Model -> Model
setBadge _ model =
    { model | badge = not model.badge }


setIcon : SharedState x -> Model -> Model
setIcon _ model =
    { model | icon = not model.icon }


setSticky : SharedState x -> Model -> Model
setSticky _ model =
    { model | sticky = not model.sticky }


setCustomHeader : SharedState x -> Model -> Model
setCustomHeader _ model =
    { model | customHeader = not model.customHeader }


setFullWidthButton : SharedState x -> Model -> Model
setFullWidthButton _ model =
    { model | fullWidthButton = not model.fullWidthButton }


setFooterText : SharedState x -> Model -> Model
setFooterText _ model =
    { model | footerText = not model.footerText }


setTheme : SharedState x -> Model -> Model
setTheme _ model =
    { model | theme = not model.theme }


setStickyFooter : SharedState x -> Model -> Model
setStickyFooter _ model =
    { model | stickyFooter = not model.stickyFooter }


setCustomFooter : SharedState x -> Model -> Model
setCustomFooter _ model =
    { model | customFooter = not model.customFooter }
