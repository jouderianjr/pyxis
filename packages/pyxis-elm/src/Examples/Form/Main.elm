module Examples.Form.Main exposing (main)

import Browser
import Examples.Form.Model as Model exposing (Model)
import Examples.Form.Msg exposing (Msg)
import Examples.Form.Update as Update
import Examples.Form.View as View
import PrimaUpdate


main : Program () Model Msg
main =
    Browser.document
        { init = always (PrimaUpdate.withoutCmds Model.initialModel)
        , view = \model -> { title = "Example app", body = [ View.view model ] }
        , update = Update.update
        , subscriptions = always Sub.none
        }
