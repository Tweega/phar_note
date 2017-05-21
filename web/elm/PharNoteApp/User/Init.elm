module PharNoteApp.User.Init exposing (..)

import PharNoteApp.User.Rest exposing (get)
import PharNoteApp.User.Model exposing (Model, FormAction(..))
import PharNoteApp.Msg as AppMsg
import Material.Table as Table


init : ( Model, Cmd AppMsg.Msg )
init =
    initialModel
        ! []



--use init if fetching some intial data at load time.


initialModel : Model
initialModel =
    { users = []
    , formAction = None
    , selectedUser = Nothing
    , order = Just Table.Ascending
    , errors = Nothing
    , firstNameInput = ""
    , lastNameInput = ""
    , emailInput = ""
    , photoUrlInput = ""
    }



--this might be a place to fetch reference or other one-off data (get)
