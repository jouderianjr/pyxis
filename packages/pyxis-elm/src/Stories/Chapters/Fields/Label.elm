module Stories.Chapters.Fields.Label exposing (docs)

import Commons.Properties.Size as Size
import Components.Field.Label as Label
import ElmBook
import ElmBook.Chapter
import Html exposing (Html)


docs : ElmBook.Chapter.Chapter sharedState
docs =
    "Fields/Label"
        |> ElmBook.Chapter.chapter
        |> ElmBook.Chapter.withComponentList componentsList
        |> ElmBook.Chapter.render """

Label component provides a label to be used within a form. It requires a _text_ value.

<component with-label="Label" />
```
import Components.Field.Label as Label

myLabel: Html msg
myLabel =
    Label.config "Label"
        |> Label.render
```

## For
<component with-label="For" />
```
import Components.Field.Label as Label

myLabel: Html msg
myLabel =
    Label.config "Label"
        |> Label.withFor "input-id"
        |> Label.render
```
## ID
<component with-label="Id" />
```
import Components.Field.Label as Label

{-| Note that setting an id to the Label also implies setting a data-test-id
attribute with the same value of the id received.
-}
myLabel: Html msg
myLabel =
    Label.config "Label"
        |> Label.withId "label-id"
        |> Label.render
```
## Variations
Label can have an additional explanatory text or can be set with a smaller size.

### With an additional text
<component with-label="Additional text" />
```
import Components.Field.Label as Label

myLabel: Html msg
myLabel =
    Label.config "Main label"
        |> Label.withSubText "This is an additional text"
        |> Label.render
```

### Size: small
<component with-label="Small" />
```
import Components.Field.Label as Label
import Commons.Properties.Size as Size

myLabel: Html msg
myLabel =
    Label.config "Smaller label"
        |> Label.withSize Size.small
        |> Label.render
```
---
## Accessibility
Remember that the _for_ attribute provided must be equal to the id attribute of the related input element to bind
them together.
"""


componentsList : List ( String, Html (ElmBook.Msg state) )
componentsList =
    [ ( "Label"
      , Label.config "Label"
            |> Label.render
      )
    , ( "For"
      , Label.config "Label"
            |> Label.withFor "input-id"
            |> Label.render
      )
    , ( "Id"
      , Label.config "Label"
            |> Label.withId "label-id"
            |> Label.render
      )
    , ( "Additional text"
      , Label.config "Main label"
            |> Label.withSubText "This is an additional text"
            |> Label.render
      )
    , ( "Small"
      , Label.config "Smaller label"
            |> Label.withSize Size.small
            |> Label.render
      )
    ]