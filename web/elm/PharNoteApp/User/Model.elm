module PharNoteApp.User.Model exposing (..)

import PharNoteApp.User.BaseModel as UserBase
import PharNoteApp.Role.BaseModel as RoleBase
import Material.Table as Table
import Http exposing (..)
import Array exposing (..)
import Dict exposing (Dict)
import Set exposing (Set)


type alias UserWithRoles =
    --duplicated from User.BaseModel
    { id : Int
    , first_name : String
    , last_name : String
    , email : String
    , photo_url : String
    , roles : List RoleBase.Role
    }


type alias UserWithRoleSet =
    --duplicated again from User.BaseModel
    { id : Int
    , first_name : String
    , last_name : String
    , email : String
    , photo_url : String
    , roles : Set Int
    }


type alias UserWithRoleString =
    --duplicated again from User.BaseModel
    { id : Int
    , first_name : String
    , last_name : String
    , email : String
    , photo_url : String
    , roles : String
    }


type alias Model =
    { users : Array UserWithRoles
    , formAction : FormAction
    , selectedUserId : Maybe Int
    , selectedUserIndex : Maybe Int
    , previousSelectedUserId : Maybe Int
    , previousSelectedUserIndex : Maybe Int
    , pageSize : Int
    , startDisplayIndex : Int
    , endDisplayIndex : Int
    , scratchUser : UserWithRoleSet
    , selectedTab : Int
    , order : Maybe Table.Order
    , errors : Maybe Http.Error
    , refDataStatus : RefDataStatus
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
    | Cancel
    | None


type UserType
    = WithRoles UserWithRoles
    | WithSet UserWithRoleSet


emptyUserWithRoles : UserWithRoles
emptyUserWithRoles =
    UserWithRoles 0 "" "" "" "" []


emptyUserWithRoleSet : UserWithRoleSet
emptyUserWithRoleSet =
    UserWithRoleSet 0 "" "" "" "" Set.empty


scratchToUserWithRoles : UserWithRoleSet -> RefData -> UserWithRoleString
scratchToUserWithRoles user refData =
    let
        userRoles =
            Set.toList user.roles
                |> List.map (\i -> toString i)
                |> String.join (",")
    in
        UserWithRoleString user.id user.first_name user.last_name user.email user.photo_url userRoles


scratchToUserWithRoles_x : UserWithRoleSet -> RefData -> UserWithRoles
scratchToUserWithRoles_x user refData =
    let
        userRoles =
            Set.toList user.roles
                |> List.map
                    (\roleId ->
                        Dict.get roleId refData.roles
                            |> Maybe.withDefault RoleBase.emptyRole
                    )
    in
        UserWithRoles user.id user.first_name user.last_name user.email user.photo_url userRoles
