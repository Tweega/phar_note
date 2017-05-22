module PharNoteApp.Role.Init exposing (..)

import PharNoteApp.Role.Rest exposing (get)
import PharNoteApp.Role.Model exposing (Model, FormAction(..))
import PharNoteApp.Msg as AppMsg
import Material.Table as Table


init : ( Model, Cmd AppMsg.Msg )
init =
    initialModel
        ! []



--use init if fetching some intial data at load time.


initialModel : Model
initialModel =
    { roles = []
    , formAction = None
    , selectedRole = Nothing
    , order = Just Table.Ascending
    , errors = Nothing
    , roleNameInput = ""
    , roleDescInput = ""
    }



--this might be a place to fetch reference or other one-off data (get)
