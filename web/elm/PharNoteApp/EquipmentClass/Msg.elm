module PharNoteApp.EquipmentClass.Msg exposing (..)

import PharNoteApp.EquipmentClass.Model as EquipmentClass
import PharNoteApp.EquipmentClass.BaseModel as EquipmentClassBase


--import PharNoteApp.EquipmentClass.Model exposing (FilterAction(..))

import PharNoteApp.Role.BaseModel as Role
import Http exposing (..)


type Msg
    = NoOp
    | EditEquipmentClass
    | SelectEquipmentClass Int
    | DeleteEquipmentClass
    | NewEquipmentClass
    | CancelNewEquipmentClass
    | ProcessEquipmentClassGet (Result Http.Error (List EquipmentClass.EquipmentClassWithPrecision))
    | ProcessEquipmentClassPost (Result Http.Error EquipmentClass.EquipmentClassWithPrecision)
    | ProcessEquipmentClassDelete (Result Http.Error EquipmentClass.EquipmentClassWithPrecision)
    | SetClassName String
    | SetClassDesc String
    | ToggleRole Int
    | EquipmentClassPost EquipmentClass.EquipmentClassWithPrecision
    | EquipmentClassPut EquipmentClass.EquipmentClassWithPrecision
    | Reorder
    | KeyX Int
    | PaginateEquipmentClass Int
    | ConfirmDeleteEquipmentClass
    | CancelDeleteEquipmentClass



--| EquipmentClassSlider Float
--reset - clears entries on filter formAction
-- clear - goes back to original user list
-- cancel - just closes the filter form.
