module PharNoteApp.EquipmentClass.Msg exposing (..)

import PharNoteApp.EquipmentClass.Model as EquipmentClass


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
    | ProcessEquipmentClassGet (Result Http.Error (List EquipmentClass.EquipmentClassWithRoles))
    | ProcessEquipmentClassPost (Result Http.Error EquipmentClass.EquipmentClassWithRoles)
    | ProcessEquipmentClassDelete (Result Http.Error EquipmentClass.EquipmentClassWithRoles)
    | ProcessRefDataGet (Result Http.Error (List Role.Role))
    | SetFirstName String
    | SetLastName String
    | SetEmail String
    | SetPhotoUrl String
    | ToggleRole Int
    | EquipmentClassPost EquipmentClass.EquipmentClassWithRoleSet
    | EquipmentClassPut EquipmentClass.EquipmentClassWithRoleSet
    | Reorder
    | KeyX Int
    | PaginateEquipmentClass Int
    | SelectTab EquipmentClass.EquipmentClassTab
    | EquipmentClassSlider Float
    | SetFilterFirstName String
    | SetFilterLastName String
    | ToggleFilterRole Int
    | ApplyEquipmentClassFilter EquipmentClass.EquipmentClassWithRoleSet
    | ResetEquipmentClassFilter
    | ClearEquipmentClassFilter
    | CancelEquipmentClassFilter
    | ConfirmDeleteEquipmentClass
    | CancelDeleteEquipmentClass



--reset - clears entries on filter formAction
-- clear - goes back to original user list
-- cancel - just closes the filter form.
