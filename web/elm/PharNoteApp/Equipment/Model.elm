module PharNoteApp.Equipment.Model exposing (..)

import PharNoteApp.Equipment.BaseModel as EquipmentBase
import PharNoteApp.Role.BaseModel as RoleBase
import Material.Table as Table
import Http exposing (..)
import Array exposing (..)
import Dict exposing (Dict)
import Set exposing (Set)


type alias EquipmentWithRoles =
    --duplicated from Equipment.BaseModel
    { id : Int
    , first_name : String
    , last_name : String
    , email : String
    , photo_url : String
    , roles : List RoleBase.Role
    }


type alias EquipmentWithRoleSet =
    --duplicated again from Equipment.BaseModel
    { id : Int
    , first_name : String
    , last_name : String
    , email : String
    , photo_url : String
    , roles : Set Int
    }


type alias EquipmentWithRoleString =
    --duplicated again from Equipment.BaseModel
    { id : Int
    , first_name : String
    , last_name : String
    , email : String
    , photo_url : String
    , roles : String
    }


type alias Model =
    { users : Array EquipmentWithRoles
    , filteredEquipments : Array EquipmentWithRoles
    , formAction : FormAction
    , selectedEquipmentId : Maybe Int
    , selectedEquipmentIndex : Maybe Int
    , previousSelectedEquipmentId : Maybe Int
    , previousSelectedEquipmentIndex : Maybe Int
    , pageSize : Int
    , startDisplayIndex : Int
    , endDisplayIndex : Int
    , userSliderValue : Float
    , scratchEquipment : EquipmentWithRoleSet
    , filterScratchEquipment : EquipmentWithRoleSet
    , selectedTab : EquipmentTab
    , order : Maybe Table.Order
    , errors : Maybe Http.Error
    , refDataStatus : RefDataStatus
    , filterState : FilterState
    }


type EquipmentTab
    = Details
    | Filter


type FilterState
    = Applied
    | NoFilter


type RefDataStatus
    = Loading
    | Loaded RefData


type alias RefData =
    { roles : Dict Int RoleBase.Role
    }


type FormAction
    = Create
    | Edit
    | ConfirmDelete
    | Delete
    | CancelNewEquipment
    | None


type EquipmentType
    = WithRoles EquipmentWithRoles
    | WithSet EquipmentWithRoleSet


emptyEquipmentWithRoles : EquipmentWithRoles
emptyEquipmentWithRoles =
    EquipmentWithRoles 0 "" "" "" "" []


emptyEquipmentWithRoleSet : EquipmentWithRoleSet
emptyEquipmentWithRoleSet =
    EquipmentWithRoleSet 0 "" "" "" "" Set.empty


scratchToEquipmentWithRoles : EquipmentWithRoleSet -> RefData -> EquipmentWithRoleString
scratchToEquipmentWithRoles user refData =
    let
        userRoles =
            Set.toList user.roles
                |> List.map (\i -> toString i)
                |> String.join (",")
    in
        EquipmentWithRoleString user.id user.first_name user.last_name user.email user.photo_url userRoles


scratchToEquipmentWithRoles_x : EquipmentWithRoleSet -> RefData -> EquipmentWithRoles
scratchToEquipmentWithRoles_x user refData =
    let
        userRoles =
            Set.toList user.roles
                |> List.map
                    (\roleId ->
                        Dict.get roleId refData.roles
                            |> Maybe.withDefault RoleBase.emptyRole
                    )
    in
        EquipmentWithRoles user.id user.first_name user.last_name user.email user.photo_url userRoles


userTabToInt : EquipmentTab -> Int
userTabToInt uTab =
    case uTab of
        Details ->
            0

        Filter ->
            1


intToEquipmentTab : Int -> EquipmentTab
intToEquipmentTab iTab =
    case iTab of
        1 ->
            Filter

        _ ->
            Details
