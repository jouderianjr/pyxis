module Components.IconSetTest exposing (suite)

import Pyxis.Commons.Render as CommonsRender
import Pyxis.Components.IconSet as IconSet
import SvgParser
import Test exposing (Test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector


suite : Test
suite =
    Test.describe "The IconSet component"
        [ Test.describe "Renders an svg tag"
            (List.map iconTest IconSet.allIcons)
        ]


iconTest : IconSet.Icon -> Test
iconTest icon =
    Test.test ("from icon " ++ IconSet.toLabel icon) <|
        \() ->
            icon
                |> IconSet.toString
                |> SvgParser.parse
                |> Result.toMaybe
                |> CommonsRender.renderMaybe
                |> Query.fromHtml
                |> Query.has [ Selector.tag "svg" ]
