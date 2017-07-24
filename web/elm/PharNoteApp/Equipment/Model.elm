module PharNoteApp.Equipment.Model exposing (..)

import PharNoteApp.Equipment.BaseModel as EquipmentBase
import Material.Table as Table
import Http exposing (..)
import Array exposing (..)
import Dict exposing (Dict)
import Set exposing (Set)


type alias Model =
    { equipment : Array EquipmentBase.Equipment
    , filteredEquipment : Array EquipmentBase.Equipment
    , formAction : FormAction
    , selectedEquipmentId : Maybe Int
    , selectedEquipmentIndex : Maybe Int
    , previousSelectedEquipmentId : Maybe Int
    , previousSelectedEquipmentIndex : Maybe Int
    , pageSize : Int
    , startDisplayIndex : Int
    , endDisplayIndex : Int
    , equipmentSliderValue : Float
    , scratchEquipment : EquipmentBase.Equipment
    , filterScratchEquipment : EquipmentBase.Equipment
    , selectedTab : EquipmentTab
    , order : Maybe Table.Order
    , errors : Maybe Http.Error
    , refDataStatus : RefDataStatus
    , filterState : FilterState
    }


type EquipmentTab
    = Details
    | Filter


type FilterState
    = Applied
    | NoFilter


type RefDataStatus
    = Loading
    | Loaded RefData


type alias RefData =
    { roles : Dict Int EquipmentBase.Equipment
    }


type FormAction
    = Create
    | Edit
    | ConfirmDelete
    | Delete
    | CancelNewEquipment
    | None


equipmentTabToInt : EquipmentTab -> Int
equipmentTabToInt uTab =
    case uTab of
        Details ->
            0

        Filter ->
            1


intToEquipmentTab : Int -> EquipmentTab
intToEquipmentTab iTab =
    case iTab of
        1 ->
            Filter

        _ ->
            Details
