module Stories.Chapters.Legend exposing (docs)

import ElmBook
import ElmBook.Chapter
import Html exposing (Html)
import Pyxis.Components.Form.Legend as Legend
import Pyxis.Components.IconSet as Icon


docs : ElmBook.Chapter.Chapter sharedState
docs =
    "Legend"
        |> ElmBook.Chapter.chapter
        |> ElmBook.Chapter.withComponentList componentsList
        |> ElmBook.Chapter.render """

Legend
<component with-label="Default" />
```
legend: Html msg
legend =
    Legend.config "Legend"
        |> Legend.render
```
---
## With Description
<component with-label="WithDescription" />
```
Legend.config "Legend"
    |> Legend.withDescription "Legend description"
    |> Legend.render
```
---
## With Image Addon
<component with-label="WithImageAddon" />
```
Legend.config "Legend"
    |> Legend.withImage "../assets/placeholder.svg"
    |> Legend.withDescription "Legend description"
    |> Legend.render
```
---
## With Icon Addon
<component with-label="WithIconAddon" />
```
Legend.config "Legend"
    |> Legend.withIcon Icon.Car
    |> Legend.withDescription "Legend description"
    |> Legend.render
```
---
## With Left Alignment
<component with-label="WithLeftAlignment" />
```
Legend.config "Legend"
    |> Legend.withAlignmentLeft
    |> Legend.withDescription "Legend description"
    |> Legend.render
```
"""


componentsList : List ( String, Html (ElmBook.Msg state) )
componentsList =
    [ ( "Default"
      , Legend.config "Legend"
            |> Legend.render
      )
    , ( "WithDescription"
      , Legend.config "Legend"
            |> Legend.withDescription "Legend description"
            |> Legend.render
      )
    , ( "WithImageAddon"
      , Legend.config "Legend"
            |> Legend.withImage "../assets/placeholder.svg"
            |> Legend.withDescription "Legend description"
            |> Legend.render
      )
    , ( "WithIconAddon"
      , Legend.config "Legend"
            |> Legend.withIcon Icon.Car
            |> Legend.withDescription "Legend description"
            |> Legend.render
      )
    , ( "WithLeftAlignment"
      , Legend.config "Legend"
            |> Legend.withDescription "Legend description"
            |> Legend.withAlignmentLeft
            |> Legend.render
      )
    ]
