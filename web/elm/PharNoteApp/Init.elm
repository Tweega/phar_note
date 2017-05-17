module PharNoteApp.Init exposing (..)

import PharNoteApp.Model as AppModel
import PharNoteApp.User.Model as UserModel
import PharNoteApp.Msg as AppMsg
import PharNoteApp.User.Init as UserInit


init : ( AppModel.Model, Cmd AppMsg.Msg )
init =
    let
        ( userData, userCmd ) =
            UserInit.init
    in
        ( { userData = userData
          }
        , userCmd
        )
