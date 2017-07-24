module PharNoteApp.Init exposing (..)

import PharNoteApp.Model as AppModel
import PharNoteApp.User.Model as UserModel
import PharNoteApp.Msg as AppMsg
import PharNoteApp.User.Init as UserInit
import PharNoteApp.Role.Init as RoleInit
import PharNoteApp.Campaign.Init as CampaignInit
import PharNoteApp.Chart.Init as ChartInit
import PharNoteApp.Route as Route
import Material
import Navigation


init : Navigation.Location -> ( AppModel.Model, Cmd AppMsg.Msg )
init location =
    let
        ( userData, userCmd ) =
            UserInit.init

        --  ( chartData, chartCmd ) =
        --      ChartInit.init
        maybeRoute =
            Route.locFor location
    in
        { mdl = Material.model
        , history = Route.init maybeRoute
        , userData = userData
        , roleData = RoleInit.initialModel
        , campaignData = CampaignInit.initialModel
        , chartData = ChartInit.initialModel
        , activeUser = ""
        , activeRoute = maybeRoute
        }
            -- , Material.init AppMsg.Mdl
            ! [ Material.init AppMsg.Mdl, userCmd ]



-- cmd.batch or something like that
--this approach fetches the data at the start.  Alternative is to do that when each 'page' is loaded
--this might work for reference data but dynamic data should probably be fetched with the page
--call UserInit.init to fetch initial data if needed.  Same for the other sections
