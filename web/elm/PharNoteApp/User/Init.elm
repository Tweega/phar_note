module PharNoteApp.User.Init exposing (..)

import PharNoteApp.User.Rest exposing (getRefData)
import PharNoteApp.User.Model exposing (Model, FormAction(..), FilterDisplay(..), RefDataStatus(..), emptyUserWithRoleSet)
import PharNoteApp.User.BaseModel as UserBase
import PharNoteApp.Msg as AppMsg
import Material.Table as Table
import Array exposing (empty)


init : ( Model, Cmd AppMsg.Msg )
init =
    initialModel
        ! [ getRefData ]



--use init if fetching some intial data at load time.


initialModel : Model
initialModel =
    { users = Array.empty
    , filteredUsers = Array.empty
    , filterDisplay = Hide
    , formAction = None
    , selectedUserId = Nothing
    , selectedUserIndex = Nothing
    , previousSelectedUserId = Nothing
    , previousSelectedUserIndex = Nothing
    , selectedTab = 0
    , order = Just Table.Ascending
    , errors = Nothing
    , pageSize = 6
    , startDisplayIndex = -1
    , endDisplayIndex = -1
    , userSliderValue = 0
    , scratchUser = emptyUserWithRoleSet
    , filterScratchUser = emptyUserWithRoleSet
    , refDataStatus = Loading
    }



--this might be a place to fetch reference or other one-off data (get)
