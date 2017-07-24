module PharNoteApp.Equipment.Init exposing (..)

import PharNoteApp.Equipment.Rest exposing (getRefData)
import PharNoteApp.Equipment.Model exposing (Model, FormAction(..), EquipmentTab(..), RefDataStatus(..), FilterState(..))
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
    { equipment = Array.empty
    , filteredEquipment = Array.empty
    , formAction = None
    , selectedEquipmentId = Nothing
    , selectedEquipmentIndex = Nothing
    , previousSelectedEquipmentId = Nothing
    , previousSelectedEquipmentIndex = Nothing
    , pageSize = 6
    , startDisplayIndex = -1
    , endDisplayIndex = -1
    , equipmentSliderValue = 0
    , scratchEquipment = EquipmentBase.emptyEquipment
    , filterScratchEquipment = EquipmentBase.emptyEquipment
    , selectedTab = Details
    , order = Just Table.Ascending
    , errors = Nothing
    , refDataStatus = Loading
    , filterState = NoFilter
    }



--this might be a place to fetch reference or other one-off data (get)
