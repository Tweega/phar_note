module PharNoteApp.User.Model exposing (..)

import PharNoteApp.Role.BaseModel as RoleBase
import Material.Table as Table
import Http exposing (..)
import Array exposing (..)
import Dict exposing (Dict)


type alias UserWithRoles =
    --duplicated from User.BaseModel
    { id : Int
    , first_name : String
    , last_name : String
    , email : String
    , photo_url : String
    , roles : List RoleBase.Role
    }


emptyUser : UserWithRoles
emptyUser =
    UserWithRoles 0 "" "" "" "" []


type alias Model =
    { users : Array UserWithRoles
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
    , refData : RefDataStatus
    }


type RefDataStatus
    = Loading
    | Loaded RefData


type alias RefData =
    { roles : Dict Int RoleBase.Role
    }


type FormAction
    = Create
    | Edit
    | Delete
    | None
