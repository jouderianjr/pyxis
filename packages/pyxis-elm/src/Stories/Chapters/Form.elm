module Stories.Chapters.Form exposing (docs)

import ElmBook
import ElmBook.Actions
import ElmBook.Chapter
import Html exposing (Html)
import Html.Attributes
import Pyxis.Components.Button as Button
import Pyxis.Components.Form as Form
import Pyxis.Components.Form.FieldSet as FieldSet
import Pyxis.Components.Form.Grid as Grid
import Pyxis.Components.Form.Grid.Col as Col


docs : ElmBook.Chapter.Chapter sharedState
docs =
    "Form and FieldSets"
        |> ElmBook.Chapter.chapter
        |> ElmBook.Chapter.withComponentList componentsList
        |> ElmBook.Chapter.render """

Forms are a set of input components whose purpose is to allow data entry.
The basic structure of a form is made up of some basic elements: form, fieldset, grid, row column and item.
For a visual rapresentation of grid, you can check the
[Storybook](https://react-staging.prima.design/?path=/story/components-form-%F0%9F%9A%A7-overview--page) documentation.

Below an example of full form grid configuration:

<component with-label="Form Anatomy" />

```
Form.config
    |> Form.withFieldSets
        [ FieldSet.config
            |> FieldSet.withHeader
                [ Grid.oneColRowFullWidth
                    [ columnContent "Fieldset header"
                    ]
                ]
            |> FieldSet.withContent
                [ Grid.oneColRowFullWidth
                    [ columnContent "Fieldset row 1"
                    ]
                , Grid.oneColRowFullWidth
                    [ columnContent "Fieldset row 2"
                    ]
                , Grid.oneColRowFullWidth
                    [ columnContent "Fieldset row n"
                    ]
                ]
            |> FieldSet.withFooter
                [ Grid.oneColRowFullWidth
                    [ columnContent "Fieldset footer"
                    ]
                ]
        ]
    |> Form.render
```


## Form
Form element represents a document section containing interactive controls for submitting information.
Each form can include multiple Fieldset.

```
form: Html msg
form =
    Form.config
        |> Form.withFieldSets []
        |> Form.render
```

## Fieldset
Fieldset element is used to group several controls as well as labels within a web form.

Every fieldset is composed by three (optional) macro area: `header`, `content` and `footer`.

```
fieldset: Html msg
fieldset =
    FieldSet.config
        |> FieldSet.withHeader []
        |> FieldSet.withContent []
        |> FieldSet.withFooter []
        |> FieldSet.render
```

## Row
Form Row is used to define the width of grid and to group the columns inside it.

### Default Row

Default dimensions are 100% of its base container.
It is recommended to use this setting for horizontal forms on single or multiple rows.

<component with-label="Row" />

```
Grid.render
    []
    [ Grid.oneColRowFullWidth [ columnContent "Lorem ipsum dolor sit amet." ] ]
```

### Medium Row

Medium dimensions (720px) are recommended to use this setting for vertical development forms with the possibility
of placing components not belonging to the same group side by side.

If the Medium Row contain only one column you can use `Grid.oneColRowMedium` utility function.

<component with-label="Row Medium" />

```
-- With utility function
Grid.render
    []
    [ Grid.oneColRowMedium
        [ columnContent "Lorem ipsum dolor sit amet." ]
    ]

-- Without utility function
Grid.render
    []
    [ Grid.row [ Row.mediumSize ]
        [ Grid.col []
            [ columnContent "Lorem ipsum dolor sit amet." ]
        ]
    ]
```

### Small Row

Small dimensions (360px) are recommended to use this setting for vertical development
forms with the possibility of tiling only components of the same group.

If the Small Row contain only one column you can use `Grid.oneColRowSmall` utility function.

<component with-label="Row Small" />

```
-- With utility function
Grid.render
    []
    [ Grid.oneColRowSmall
        [ columnContent "Lorem ipsum dolor sit amet." ]
    ]

-- Without utility function
Grid.render
    []
    [ Grid.row [ Row.smallSize ]
        [ Grid.col []
            [ columnContent "Lorem ipsum dolor sit amet." ]
        ]
    ]
```

## Column
Form Column is used to align horizontally and define the width of a `form-item`.
Each row can have a maximum of `6` columns based on its size. Normally the columns are divided into equal fractions `fr`.
Anyways, it is possible to set the span of the columns up to a maximum of `5`,
in this way it is possible to have a column wide `1` and a column wide `5`.

<component with-label="Multi-column Row" />

```
Grid.render
    []
    [ Grid.row []
        [ Grid.col [] [ columnContent "Column 1" ]
        , Grid.col [] [ columnContent "Column 2" ]
        ]
    ]
```


### Complex grid layout

<component with-label="Multi-column Row with different column sizes" />

```
Grid.render
    []
    [ Grid.row []
        [ Grid.col [ Col.span4 ]
            [ columnContent "Colspan 4"
            ]
        , Grid.col [ Col.span2 ]
            [ columnContent "Colspan 2"
            ]
        ]
    , Grid.row []
        [ Grid.col [ Col.span4 ]
            [ columnContent "Colspan 4"
            ]
        , Grid.col [ Col.span2 ]
            [ columnContent "Colspan 2"
            ]
        ]
    , Grid.row []
        [ Grid.col [ Col.span2 ]
            [ columnContent "Colspan 2"
            ]
        , Grid.col [ Col.span2 ]
            [ columnContent "Colspan 2"
            ]
        , Grid.col [ Col.span2 ]
            [ columnContent "Colspan 2"
            ]
        ]
    , Grid.row []
        [ Grid.col [ Col.span2 ]
            [ columnContent "Colspan 2"
            ]
        , Grid.col [ Col.span4 ]
            [ columnContent "Colspan 4"
            ]
        ]
    , Grid.row []
        [ Grid.col [ Col.span1 ]
            [ columnContent "Colspan 1"
            ]
        , Grid.col [ Col.span5 ]
            [ columnContent "Colspan 5"
            ]
        ]
    ]
```

## Form With Submit
Add a onSubmit event to form component.

<component with-label="Form With submit" />
```
Form.config
    |> Form.withOnSubmit OnSubmit
    |> Form.withFieldSets
        [ ... ]
    |> Form.render
```
"""


componentsList : List ( String, Html (ElmBook.Msg state) )
componentsList =
    [ ( "Form Anatomy"
      , Form.config
            |> Form.withFieldSets
                [ FieldSet.config
                    |> FieldSet.withHeader
                        [ Grid.oneColRowFullWidth
                            [ columnContent "Fieldset header"
                            ]
                        ]
                    |> FieldSet.withContent
                        [ Grid.oneColRowFullWidth
                            [ columnContent "Fieldset row 1"
                            ]
                        , Grid.oneColRowFullWidth
                            [ columnContent "Fieldset row 2"
                            ]
                        , Grid.oneColRowFullWidth
                            [ columnContent "Fieldset row n"
                            ]
                        ]
                    |> FieldSet.withFooter
                        [ Grid.oneColRowFullWidth
                            [ columnContent "Fieldset footer"
                            ]
                        ]
                ]
            |> Form.render
      )
    , ( "Row"
      , Grid.render
            []
            [ Grid.oneColRowFullWidth [ columnContent "Lorem ipsum dolor sit amet." ] ]
      )
    , ( "Row Medium"
      , Grid.render
            []
            [ Grid.oneColRowMedium
                [ columnContent "Lorem ipsum dolor sit amet." ]
            ]
      )
    , ( "Row Small"
      , Grid.render
            []
            [ Grid.oneColRowSmall
                [ columnContent "Lorem ipsum dolor sit amet." ]
            ]
      )
    , ( "Multi-column Row"
      , Grid.render
            []
            [ Grid.row []
                [ Grid.col [] [ columnContent "Column 1" ]
                , Grid.col [] [ columnContent "Column 2" ]
                ]
            ]
      )
    , ( "Multi-column Row with different column sizes"
      , Grid.render
            []
            [ Grid.row []
                [ Grid.col [ Col.span4 ]
                    [ columnContent "Colspan 4"
                    ]
                , Grid.col [ Col.span2 ]
                    [ columnContent "Colspan 2"
                    ]
                ]
            , Grid.row []
                [ Grid.col [ Col.span4 ]
                    [ columnContent "Colspan 4"
                    ]
                , Grid.col [ Col.span2 ]
                    [ columnContent "Colspan 2"
                    ]
                ]
            , Grid.row []
                [ Grid.col [ Col.span2 ]
                    [ columnContent "Colspan 2"
                    ]
                , Grid.col [ Col.span2 ]
                    [ columnContent "Colspan 2"
                    ]
                , Grid.col [ Col.span2 ]
                    [ columnContent "Colspan 2"
                    ]
                ]
            , Grid.row []
                [ Grid.col [ Col.span2 ]
                    [ columnContent "Colspan 2"
                    ]
                , Grid.col [ Col.span4 ]
                    [ columnContent "Colspan 4"
                    ]
                ]
            , Grid.row []
                [ Grid.col [ Col.span1 ]
                    [ columnContent "Colspan 1"
                    ]
                , Grid.col [ Col.span5 ]
                    [ columnContent "Colspan 5"
                    ]
                ]
            ]
      )
    , ( "Form With submit"
      , Form.config
            |> Form.withOnSubmit (ElmBook.Actions.logAction "Form submitted")
            |> Form.withFieldSets
                [ FieldSet.config
                    |> FieldSet.withContent
                        [ Grid.oneColRowFullWidth
                            [ columnContent "Form content"
                            ]
                        ]
                    |> FieldSet.withFooter
                        [ Grid.oneColRowFullWidth
                            [ Button.primary
                                |> Button.withType Button.submit
                                |> Button.withText "Submit"
                                |> Button.render
                            ]
                        ]
                ]
            |> Form.render
      )
    ]


columnContent : String -> Html msg
columnContent content =
    Html.div
        [ Html.Attributes.classList
            [ ( "bg-neutral-95", True )
            , ( "padding-s", True )
            , ( "radius-s", True )
            , ( "text-s-book", True )
            ]
        ]
        [ Html.text content ]
