module PharNoteApp.Campaign.Msg exposing (..)

import PharNoteApp.Campaign.Model as Campaign
import PharNoteApp.Campaign.BaseModel as CampaignBase


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
    | ProcessCampaignGet (Result Http.Error (List CampaignBase.Campaign))
    | ProcessCampaignPost (Result Http.Error CampaignBase.Campaign)
    | ProcessCampaignDelete (Result Http.Error CampaignBase.Campaign)
    | ProcessRefDataGet (Result Http.Error (List Role.Role))
    | SetFirstName String
    | SetLastName String
    | SetEmail String
    | SetPhotoUrl String
    | ToggleRole Int
    | CampaignPost CampaignBase.Campaign
    | CampaignPut CampaignBase.Campaign
    | Reorder
    | KeyX Int
    | PaginateCampaign Int
    | SelectTab Campaign.CampaignTab
    | CampaignSlider Float
    | SetFilterFirstName String
    | SetFilterLastName String
    | ToggleFilterRole Int
    | ApplyCampaignFilter CampaignBase.Campaign
    | ResetCampaignFilter
    | ClearCampaignFilter
    | CancelCampaignFilter
    | ConfirmDeleteCampaign
    | CancelDeleteCampaign



--reset - clears entries on filter formAction
-- clear - goes back to original user list
-- cancel - just closes the filter form.
