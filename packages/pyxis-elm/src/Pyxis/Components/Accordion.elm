module Pyxis.Components.Accordion exposing
    ( Model
    , init
    , Config
    , config
    , singleOpening
    , multipleOpening
    , withItems
    , withClassList
    , withTheme
    , withVariant
    , neutral
    , light
    , Msg
    , update
    , render
    )

{-|


# Accordion

@docs Model
@docs init


## Configuration

@docs Config
@docs config


## Opening Type

@docs singleOpening
@docs multipleOpening


## Generics

@docs withItems
@docs withClassList
@docs withTheme
@docs withVariant
@docs neutral
@docs light


## Update

@docs Msg
@docs update


## Rendering

@docs render

-}

import Browser.Dom
import Dict exposing (Dict)
import Html
import Html.Attributes
import PrimaUpdate
import Pyxis.Commons.Alias as CommonsAlias
import Pyxis.Commons.Attributes as CommonsAttributes
import Pyxis.Commons.Properties.Theme as Theme exposing (Theme)
import Pyxis.Components.Accordion.Item as Item
import Task


{-| Represents the Accordion item message.
-}
type Msg
    = OnClick CommonsAlias.Id
    | OnFocus CommonsAlias.Id
    | GotElement CommonsAlias.Id (Result Browser.Dom.Error Browser.Dom.Element)


{-| Opening types.
-}
type OpeningType
    = Single (Maybe String)
    | Multiple (List String)


{-| Init single Opening types.
-}
singleOpening : Maybe CommonsAlias.Id -> OpeningType
singleOpening openedId =
    Single openedId


{-| Init multiple Opening types.
-}
multipleOpening : List CommonsAlias.Id -> OpeningType
multipleOpening openedIds =
    Multiple openedIds


{-| Internal. Accordion Model.
-}
type Model
    = Model
        { itemsHeight : Dict CommonsAlias.Id Float
        , openingType : OpeningType
        }


{-| Initializes the Accordion state.
-}
init : OpeningType -> Model
init openingType =
    Model
        { itemsHeight = Dict.empty
        , openingType = openingType
        }


{-| Accordion variants.
-}
type Variant
    = Neutral
    | Light


{-| Init Neutral variant.
-}
neutral : Variant
neutral =
    Neutral


{-| Init Light variant.
-}
light : Variant
light =
    Light


{-| Internal. The internal Accordion configuration
-}
type alias ConfigData msg =
    { classList : List ( String, Bool )
    , id : CommonsAlias.Id
    , items : List (Item.Config msg)
    , theme : Theme
    , variant : Variant
    }


{-| The view configuration
-}
type Config msg
    = Config (ConfigData msg)


{-| Creates an accordion
-}
config : CommonsAlias.Id -> Config msg
config id =
    Config
        { classList = []
        , id = id
        , items = []
        , theme = Theme.default
        , variant = Neutral
        }


{-| Sets items.
-}
withItems : List (Item.Config msg) -> Config msg -> Config msg
withItems items (Config configuration) =
    Config { configuration | items = items }


{-| Adds a classList.
-}
withClassList : List ( String, Bool ) -> Config msg -> Config msg
withClassList classes (Config configuration) =
    Config { configuration | classList = classes }


{-| Sets a theme.
-}
withTheme : Theme -> Config msg -> Config msg
withTheme theme (Config configuration) =
    Config { configuration | theme = theme }


{-| Sets a variant.
-}
withVariant : Variant -> Config msg -> Config msg
withVariant variant (Config configuration) =
    Config { configuration | variant = variant }


{-| Updates the Accordion item.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model model) =
    case msg of
        OnClick id ->
            Model { model | openingType = updateOpeningType id model.openingType }
                |> PrimaUpdate.withCmd
                    (id
                        |> Item.setContentId
                        |> Browser.Dom.getElement
                        |> Task.attempt (GotElement id)
                    )

        OnFocus id ->
            Model model
                |> PrimaUpdate.withCmd
                    (id
                        |> Item.setContentId
                        |> Browser.Dom.getElement
                        |> Task.attempt (GotElement id)
                    )

        GotElement id (Ok currentElement) ->
            Model { model | itemsHeight = Dict.insert id currentElement.element.height model.itemsHeight }
                |> PrimaUpdate.withoutCmds

        GotElement _ (Err _) ->
            Model model
                |> PrimaUpdate.withoutCmds


{-| Internal. Update OpeningType.
-}
updateOpeningType : CommonsAlias.Id -> OpeningType -> OpeningType
updateOpeningType clickedId openingType =
    case openingType of
        Multiple openedId ->
            if List.member clickedId openedId then
                Multiple (List.filter ((/=) clickedId) openedId)

            else
                Multiple (clickedId :: openedId)

        Single (Just id) ->
            if clickedId == id then
                Single Nothing

            else
                Single (Just clickedId)

        Single Nothing ->
            Single (Just clickedId)


{-| Renders the accordion.
-}
render : (Msg -> msg) -> Model -> Config msg -> Html.Html msg
render tagger (Model { itemsHeight, openingType }) (Config { classList, id, items, theme, variant }) =
    Html.div
        [ Html.Attributes.class "accordion"
        , Html.Attributes.classList classList
        , Html.Attributes.id id
        , CommonsAttributes.testId id
        ]
        (List.map
            (Item.render
                { onClick = OnClick >> tagger
                , onFocus = OnFocus >> tagger
                , classList = itemClassList theme variant
                , isOpen = itemIsOpen openingType
                , itemsHeight = itemsHeight
                }
            )
            items
        )


{-| Internal. Check if item is open.
-}
itemIsOpen : OpeningType -> CommonsAlias.Id -> Bool
itemIsOpen openingType id =
    case openingType of
        Multiple openedIds ->
            List.member id openedIds

        Single openId ->
            Just id == openId


{-| Internal. Generate item class list.
-}
itemClassList : Theme -> Variant -> List ( String, Bool )
itemClassList theme variant =
    [ ( "accordion-item--alt", theme == Theme.alternative )
    , ( "accordion-item--light", variant == Light )
    ]
