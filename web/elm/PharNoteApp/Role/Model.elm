module PharNoteApp.Role.Model exposing (..)

import PharNoteApp.User.BaseModel as UserBase
import PharNoteApp.Role.BaseModel as RoleBase
import Material.Table as Table
import Http exposing (..)


-- type alias Role =
--    { base : RoleBase.Role
--    , users : List UserBase.User
--    }


type alias Model =
    { roles : List RoleBase.Role
    , formAction : FormAction
    , selectedRole : Maybe Int
    , roleNameInput : String
    , roleDescInput : String
    , order : Maybe Table.Order
    , errors : Maybe Http.Error
    }


type FormAction
    = Create
    | Edit
    | Delete
    | None
