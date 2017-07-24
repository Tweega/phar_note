module PharNoteApp.Equipment.Msg exposing (..)

import PharNoteApp.Equipment.Model as Equipment


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
    | ProcessEquipmentGet (Result Http.Error (List Equipment.EquipmentWithRoles))
    | ProcessEquipmentPost (Result Http.Error Equipment.EquipmentWithRoles)
    | ProcessEquipmentDelete (Result Http.Error Equipment.EquipmentWithRoles)
    | ProcessRefDataGet (Result Http.Error (List Role.Role))
    | SetFirstName String
    | SetLastName String
    | SetEmail String
    | SetPhotoUrl String
    | ToggleRole Int
    | EquipmentPost Equipment.EquipmentWithRoleSet
    | EquipmentPut Equipment.EquipmentWithRoleSet
    | Reorder
    | KeyX Int
    | PaginateEquipment Int
    | SelectTab Equipment.EquipmentTab
    | EquipmentSlider Float
    | SetFilterFirstName String
    | SetFilterLastName String
    | ToggleFilterRole Int
    | ApplyEquipmentFilter Equipment.EquipmentWithRoleSet
    | ResetEquipmentFilter
    | ClearEquipmentFilter
    | CancelEquipmentFilter
    | ConfirmDeleteEquipment
    | CancelDeleteEquipment



--reset - clears entries on filter formAction
-- clear - goes back to original user list
-- cancel - just closes the filter form.
