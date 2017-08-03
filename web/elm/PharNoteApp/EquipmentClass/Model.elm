module PharNoteApp.EquipmentClass.Model exposing (..)

import PharNoteApp.EquipmentClass.BaseModel as EquipmentClassBase
import Material.Table as Table
import Http exposing (..)
import Array exposing (..)
import Dict exposing (Dict)
import Set exposing (Set)


type alias EquipmentClassWithPrecision =
    { id : Int
    , name : String
    , description : String
    , precisions : List EquipmentClassBase.EquipmentPrecision
    }


type alias EquipmentClassWithPrecisionString =
    { id : Int
    , name : String
    , description : String
    , precisions : String
    }


type alias Model =
    { classes : Array EquipmentClassWithPrecision
    , formAction : FormAction
    , precisionAction : PrecisionAction
    , selectedEquipmentClassId : Maybe Int
    , selectedEquipmentClassIndex : Maybe Int
    , selectedPrecisionId : Maybe Int
    , previousSelectedEquipmentClassId : Maybe Int
    , previousSelectedEquipmentClassIndex : Maybe Int
    , pageSize : Int
    , startDisplayIndex : Int
    , endDisplayIndex : Int
    , classSliderValue : Float
    , scratchEquipmentClass : EquipmentClassWithPrecision
    , order : Maybe Table.Order
    , errors : Maybe Http.Error
    }


type FormAction
    = Create
    | Edit
    | ConfirmDelete
    | Delete
    | CancelNewEquipmentClass
    | None


type PrecisionAction
    = PrecisionCreate
    | PrecisionConfirmDelete
    | PrecisionDelete
    | PrecisionNone


emptyEquipmentClassWithPrecision : EquipmentClassWithPrecision
emptyEquipmentClassWithPrecision =
    EquipmentClassWithPrecision 0 "" "" []


scratchToEquipmentClassWithPrecisionString : EquipmentClassWithPrecision -> EquipmentClassWithPrecisionString
scratchToEquipmentClassWithPrecisionString classPrecision =
    let
        precisions =
            classPrecision.precisions
                |> List.map (\i -> toString i.id)
                |> String.join (",")
    in
        EquipmentClassWithPrecisionString classPrecision.id classPrecision.name classPrecision.description precisions
