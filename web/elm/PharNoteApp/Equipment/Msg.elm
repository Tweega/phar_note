module PharNoteApp.Equipment.Msg exposing (..)

import PharNoteApp.Equipment.Model as Equipment
import PharNoteApp.Equipment.BaseModel as EquipmentBase


--import PharNoteApp.Equipment.Model exposing (FilterAction(..))

import PharNoteApp.Role.BaseModel as Role
import Http exposing (..)


type Msg
    = NoOp
    | EditEquipment
    | SelectEquipment Int
    | DeleteEquipment
    | NewEquipment
    | CancelNewEquipment
    | ProcessEquipmentGet (Result Http.Error (List EquipmentBase.Equipment))
    | ProcessEquipmentPost (Result Http.Error EquipmentBase.Equipment)
    | ProcessEquipmentDelete (Result Http.Error EquipmentBase.Equipment)
    | ProcessRefDataGet (Result Http.Error (List Role.Role))
    | SetFirstName String
    | SetLastName String
    | ToggleRole Int
    | EquipmentPost EquipmentBase.Equipment
    | EquipmentPut EquipmentBase.Equipment
    | Reorder
    | KeyX Int
    | PaginateEquipment Int
    | SelectTab Equipment.EquipmentTab
    | EquipmentSlider Float
    | SetFilterFirstName String
    | SetFilterLastName String
    | ToggleFilterRole Int
    | ApplyEquipmentFilter EquipmentBase.Equipment
    | ResetEquipmentFilter
    | ClearEquipmentFilter
    | CancelEquipmentFilter
    | ConfirmDeleteEquipment
    | CancelDeleteEquipment



--reset - clears entries on filter formAction
-- clear - goes back to original user list
-- cancel - just closes the filter form.
