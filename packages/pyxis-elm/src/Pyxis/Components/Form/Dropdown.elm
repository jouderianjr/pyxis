module Pyxis.Components.Form.Dropdown exposing
    ( Content
    , options
    , headerAndOptions
    , noResult
    , suggestion
    , SuggestionData
    , render
    , Size, medium, small
    )

{-|


# Dropdown

@docs action
@docs Content
@docs options
@docs headerAndOptions
@docs noResult
@docs suggestion
@docs SuggestionData


## Rendering

@docs render

-}

import Html exposing (Html)
import Html.Attributes
import Html.Keyed
import Pyxis.Commons.Render as CommonsRender
import Pyxis.Components.Icon as Icon
import Pyxis.Components.IconSet as IconSet


{-| Dropdown size
-}
type Size
    = Small
    | Medium


{-| Dropdown size small
-}
small : Size
small =
    Small


{-| Dropdown size medium
-}
medium : Size
medium =
    Medium


type Content msg
    = NoResult (NoResultData msg)
    | HeaderAndOptions (HeaderAndOptionsData msg)
    | Options (List (Html msg))
    | Suggestion SuggestionData


type alias NoResultData msg =
    { label : String
    , action : Maybe (Html msg)
    }


type alias HeaderAndOptionsData msg =
    { header : Html msg
    , options : List (Html msg)
    }


type alias SuggestionData =
    { icon : IconSet.Icon
    , title : String
    , subtitle : Maybe String
    }


{-| Creates the action.
-}
noResult : NoResultData msg -> Content msg
noResult =
    NoResult


{-| Creates a content with and header.
-}
headerAndOptions : HeaderAndOptionsData msg -> Content msg
headerAndOptions =
    HeaderAndOptions


{-| Creates the most simple content.
-}
options : List (Html msg) -> Content msg
options =
    Options


{-| Creates a suggestion.
-}
suggestion : SuggestionData -> Content msg
suggestion =
    Suggestion


{-| Internal.
-}
hasHeader : Content msg -> Bool
hasHeader content_ =
    case content_ of
        HeaderAndOptions _ ->
            True

        _ ->
            False


{-| Renders the Dropdown.
-}
render : String -> Size -> Content msg -> Html msg
render id size content_ =
    Html.div
        [ Html.Attributes.class "form-dropdown-wrapper"
        , Html.Attributes.classList
            [ ( "form-dropdown-wrapper--small", Small == size )
            ]
        ]
        [ Html.Keyed.node "div"
            [ Html.Attributes.attribute "role" "listbox"
            , Html.Attributes.classList
                [ ( "form-dropdown", True )
                , ( "form-dropdown--with-header", hasHeader content_ )
                ]
            , Html.Attributes.id (id ++ "-dropdown-list")
            ]
            (content_
                |> renderContent
                |> List.indexedMap (\index item -> ( String.fromInt index, item ))
            )
        ]


{-| Internal.
-}
renderContent : Content msg -> List (Html msg)
renderContent content_ =
    case content_ of
        HeaderAndOptions config ->
            renderHeader config.header :: config.options

        Options options_ ->
            options_

        NoResult noResultData ->
            [ renderNoResult noResultData ]

        Suggestion config ->
            [ renderSuggestion config ]


{-| Internal.
-}
renderNoResult : NoResultData msg -> Html msg
renderNoResult { label, action } =
    Html.div
        [ Html.Attributes.class "form-dropdown__no-results" ]
        [ Html.text label
        , action
            |> Maybe.map (List.singleton >> Html.div [ Html.Attributes.class "form-dropdown__no-results__action" ])
            |> CommonsRender.renderMaybe
        ]


{-| Internal.
-}
renderHeader : Html msg -> Html msg
renderHeader content_ =
    Html.div [ Html.Attributes.class "form-dropdown__header" ] [ content_ ]


{-| Internal.
-}
renderSuggestion : SuggestionData -> Html msg
renderSuggestion { icon, title, subtitle } =
    Html.div
        [ Html.Attributes.class "form-dropdown__suggestion" ]
        [ renderSuggestionIcon icon
        , Html.div
            [ Html.Attributes.class "form-dropdown__suggestion__wrapper" ]
            [ renderSuggestionTitle title
            , subtitle
                |> Maybe.map renderSuggestionSubtitle
                |> CommonsRender.renderMaybe
            ]
        ]


{-| Internal.
-}
renderSuggestionIcon : IconSet.Icon -> Html msg
renderSuggestionIcon =
    Icon.config
        >> Icon.withSize Icon.medium
        >> Icon.withClassList [ ( "form-dropdown__suggestion__icon", True ) ]
        >> Icon.render


{-| Internal.
-}
renderSuggestionTitle : String -> Html msg
renderSuggestionTitle title =
    Html.div
        [ Html.Attributes.class "form-dropdown__suggestion__title" ]
        [ Html.text title ]


{-| Internal.
-}
renderSuggestionSubtitle : String -> Html msg
renderSuggestionSubtitle subtitle =
    Html.div
        [ Html.Attributes.class "form-dropdown__suggestion__subtitle" ]
        [ Html.text subtitle ]
