module PharNoteApp.Campaign.Model exposing (..)

import PharNoteApp.Campaign.BaseModel as CampaignBase
import PharNoteApp.Role.BaseModel as RoleBase
import Material.Table as Table
import Http exposing (..)
import Array exposing (..)
import Dict exposing (Dict)
import Set exposing (Set)


type alias CampaignWithRoles =
    --duplicated from Campaign.BaseModel
    { id : Int
    , first_name : String
    , last_name : String
    , email : String
    , photo_url : String
    , roles : List RoleBase.Role
    }


type alias CampaignWithRoleSet =
    --duplicated again from Campaign.BaseModel
    { id : Int
    , first_name : String
    , last_name : String
    , email : String
    , photo_url : String
    , roles : Set Int
    }


type alias CampaignWithRoleString =
    --duplicated again from Campaign.BaseModel
    { id : Int
    , first_name : String
    , last_name : String
    , email : String
    , photo_url : String
    , roles : String
    }


type alias Model =
    { users : Array CampaignWithRoles
    , filteredCampaigns : Array CampaignWithRoles
    , formAction : FormAction
    , selectedCampaignId : Maybe Int
    , selectedCampaignIndex : Maybe Int
    , previousSelectedCampaignId : Maybe Int
    , previousSelectedCampaignIndex : Maybe Int
    , pageSize : Int
    , startDisplayIndex : Int
    , endDisplayIndex : Int
    , userSliderValue : Float
    , scratchCampaign : CampaignWithRoleSet
    , filterScratchCampaign : CampaignWithRoleSet
    , selectedTab : CampaignTab
    , order : Maybe Table.Order
    , errors : Maybe Http.Error
    , refDataStatus : RefDataStatus
    , filterState : FilterState
    }


type CampaignTab
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
    | CancelNewCampaign
    | None


type CampaignType
    = WithRoles CampaignWithRoles
    | WithSet CampaignWithRoleSet


emptyCampaignWithRoles : CampaignWithRoles
emptyCampaignWithRoles =
    CampaignWithRoles 0 "" "" "" "" []


emptyCampaignWithRoleSet : CampaignWithRoleSet
emptyCampaignWithRoleSet =
    CampaignWithRoleSet 0 "" "" "" "" Set.empty


scratchToCampaignWithRoles : CampaignWithRoleSet -> RefData -> CampaignWithRoleString
scratchToCampaignWithRoles user refData =
    let
        userRoles =
            Set.toList user.roles
                |> List.map (\i -> toString i)
                |> String.join (",")
    in
        CampaignWithRoleString user.id user.first_name user.last_name user.email user.photo_url userRoles


scratchToCampaignWithRoles_x : CampaignWithRoleSet -> RefData -> CampaignWithRoles
scratchToCampaignWithRoles_x user refData =
    let
        userRoles =
            Set.toList user.roles
                |> List.map
                    (\roleId ->
                        Dict.get roleId refData.roles
                            |> Maybe.withDefault RoleBase.emptyRole
                    )
    in
        CampaignWithRoles user.id user.first_name user.last_name user.email user.photo_url userRoles


userTabToInt : CampaignTab -> Int
userTabToInt uTab =
    case uTab of
        Details ->
            0

        Filter ->
            1


intToCampaignTab : Int -> CampaignTab
intToCampaignTab iTab =
    case iTab of
        1 ->
            Filter

        _ ->
            Details
