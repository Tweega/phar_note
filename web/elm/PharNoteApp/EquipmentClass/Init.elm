module PharNoteApp.EquipmentClass.Init exposing (..)

import PharNoteApp.EquipmentClass.Model exposing (Model, FormAction(..), EquipmentClassWithPrecision, emptyEquipmentClassWithPrecision)
import PharNoteApp.EquipmentClass.BaseModel as EquipmentClassBase
import PharNoteApp.Msg as AppMsg
import Material.Table as Table
import Array exposing (empty)


init : ( Model, Cmd AppMsg.Msg )
init =
    initialModel
        ! []



--use init if fetching some intial data at load time.


initialModel : Model
initialModel =
    { classes = Array.empty
    , formAction = None
    , selectedEquipmentClassId = Nothing
    , selectedEquipmentClassIndex = Nothing
    , previousSelectedEquipmentClassId = Nothing
    , previousSelectedEquipmentClassIndex = Nothing
    , pageSize = 6
    , startDisplayIndex = -1
    , endDisplayIndex = -1
    , classSliderValue = 0
    , scratchEquipmentClass = emptyEquipmentClassWithPrecision
    , order = Just Table.Ascending
    , errors = Nothing
    }



--this might be a place to fetch reference or other one-off data (get)
