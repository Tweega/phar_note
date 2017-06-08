module PharNoteApp.Role.Msg exposing (..)

import PharNoteApp.Role.BaseModel as BaseModel
import PharNoteApp.Role.Model as Role
import Http exposing (..)


type Msg
    = NoOp
    | EditRole Int
    | SelectRole Int
    | DeleteRole Int
    | NewRole
    | ProcessRoleGet (Result Http.Error (List BaseModel.Role))
    | ProcessRolePost (Result Http.Error BaseModel.Role)
    | SetRoleNameInput String
    | SetRoleDescInput String
    | RolePost Role.Model
    | RolePut Role.Model
    | Reorder
