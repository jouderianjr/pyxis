-- Constructors are exposed by design, since it's internal and there isn't a reason to make it opaque


module Pyxis.Components.CardGroup exposing
    ( Addon(..)
    , Config
    , Layout(..)
    , Option
    , Size(..)
    , renderCheckbox
    , renderRadio
    )

{-| Common Card fields view
-}

import Html exposing (Html)
import Html.Attributes
import Html.Events
import Maybe.Extra
import Pyxis.Commons.Alias as CommonsAlias
import Pyxis.Commons.Attributes as CommonsAttributes
import Pyxis.Commons.Render as CommonsRender
import Pyxis.Commons.String as CommonsString
import Pyxis.Components.Field.Error as Error
import Pyxis.Components.Field.Hint as Hint
import Pyxis.Components.Field.Label as Label
import Pyxis.Components.Form.FormItem as FormItem
import Pyxis.Components.Icon as Icon
import Pyxis.Components.IconSet as IconSet


{-| Represent the layout of the group.
-}
type Layout
    = Horizontal
    | Vertical


type Type
    = Radio
    | Checkbox


{-| Card group size
-}
type Size
    = Medium
    | Large


{-| This is non opaque by design
-}
type alias Config r =
    { r
        | size : Size
        , name : CommonsAlias.Name
        , id : CommonsAlias.Id
        , label : Maybe Label.Config
        , classList : List ( String, Bool )
        , layout : Layout
        , hint : Maybe Hint.Config
        , additionalContent : Maybe (Html Never)
    }


type alias Option msg =
    { onCheck : Bool -> msg
    , onFocus : msg
    , onBlur : msg
    , addon : Maybe Addon
    , text : Maybe String
    , title : Maybe String
    , isChecked : Bool
    , isDisabled : Bool
    }


toType : Type -> String
toType type_ =
    case type_ of
        Radio ->
            "radio"

        Checkbox ->
            "checkbox"


getRole : Type -> String
getRole type_ =
    case type_ of
        Radio ->
            "radiogroup"

        Checkbox ->
            "group"


renderCheckbox : Maybe (Error.Config parsedValue) -> Config r -> List (Option msg) -> Html msg
renderCheckbox =
    render Checkbox


renderRadio : Maybe (Error.Config parsedValue) -> Config r -> List (Option msg) -> Html msg
renderRadio =
    render Radio


render : Type -> Maybe (Error.Config parsedValue) -> Config r -> List (Option msg) -> Html msg
render type_ error configData options =
    Html.div
        [ Html.Attributes.classList
            [ ( "form-card-group", True )
            , ( "form-card-group--column", configData.layout == Vertical )
            ]
        , Html.Attributes.classList configData.classList
        , Html.Attributes.id configData.id
        , CommonsAttributes.testId configData.id
        , CommonsAttributes.role (getRole type_)
        , CommonsAttributes.ariaLabelledbyBy (labelId configData.id)
        , CommonsAttributes.renderIf (Error.isVisible error)
            (CommonsAttributes.ariaDescribedBy (Error.idFromFieldId configData.id))
        ]
        (List.indexedMap (renderCard type_ error configData) options)
        |> FormItem.config configData
        |> FormItem.withLabel configData.label
        |> FormItem.withAdditionalContent configData.additionalContent
        |> FormItem.render error


{-| Internal.
-}
labelId : CommonsAlias.Id -> String
labelId id =
    id ++ "-label"


renderCard : Type -> Maybe (Error.Config parsedValue) -> Config r -> Int -> Option msg -> Html msg
renderCard type_ error config index option =
    let
        id_ : String
        id_ =
            makeId config option index
    in
    Html.label
        [ Html.Attributes.classList
            [ ( "form-card", True )
            , ( "form-card--error", Error.isVisible error )
            , ( "form-card--checked", option.isChecked )
            , ( "form-card--disabled", option.isDisabled )
            , ( "form-card--large", config.size == Large )
            ]
        ]
        [ option.addon
            |> Maybe.map renderPrependAddon
            |> CommonsRender.renderMaybe
        , Html.span
            [ Html.Attributes.class "form-card__content-wrapper" ]
            [ option.title
                |> Maybe.map (renderContent "title")
                |> CommonsRender.renderMaybe
            , option.text
                |> Maybe.map (renderContent "text")
                |> CommonsRender.renderMaybe
            ]
        , option.addon
            |> Maybe.map renderAppendAddon
            |> CommonsRender.renderMaybe
        , Html.input
            [ Html.Attributes.type_ (toType type_)
            , Html.Attributes.class ("form-control__" ++ toType type_)
            , Html.Attributes.checked option.isChecked
            , Html.Attributes.disabled option.isDisabled
            , Html.Attributes.id id_
            , CommonsAttributes.testId id_
            , Html.Attributes.name config.name
            , Html.Events.onCheck option.onCheck
            , Html.Events.onFocus option.onFocus
            , Html.Events.onBlur option.onBlur
            ]
            []
        ]


{-| Internal.
-}
renderContent : String -> String -> Html msg
renderContent identifier str =
    Html.span [ Html.Attributes.class ("form-card__" ++ identifier) ] [ Html.text str ]


{-| Internal.
-}
makeId : { m | id : CommonsAlias.Id } -> { c | text : Maybe String, title : Maybe String } -> Int -> String
makeId { id } { text, title } index =
    [ id
    , Maybe.Extra.or title text
        |> Maybe.withDefault (String.fromInt index)
        |> String.left 25
        |> CommonsString.toKebabCase
    , "option"
    ]
        |> String.join "-"


{-| Represent the different types of addon
-}
type Addon
    = TextAddon String
    | IconAddon IconSet.Icon
    | ImgUrlAddon String


{-| Internal.
-}
renderPrependAddon : Addon -> Html msg
renderPrependAddon addon =
    case addon of
        IconAddon icon ->
            Html.span
                [ Html.Attributes.class "form-card__addon form-card__addon--with-icon"
                , CommonsAttributes.testId (IconSet.toLabel icon)
                ]
                [ icon
                    |> Icon.config
                    |> Icon.withSize Icon.large
                    |> Icon.render
                ]

        ImgUrlAddon url ->
            Html.span
                [ Html.Attributes.class "form-card__addon" ]
                [ Html.img
                    [ Html.Attributes.src url
                    , Html.Attributes.width 70
                    , Html.Attributes.height 70
                    , Html.Attributes.alt ""
                    , CommonsAttributes.ariaHidden True
                    ]
                    []
                ]

        _ ->
            Html.text ""


{-| Internal.
-}
renderAppendAddon : Addon -> Html msg
renderAppendAddon addon =
    case addon of
        TextAddon str ->
            Html.span [ Html.Attributes.class "form-card__addon" ] [ Html.text str ]

        _ ->
            Html.text ""
