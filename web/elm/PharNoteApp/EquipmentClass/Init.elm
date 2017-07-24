module PharNoteApp.EquipmentClass.Init exposing (..)

import PharNoteApp.EquipmentClass.Rest exposing (getRefData)
import PharNoteApp.EquipmentClass.Model exposing (Model, FormAction(..), EquipmentClassTab(..), RefDataStatus(..), FilterState(..), emptyEquipmentClassWithRoleSet)
import PharNoteApp.EquipmentClass.BaseModel as EquipmentClassBase
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
    , filteredEquipmentClasss = Array.empty
    , formAction = None
    , selectedEquipmentClassId = Nothing
    , selectedEquipmentClassIndex = Nothing
    , previousSelectedEquipmentClassId = Nothing
    , previousSelectedEquipmentClassIndex = Nothing
    , selectedTab = Details
    , order = Just Table.Ascending
    , errors = Nothing
    , pageSize = 6
    , startDisplayIndex = -1
    , endDisplayIndex = -1
    , userSliderValue = 0
    , scratchEquipmentClass = emptyEquipmentClassWithRoleSet
    , filterScratchEquipmentClass = emptyEquipmentClassWithRoleSet
    , refDataStatus = Loading
    , filterState = NoFilter
    }



--this might be a place to fetch reference or other one-off data (get)
