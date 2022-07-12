module Pyxis.Components.Form.Grid exposing
    ( Option
    , smallGap
    , mediumGap
    , largeGap
    , Row
    , row
    , oneColRowSmall
    , oneColRowMedium
    , oneColRowFullWidth
    , Col
    , col
    , render
    )

{-|


# Grid


## Options

@docs Option
@docs smallGap
@docs mediumGap
@docs largeGap


## Rows

@docs Row
@docs row
@docs oneColRowSmall
@docs oneColRowMedium
@docs oneColRowFullWidth


## Columns

@docs Col
@docs col


## Rendering

@docs render

-}

import Html exposing (Html)
import Html.Attributes
import Pyxis.Components.Form.Grid.Col as Col
import Pyxis.Components.Form.Grid.Gap as Gap exposing (Gap)
import Pyxis.Components.Form.Grid.Row as Row


{-| Represents a Grid.
-}
type alias ConfigData msg =
    { gap : Gap
    , children : List (Row msg)
    }


{-| Internal.
-}
initialConfiguration : ConfigData msg
initialConfiguration =
    { gap = Gap.medium, children = [] }


{-| The available options for a Grid.
-}
type Option msg
    = Option (ConfigData msg -> ConfigData msg)


{-| Creates a small Gap option for the Grid.
-}
smallGap : Option msg
smallGap =
    Option (\c -> { c | gap = Gap.small })


{-| Creates a medium Gap option for the Grid.
-}
mediumGap : Option msg
mediumGap =
    Option (\c -> { c | gap = Gap.medium })


{-| Creates a large Gap option for the Grid.
-}
largeGap : Option msg
largeGap =
    Option (\c -> { c | gap = Gap.large })


{-| Represents a Row which belongs to the Grid.
-}
type Row msg
    = Row (RowConfigData msg)


{-| Internal.
-}
type alias RowConfigData msg =
    { size : Row.Size
    , children : List (Col msg)
    }


{-| Internal.
-}
initialRowConfiguration : RowConfigData msg
initialRowConfiguration =
    { size = Row.large
    , children = []
    }


{-| Given Row's options and Col(umn)s, creates a Row.
-}
row : List (Row.Option (RowConfigData msg)) -> List (Col msg) -> Row msg
row options children =
    let
        configuration : RowConfigData msg
        configuration =
            Row.buildConfiguration options initialRowConfiguration
    in
    Row
        { size = configuration.size
        , children = children
        }


{-| Convenient function to create a Row with small size and one column inside.
-}
oneColRowSmall : List (Html msg) -> Row msg
oneColRowSmall =
    col [] >> List.singleton >> row [ Row.smallSize ]


{-| Convenient function to create a Row with medium size and one column inside.
-}
oneColRowMedium : List (Html msg) -> Row msg
oneColRowMedium =
    col [] >> List.singleton >> row [ Row.mediumSize ]


{-| Convenient function to create a Row with default options and a single Col inside it.
-}
oneColRowFullWidth : List (Html msg) -> Row msg
oneColRowFullWidth =
    col [] >> List.singleton >> row []


{-| Represents a Col(umn) which belongs to the Row.
-}
type Col msg
    = Col (ColConfigData msg)


{-| Internal.
-}
type alias ColConfigData msg =
    { span : Int
    , children : List (Html msg)
    }


{-| Internal.
-}
initialColConfiguration : ColConfigData msg
initialColConfiguration =
    { span = 1
    , children = []
    }


{-| Given Col's options and content, creates a Col.
-}
col : List (Col.Option (ColConfigData msg)) -> List (Html msg) -> Col msg
col options children =
    let
        configuration : ColConfigData msg
        configuration =
            Col.buildConfiguration options initialColConfiguration
    in
    Col
        { span = configuration.span
        , children = children
        }


{-| Renders the Grid.
-}
render : List (Option msg) -> List (Row msg) -> Html msg
render options children =
    let
        configuration : ConfigData msg
        configuration =
            List.foldl (\(Option mapper) config -> mapper config) initialConfiguration options
    in
    Html.div
        [ Html.Attributes.classList
            [ ( "form-grid", True )
            , ( "form-grid--gap-large", Gap.isLarge configuration.gap )
            ]
        ]
        (List.map renderRow children)


{-| Internal. Renders the Row.
-}
renderRow : Row msg -> Html msg
renderRow (Row configuration) =
    Html.div
        [ Html.Attributes.classList
            [ ( "form-grid__row", True )
            , ( "form-grid__row--medium", Row.isMedium configuration.size )
            , ( "form-grid__row--small", Row.isSmall configuration.size )
            ]
        ]
        (List.map renderCol configuration.children)


{-| Internal. Renders the Column.
-}
renderCol : Col msg -> Html msg
renderCol (Col configuration) =
    Html.div
        [ Html.Attributes.classList
            [ ( "form-grid__row__column", True )
            , ( "form-grid__row__column--span-2", 2 == configuration.span )
            , ( "form-grid__row__column--span-3", 3 == configuration.span )
            , ( "form-grid__row__column--span-4", 4 == configuration.span )
            , ( "form-grid__row__column--span-5", 5 == configuration.span )
            ]
        ]
        configuration.children
