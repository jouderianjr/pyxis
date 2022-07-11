module Pyxis.Commons.Attributes exposing
    ( ariaActiveDescendant
    , ariaAutocomplete
    , ariaDescribedBy
    , ariaDescribedByErrorOrHint
    , ariaExpanded
    , ariaHidden
    , ariaLabel
    , ariaLabelledbyBy
    , ariaOwns
    , role
    , target
    , testId
    , renderIf
    , maybe
    , none
    , ariaSelected
    )

{-|


## A11Y Attributes

@docs ariaActiveDescendant
@docs ariaAutocomplete
@docs ariaDescribedBy
@docs ariaDescribedByErrorOrHint
@docs ariaExpanded
@docs ariaHidden
@docs ariaLabel
@docs ariaLabelledbyBy
@docs ariaOwns
@docs role


## Attributes

@docs LinkTarget
@docs target
@docs testId


## Utilities

@docs renderIf
@docs maybe
@docs none

-}

import Html
import Html.Attributes
import Json.Encode
import Maybe.Extra
import Pyxis.Commons.Alias as CommonsAlias
import Pyxis.Commons.Attributes.LinkTarget as CommonsAttributesLinkTarget exposing (LinkTarget)


target : LinkTarget -> Html.Attribute msg
target =
    CommonsAttributesLinkTarget.toString
        >> Html.Attributes.target


{-| Creates an aria-label attribute.
-}
ariaLabel : String -> Html.Attribute msg
ariaLabel =
    Html.Attributes.attribute "aria-label"


{-| Creates an aria-hidden attribute.
-}
ariaHidden : Bool -> Html.Attribute msg
ariaHidden a =
    Html.Attributes.attribute "aria-hidden"
        (if a then
            "true"

         else
            "false"
        )


{-| Creates a role attribute.
-}
role : String -> Html.Attribute msg
role =
    Html.Attributes.attribute "role"


{-| Creates an data-test-id attribute.
-}
testId : CommonsAlias.Id -> Html.Attribute msg
testId =
    Html.Attributes.attribute "data-test-id"


{-| Creates an aria-describedby attribute.
-}
ariaDescribedBy : CommonsAlias.Id -> Html.Attribute msg
ariaDescribedBy =
    Html.Attributes.attribute "aria-describedby"


{-| Creates an aria-describedby attribute based on Error or Hint
-}
ariaDescribedByErrorOrHint : Maybe CommonsAlias.Id -> Maybe CommonsAlias.Id -> Html.Attribute msg
ariaDescribedByErrorOrHint errorId hintId =
    Maybe.Extra.or errorId hintId
        |> Maybe.map ariaDescribedBy
        |> Maybe.withDefault none


{-| Creates an aria-labelledby attribute.
-}
ariaLabelledbyBy : CommonsAlias.Id -> Html.Attribute msg
ariaLabelledbyBy =
    Html.Attributes.attribute "aria-labelledby"


{-| Creates an aria-autocomplete attribute.
-}
ariaAutocomplete : String -> Html.Attribute msg
ariaAutocomplete =
    Html.Attributes.attribute "aria-autocomplete"


{-| Creates an aria-expanded attribute.
-}
ariaExpanded : String -> Html.Attribute msg
ariaExpanded =
    Html.Attributes.attribute "aria-expanded"


{-| Creates an aria-owns attribute.
-}
ariaOwns : CommonsAlias.Id -> Html.Attribute msg
ariaOwns =
    Html.Attributes.attribute "aria-owns"


{-| Creates an aria-activedescendant attribute.
-}
ariaActiveDescendant : String -> Html.Attribute msg
ariaActiveDescendant =
    Html.Attributes.attribute "aria-activedescendant"


{-| Creates an aria-selected attribute.
-}
ariaSelected : String -> Html.Attribute msg
ariaSelected =
    Html.Attributes.attribute "aria-selected"



-- Conditional utilities


{-| Renders a noop attribute, akin to Cmd.none or Sub.none

Copied from <https://github.com/NoRedInk/noredink-ui/blob/15.6.1/src/Nri/Ui/Html/Attributes/V2.elm#L34>

-}
none : Html.Attribute msg
none =
    Html.Attributes.property "none@pyxis-elm" Json.Encode.null


{-| Renders the given attribute when the flag is True (else render Attribute.none)
-}
renderIf : Bool -> Html.Attribute msg -> Html.Attribute msg
renderIf bool attr =
    if bool then
        attr

    else
        none


{-| Renders the value wrapped in Maybe, when present (else renders Attribute.none)

    maybeId : Maybe String

    button
        [ Pyxis.Commons.Attributes.maybe Html.Attributes.id maybeId ]
        []

-}
maybe : (a -> Html.Attribute msg) -> Maybe a -> Html.Attribute msg
maybe f =
    Maybe.map f >> Maybe.withDefault none
