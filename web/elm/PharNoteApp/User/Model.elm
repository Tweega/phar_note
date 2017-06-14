module PharNoteApp.User.Model exposing (..)

import PharNoteApp.User.BaseModel as UserBase
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


type alias Model =
    { users : Array UserWithRoles
    , formAction : FormAction
    , selectedUserId : Maybe Int
    , selectedUserIndex : Maybe Int
    , scratchUser : UserWithRoles
    , selectedTab : Int
    , order : Maybe Table.Order
    , errors : Maybe Http.Error
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


emptyUserWithRoles : UserWithRoles
emptyUserWithRoles =
    UserWithRoles 0 "" "" "" "" []
