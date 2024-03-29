module PharNoteApp.Campaign.Init exposing (..)

import PharNoteApp.Campaign.Rest exposing (getRefData)
import PharNoteApp.Campaign.Model exposing (Model, FormAction(..), CampaignTab(..), RefDataStatus(..), FilterState(..), emptyCampaign)
import PharNoteApp.Campaign.BaseModel as CampaignBase
import PharNoteApp.Msg as AppMsg
import Material.Table as Table
import Array exposing (empty)


init : ( Model, Cmd AppMsg.Msg )
init =
    initialModel
        ! [ getRefData ]



--use init if fetching some intial data at load time.


initialModel : Model
initialModel =
    { campaigns = Array.empty
    , filteredCampaigns = Array.empty
    , formAction = None
    , selectedCampaignId = Nothing
    , selectedCampaignIndex = Nothing
    , previousSelectedCampaignId = Nothing
    , previousSelectedCampaignIndex = Nothing
    , selectedTab = Details
    , order = Just Table.Ascending
    , errors = Nothing
    , pageSize = 6
    , startDisplayIndex = -1
    , endDisplayIndex = -1
    , campaignSliderValue = 0
    , scratchCampaign = emptyCampaign
    , filterScratchCampaign = emptyCampaign
    , refDataStatus = Loading
    , filterState = NoFilter
    }



--this might be a place to fetch reference or other one-off data (get)
