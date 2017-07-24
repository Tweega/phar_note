module PharNoteApp.Equipment.Init exposing (..)

import PharNoteApp.Equipment.Rest exposing (getRefData)
import PharNoteApp.Equipment.Model exposing (Model, FormAction(..), EquipmentTab(..), RefDataStatus(..), FilterState(..), emptyEquipmentWithRoleSet)
import PharNoteApp.Equipment.BaseModel as EquipmentBase
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
    , filteredEquipments = Array.empty
    , formAction = None
    , selectedEquipmentId = Nothing
    , selectedEquipmentIndex = Nothing
    , previousSelectedEquipmentId = Nothing
    , previousSelectedEquipmentIndex = Nothing
    , selectedTab = Details
    , order = Just Table.Ascending
    , errors = Nothing
    , pageSize = 6
    , startDisplayIndex = -1
    , endDisplayIndex = -1
    , userSliderValue = 0
    , scratchEquipment = emptyEquipmentWithRoleSet
    , filterScratchEquipment = emptyEquipmentWithRoleSet
    , refDataStatus = Loading
    , filterState = NoFilter
    }



--this might be a place to fetch reference or other one-off data (get)
