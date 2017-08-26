module PharNoteApp.EquipmentClass.Msg exposing (..)

import PharNoteApp.EquipmentClass.Model as EquipmentClass
import PharNoteApp.EquipmentClass.BaseModel as EquipmentClassBase


--import PharNoteApp.EquipmentClass.Model exposing (FilterAction(..))

import PharNoteApp.Role.BaseModel as Role
import Http exposing (..)


type Msg
    = NoOp
    | NewEquipmentClass
    | EditEquipmentClass
    | CancelNewEquipmentClass
    | SelectEquipmentClass Int
    | SelectPrecision Int
    | DeleteEquipmentClass
    | ConfirmDeleteEquipmentClass
    | CancelDeleteEquipmentClass
    | ProcessEquipmentClassGet (Result Http.Error (List EquipmentClass.EquipmentClassWithPrecisionList))
    | ProcessEquipmentClassPost (Result Http.Error EquipmentClass.EquipmentClassWithPrecisionList)
    | ProcessEquipmentClassDelete (Result Http.Error EquipmentClass.EquipmentClassWithPrecisionList)
    | DeletePrecision
    | ConfirmDeletePrecision
    | CancelDeletePrecision
    | SetClassName String
    | SetClassDesc String
    | NewPrecision
    | EditPrecision
    | CancelNewPrecision
    | PrecisionPost
    | PrecisionPut
    | SetPrecision String
    | ToggleRole Int
    | EquipmentClassPost EquipmentClass.EquipmentClassWithPrecision
    | EquipmentClassPut EquipmentClass.EquipmentClassWithPrecision
    | Reorder
    | KeyX Int
    | PrecisionKeyX Int
    | PaginateEquipmentClass Int



--| EquipmentClassSlider Float
--reset - clears entries on filter formAction
-- clear - goes back to original user list
-- cancel - just closes the filter form.
