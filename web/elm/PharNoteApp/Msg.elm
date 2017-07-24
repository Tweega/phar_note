module PharNoteApp.Msg exposing (..)

import PharNoteApp.User.Msg as User
import PharNoteApp.Chart.Msg as Chart
import PharNoteApp.Role.Msg as Role
import PharNoteApp.Campaign.Msg as Campaign
import Material
import Navigation


type Msg
    = NoOp
    | Mdl (Material.Msg Msg)
    | MsgForUser User.Msg
    | MsgForRole Role.Msg
    | MsgForCampaign Campaign.Msg
    | MsgForChart Chart.Msg
    | SelectUser String
    | NewUrl String
    | NavigateTo Navigation.Location
