module PharNoteApp.Init exposing (..)

import PharNoteApp.Model as AppModel
import PharNoteApp.User.Model as UserModel
import PharNoteApp.Msg as AppMsg
import PharNoteApp.User.Init as UserInit
import PharNoteApp.Chart.Init as ChartInit
import Material


init : ( AppModel.Model, Cmd AppMsg.Msg )
init =
    let
        ( userData, userCmd ) =
            UserInit.init

        ( chartData, chartCmd ) =
            ChartInit.init
    in
        ( { mdl = Material.model
          , userData = userData
          , chartData = chartData
          , activeUser = ""
          }
        , userCmd
        )
