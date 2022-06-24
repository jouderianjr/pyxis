module Pyxis.Components.Modal exposing
    ( Config
    , config
    , Size
    , small
    , medium
    , large
    , withSize
    , withHeader
    , withContent
    , withFooter
    , withClassList
    , withCloseMsg
    , withAriaDescribedBy
    , withIsCentered
    , render
    )

{-|


# Modal component

@docs Config
@docs config


## Size

@docs Size
@docs small
@docs medium
@docs large
@docs withSize


## Content

@docs withHeader
@docs withContent
@docs withFooter


## Generics

@docs withClassList
@docs withCloseMsg
@docs withAriaDescribedBy
@docs withIsCentered


## Rendering

@docs render

-}

import Html exposing (Html)
import Html.Attributes
import Html.Events
import Maybe.Extra
import Pyxis.Commons.Attributes as CommonsAttributes
import Pyxis.Commons.Render as CommonsRender
import Pyxis.Components.Modal.Footer as Footer
import Pyxis.Components.Modal.Header as Header


{-| Internal. The internal Modal configuration.
-}
type alias ConfigData msg =
    { ariaDescribedBy : Maybe String
    , classList : List ( String, Bool )
    , content : List (Html msg)
    , footer : Maybe (Footer.Config msg)
    , header : Maybe (Header.Config msg)
    , id : String
    , isCentered : Bool
    , onCloseMsg : Maybe (Header.OnCloseData msg)
    , size : Size
    }


{-| The Modal configuration.
-}
type Config msg
    = Config (ConfigData msg)


{-| Inits the Modal.

    import Pyxis.Components.Modal as Modal
    import Pyxis.Components.Modal.Footer as ModalFooter
    import Pyxis.Components.Modal.Header as ModalHeader

    showModal : Bool
    showModal =
        True

    modal : Html msg
    modal =
        Modal.config "test-modal"
            |> Modal.withHeader modalHeader
            |> Modal.withContent modalContent
            |> Modal.withFooter modalFooter
            |> Modal.render showModal

    modalHeader : ModalHeader.Config msg
    modalHeader =
        ModalHeader.config
            |> ModalHeader.withIsSticky
            |> ModalHeader.withTitle "Title Modal"

    modalContent : List (Html msg)
    modalContent =
        [ Html.text "Modal content" ]

    modalFooter : ModalFooter.Config msg
    modalFooter =
        ModalFooter.config
            |> ModalFooter.withIsSticky
            |> ModalFooter.withText "Text Footer"

-}
config : String -> Config msg
config id =
    Config
        { ariaDescribedBy = Nothing
        , classList = []
        , content = []
        , footer = Nothing
        , header = Nothing
        , id = id
        , isCentered = False
        , onCloseMsg = Nothing
        , size = Medium
        }


{-| The size configuration
-}
type Size
    = Small
    | Medium
    | Large


{-| Small size
-}
small : Size
small =
    Small


{-| Medium size
-}
medium : Size
medium =
    Medium


{-| Large size
-}
large : Size
large =
    Large


{-| Sets the size to the Modal.
-}
withSize : Size -> Config msg -> Config msg
withSize size (Config configData) =
    Config { configData | size = size }


{-| Sets the Header to the Modal.
-}
withHeader : Header.Config msg -> Config msg -> Config msg
withHeader header (Config configData) =
    Config { configData | header = Just header }


{-| Sets the Content to the Modal.
-}
withContent : List (Html msg) -> Config msg -> Config msg
withContent content (Config configData) =
    Config { configData | content = content }


{-| Sets the Footer to the Modal.
-}
withFooter : Footer.Config msg -> Config msg -> Config msg
withFooter footer (Config configData) =
    Config { configData | footer = Just footer }


{-| Adds a ClassList to Modal.
-}
withClassList : List ( String, Bool ) -> Config msg -> Config msg
withClassList classList (Config configData) =
    Config { configData | classList = classList }


{-| Sets the Modal visibility.
-}
withCloseMsg : msg -> String -> Config msg -> Config msg
withCloseMsg msg ariaLabel (Config configData) =
    Config { configData | onCloseMsg = Just { msg = msg, ariaLabel = ariaLabel } }


{-| Sets the Modal visibility.
-}
withAriaDescribedBy : String -> Config msg -> Config msg
withAriaDescribedBy ariaDescribedBy (Config configData) =
    Config { configData | ariaDescribedBy = Just ariaDescribedBy }


{-| Sets the center position to Modal.
-}
withIsCentered : Bool -> Config msg -> Config msg
withIsCentered isCentered (Config configData) =
    Config { configData | isCentered = isCentered }


{-| Renders the Modal.
-}
render : Bool -> Config msg -> Html.Html msg
render isOpen (Config { classList, header, content, footer, size, onCloseMsg, ariaDescribedBy, id, isCentered }) =
    Html.div
        [ Html.Attributes.classList
            [ ( "modal-backdrop", True )
            , ( "modal-backdrop--show", isOpen )
            ]
        , Html.Attributes.id id
        , CommonsAttributes.role "dialog"
        , CommonsAttributes.ariaHidden (not isOpen)
        , CommonsAttributes.testId id
        , describedByAttribute id ariaDescribedBy
        , Html.Attributes.attribute "aria-modal" "true"
        ]
        [ ariaDescribedBy
            |> Maybe.map renderDescribedBy
            |> CommonsRender.renderMaybe
        , Html.div
            [ Html.Attributes.class "modal-close"
            , CommonsAttributes.maybe (.msg >> Html.Events.onClick) onCloseMsg
            ]
            []
        , Html.div
            [ Html.Attributes.classList
                [ ( "modal", True )
                , ( "modal--small", size == Small )
                , ( "modal--medium", size == Medium )
                , ( "modal--large", size == Large )
                , ( "modal--center", isCentered )
                ]
            , Html.Attributes.classList classList
            ]
            [ header
                |> Maybe.map (Header.withCloseButton onCloseMsg)
                |> Maybe.map Header.render
                |> CommonsRender.renderMaybe
            , Html.div
                [ Html.Attributes.class "modal__content" ]
                content
            , footer
                |> Maybe.map Footer.render
                |> CommonsRender.renderMaybe
            ]
        ]


{-| Internal. Generate described id from id
-}
describedById : String -> String
describedById =
    (++) "described-"


{-| Internal. Render describedby attribute if exists.
-}
describedByAttribute : String -> Maybe String -> Html.Attribute msg
describedByAttribute id ariaDescribedBy =
    id
        |> describedById
        |> CommonsAttributes.ariaDescribedBy
        |> CommonsAttributes.renderIf (Maybe.Extra.isJust ariaDescribedBy)


{-| Internal. Render the screen reader description.
-}
renderDescribedBy : String -> Html msg
renderDescribedBy description =
    Html.div [ Html.Attributes.class "screen-reader-only" ]
        [ Html.text description
        ]
