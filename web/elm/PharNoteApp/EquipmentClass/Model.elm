module PharNoteApp.EquipmentClass.Model exposing (..)

import PharNoteApp.EquipmentClass.BaseModel as EquipmentClassBase
import PharNoteApp.Role.BaseModel as RoleBase
import Material.Table as Table
import Http exposing (..)
import Array exposing (..)
import Dict exposing (Dict)
import Set exposing (Set)


type alias EquipmentClassWithRoles =
    --duplicated from EquipmentClass.BaseModel
    { id : Int
    , first_name : String
    , last_name : String
    , email : String
    , photo_url : String
    , roles : List RoleBase.Role
    }


type alias EquipmentClassWithRoleSet =
    --duplicated again from EquipmentClass.BaseModel
    { id : Int
    , first_name : String
    , last_name : String
    , email : String
    , photo_url : String
    , roles : Set Int
    }


type alias EquipmentClassWithRoleString =
    --duplicated again from EquipmentClass.BaseModel
    { id : Int
    , first_name : String
    , last_name : String
    , email : String
    , photo_url : String
    , roles : String
    }


type alias Model =
    { users : Array EquipmentClassWithRoles
    , filteredEquipmentClasss : Array EquipmentClassWithRoles
    , formAction : FormAction
    , selectedEquipmentClassId : Maybe Int
    , selectedEquipmentClassIndex : Maybe Int
    , previousSelectedEquipmentClassId : Maybe Int
    , previousSelectedEquipmentClassIndex : Maybe Int
    , pageSize : Int
    , startDisplayIndex : Int
    , endDisplayIndex : Int
    , userSliderValue : Float
    , scratchEquipmentClass : EquipmentClassWithRoleSet
    , filterScratchEquipmentClass : EquipmentClassWithRoleSet
    , selectedTab : EquipmentClassTab
    , order : Maybe Table.Order
    , errors : Maybe Http.Error
    , refDataStatus : RefDataStatus
    , filterState : FilterState
    }


type EquipmentClassTab
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
    | CancelNewEquipmentClass
    | None


type EquipmentClassType
    = WithRoles EquipmentClassWithRoles
    | WithSet EquipmentClassWithRoleSet


emptyEquipmentClassWithRoles : EquipmentClassWithRoles
emptyEquipmentClassWithRoles =
    EquipmentClassWithRoles 0 "" "" "" "" []


emptyEquipmentClassWithRoleSet : EquipmentClassWithRoleSet
emptyEquipmentClassWithRoleSet =
    EquipmentClassWithRoleSet 0 "" "" "" "" Set.empty


scratchToEquipmentClassWithRoles : EquipmentClassWithRoleSet -> RefData -> EquipmentClassWithRoleString
scratchToEquipmentClassWithRoles user refData =
    let
        userRoles =
            Set.toList user.roles
                |> List.map (\i -> toString i)
                |> String.join (",")
    in
        EquipmentClassWithRoleString user.id user.first_name user.last_name user.email user.photo_url userRoles


scratchToEquipmentClassWithRoles_x : EquipmentClassWithRoleSet -> RefData -> EquipmentClassWithRoles
scratchToEquipmentClassWithRoles_x user refData =
    let
        userRoles =
            Set.toList user.roles
                |> List.map
                    (\roleId ->
                        Dict.get roleId refData.roles
                            |> Maybe.withDefault RoleBase.emptyRole
                    )
    in
        EquipmentClassWithRoles user.id user.first_name user.last_name user.email user.photo_url userRoles


userTabToInt : EquipmentClassTab -> Int
userTabToInt uTab =
    case uTab of
        Details ->
            0

        Filter ->
            1


intToEquipmentClassTab : Int -> EquipmentClassTab
intToEquipmentClassTab iTab =
    case iTab of
        1 ->
            Filter

        _ ->
            Details
