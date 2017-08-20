module PharNoteApp.EquipmentClass.Init exposing (..)

import PharNoteApp.EquipmentClass.Model exposing (Model, FormAction(..), PrecisionAction(..), EquipmentClassWithPrecision, emptyEquipmentClassWithPrecision, emptyPrecision)
import PharNoteApp.EquipmentClass.BaseModel as EquipmentClassBase
import PharNoteApp.Msg as AppMsg
import Material.Table as Table
import Array exposing (empty)


init : ( Model, Cmd AppMsg.Msg )
init =
    initialModel
        ! []


initialModel : Model
initialModel =
    { classes = Array.empty
    , formAction = None
    , precisionAction = PrecisionNone
    , selectedEquipmentClassId = Nothing
    , selectedEquipmentClassIndex = Nothing
    , selectedPrecisionId = Nothing
    , selectedPrecisionIndex = Nothing
    , previousSelectedEquipmentClassId = Nothing
    , previousSelectedEquipmentClassIndex = Nothing
    , previousSelectedPrecisionId = Nothing
    , previousSelectedPrecisionIndex = Nothing
    , pageSize = 6
    , startDisplayIndex = -1
    , endDisplayIndex = -1
    , classSliderValue = 0
    , scratchEquipmentClass = emptyEquipmentClassWithPrecision
    , scratchPrecision = emptyPrecision
    , order = Just Table.Ascending
    , errors = Nothing
    }



--this might be a place to fetch reference or other one-off data (get)
