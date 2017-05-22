module PharNoteApp.Role.Msg exposing (..)

import PharNoteApp.Role.Model exposing (..)
import Http exposing (..)


type Msg
    = NoOp
    | EditRole Int
    | DeleteRole Int
    | NewRole
    | ProcessRoleGet (Result Http.Error (List Role))
    | ProcessRolePost (Result Http.Error Role)
    | SetRoleNameInput String
    | SetRoleDescInput String
    | RolePost Model
    | RolePut Model
    | Reorder
