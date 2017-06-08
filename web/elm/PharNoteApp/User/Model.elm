module PharNoteApp.User.Model exposing (..)

import PharNoteApp.User.BaseModel as UserBase
import PharNoteApp.Role.BaseModel as RoleBase
import Material.Table as Table
import Http exposing (..)
import Array exposing (..)


-- type alias User =
--     { base : UserBase.User
--     , roles : List RoleBase.Role
--     }


type alias Model =
    { users : Array UserBase.User
    , formAction : FormAction
    , selectedUserId : Maybe Int
    , selectedUserIndex : Maybe Int
    , selectedTab : Int
    , order : Maybe Table.Order
    , errors : Maybe Http.Error
    , firstNameInput : String
    , lastNameInput : String
    , emailInput : String
    , photoUrlInput : String
    }


type FormAction
    = Create
    | Edit
    | Delete
    | None
