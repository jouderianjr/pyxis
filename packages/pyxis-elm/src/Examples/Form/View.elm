module Examples.Form.View exposing (view)

import Examples.Form.Data as Data exposing (Data)
import Examples.Form.Model exposing (Model)
import Examples.Form.Msg exposing (Msg(..))
import Examples.Form.Views.BaseInformation as BaseInformation
import Examples.Form.Views.ClaimDetail as ClaimDetail
import Examples.Form.Views.ClaimType as ClaimType
import Examples.Form.Views.Faqs as Faqs
import Examples.Form.Views.InsuranceType as InsuranceType
import Examples.Form.Views.Modal as Modal
import Examples.Form.Views.RequestFailed as RequestFailed
import Examples.Form.Views.RequestReceived as RequestReceived
import Html exposing (Html)
import Html.Attributes
import Pyxis.Commons.Render as CommonsRender
import Pyxis.Components.Form as Form


view : Model -> Html Msg
view model =
    Html.div
        [ Html.Attributes.class "container padding-v-xl margin-v-xl" ]
        [ pyxisCSS
        , viewport
        , viewForm model.data
        , Html.div
            [ Html.Attributes.class "container-small padding-v-m margin-v-xl" ]
            [ RequestReceived.view
                |> CommonsRender.renderIf model.showSuccess
            , RequestFailed.view
                |> CommonsRender.renderIf (Data.isInsuranceTypeHousehold model.data)
            ]
        , Modal.view model.showModal
        , Html.div
            [ Html.Attributes.class "container-responsive padding-v-m margin-v-xl" ]
            [ Html.text "Any question? Check out our FAQs:"
            , Faqs.view model
            ]
        ]


pyxisCSS : Html msg
pyxisCSS =
    stylesheet "../../../dist/pyxis.css"


stylesheet : String -> Html msg
stylesheet path =
    Html.node "link"
        [ Html.Attributes.href path
        , Html.Attributes.rel "stylesheet"
        ]
        []


viewport : Html msg
viewport =
    Html.node "meta"
        [ Html.Attributes.name "viewport"
        , Html.Attributes.attribute "content" "width=device-width, initial-scale=1"
        ]
        []


viewForm : Data -> Html Msg
viewForm data =
    Form.config
        |> Form.withDynamicFieldSets
            [ ( InsuranceType.view data, True )
            , ( BaseInformation.view data, Data.isInsuranceTypeMotor data )
            , ( ClaimType.view data, Data.isInsuranceTypeMotor data )
            , ( ClaimDetail.view data, Data.isInsuranceTypeMotor data )
            ]
        |> Form.withOnSubmit Submit
        |> Form.render
