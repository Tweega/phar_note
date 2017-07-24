module PharNoteApp.Campaign.Msg exposing (..)

import PharNoteApp.Campaign.Model as Campaign


--import PharNoteApp.Campaign.Model exposing (FilterAction(..))

import PharNoteApp.Role.BaseModel as Role
import Http exposing (..)


type Msg
    = NoOp
    | EditCampaign
    | SelectCampaign Int
    | DeleteCampaign
    | NewCampaign
    | CancelNewCampaign
    | ProcessCampaignGet (Result Http.Error (List Campaign.CampaignWithRoles))
    | ProcessCampaignPost (Result Http.Error Campaign.CampaignWithRoles)
    | ProcessCampaignDelete (Result Http.Error Campaign.CampaignWithRoles)
    | ProcessRefDataGet (Result Http.Error (List Role.Role))
    | SetFirstName String
    | SetLastName String
    | SetEmail String
    | SetPhotoUrl String
    | ToggleRole Int
    | CampaignPost Campaign.CampaignWithRoleSet
    | CampaignPut Campaign.CampaignWithRoleSet
    | Reorder
    | KeyX Int
    | PaginateCampaign Int
    | SelectTab Campaign.CampaignTab
    | CampaignSlider Float
    | SetFilterFirstName String
    | SetFilterLastName String
    | ToggleFilterRole Int
    | ApplyCampaignFilter Campaign.CampaignWithRoleSet
    | ResetCampaignFilter
    | ClearCampaignFilter
    | CancelCampaignFilter
    | ConfirmDeleteCampaign
    | CancelDeleteCampaign



--reset - clears entries on filter formAction
-- clear - goes back to original user list
-- cancel - just closes the filter form.
