module PharNoteApp.Chart.Init exposing (..)

import PharNoteApp.Msg as AppMsg
import PharNoteApp.Chart.Model exposing (Model)
import Dict exposing (Dict)
import Material


init : ( Model, Cmd AppMsg.Msg )
init =
    initialModel
        ! []



--use init if fetching some intial data at load time.


initialModel : Model
initialModel =
    { mdl = Material.model
    , toggles = Dict.empty
    }



--don't know if Cmd.None counts as AppMsg.Msg
