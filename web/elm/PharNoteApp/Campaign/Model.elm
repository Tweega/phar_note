module PharNoteApp.Campaign.Model exposing (..)

import PharNoteApp.Campaign.BaseModel as CampaignBase
import PharNoteApp.Role.BaseModel as RoleBase
import Material.Table as Table
import Http exposing (..)
import Array exposing (..)
import Dict exposing (Dict)
import Set exposing (Set)


type alias Model =
    { users : Array CampaignBase.Campaign
    , filteredCampaigns : Array CampaignBase.Campaign
    , formAction : FormAction
    , selectedCampaignId : Maybe Int
    , selectedCampaignIndex : Maybe Int
    , previousSelectedCampaignId : Maybe Int
    , previousSelectedCampaignIndex : Maybe Int
    , pageSize : Int
    , startDisplayIndex : Int
    , endDisplayIndex : Int
    , userSliderValue : Float
    , scratchCampaign : CampaignBase.Campaign
    , filterScratchCampaign : CampaignBase.Campaign
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
    { roles : Dict Int String
    }


type FormAction
    = Create
    | Edit
    | ConfirmDelete
    | Delete
    | CancelNewCampaign
    | None


type CampaignType
    = WithRoles CampaignBase.Campaign
    | WithSet CampaignBase.Campaign



-- emptyCampaignBase.Campaign : CampaignBase.Campaign
-- emptyCampaignBase.Campaign =
--     CampaignBase.Campaign 0 "" "" "" "" []
--
--
-- emptyCampaignWithRoleSet : CampaignWithRoleSet
-- emptyCampaignWithRoleSet =
--     CampaignWithRoleSet 0 "" "" "" "" Set.empty
--
--
-- scratchToCampaignBase.Campaign : CampaignWithRoleSet -> RefData -> CampaignWithRoleString
-- scratchToCampaignBase.Campaign user refData =
--     let
--         userRoles =
--             Set.toList user.roles
--                 |> List.map (\i -> toString i)
--                 |> String.join (",")
--     in
--         CampaignWithRoleString user.id user.first_name user.last_name user.email user.photo_url userRoles
--
--
-- scratchToCampaignBase.Campaign_x : CampaignWithRoleSet -> RefData -> CampaignBase.Campaign
-- scratchToCampaignBase.Campaign_x user refData =
--     let
--         userRoles =
--             Set.toList user.roles
--                 |> List.map
--                     (\roleId ->
--                         Dict.get roleId refData.roles
--                             |> Maybe.withDefault RoleBase.emptyRole
--                     )
--     in
--         CampaignBase.Campaign user.id user.first_name user.last_name user.email user.photo_url userRoles


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
