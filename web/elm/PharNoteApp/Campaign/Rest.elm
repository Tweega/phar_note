module PharNoteApp.Campaign.Rest exposing (..)

import PharNoteApp.Msg as AppMsg
import PharNoteApp.Campaign.Msg exposing (..)
import PharNoteApp.Campaign.BaseModel as CampaignBase
import PharNoteApp.Campaign.Model as Campaign
import Http
import Http exposing (..)
import Json.Decode
import Json.Encode
import Json.Decode.Pipeline


listDecoder : Json.Decode.Decoder (List CampaignBase.Campaign)
listDecoder =
    Json.Decode.list decoder


decoder : Json.Decode.Decoder CampaignBase.Campaign
decoder =
    Json.Decode.Pipeline.decode CampaignBase.Campaign
        |> Json.Decode.Pipeline.required "id" Json.Decode.int
        |> Json.Decode.Pipeline.required "campaign_name" Json.Decode.string
        |> Json.Decode.Pipeline.required "campaign_desc" Json.Decode.string
        |> Json.Decode.Pipeline.optional "planned_start" Json.Decode.string ""
        |> Json.Decode.Pipeline.optional "planned_end" Json.Decode.string ""
        |> Json.Decode.Pipeline.optional "actual_start" Json.Decode.string ""
        |> Json.Decode.Pipeline.optional "actual_end" Json.Decode.string ""
        |> Json.Decode.Pipeline.required "order_number" Json.Decode.string


urlCampaigns : String
urlCampaigns =
    "http://localhost:4000/api/campaigns"


urlRefData : String
urlRefData =
    "http://localhost:4000/api/roledata"


get : Cmd AppMsg.Msg
get =
    --Http.send AppMsg.MsgForCampaign ProcessCampaignGet (Http.get url listDecoder)
    Http.send (\result -> AppMsg.MsgForCampaign (ProcessCampaignGet result)) (Http.get urlCampaigns listDecoder)


getRefData : Cmd AppMsg.Msg
getRefData =
    Cmd.none



-- getRefData : Cmd AppMsg.Msg
-- getRefData =
--     --Http.send AppMsg.MsgForCampaign ProcessCampaignGet (Http.get url listDecoder)
--     Http.send (\result -> AppMsg.MsgForCampaign (ProcessRefDataGet result)) (Http.get urlRefData Role.listDecoder)
--
--
-- payload : Campaign.CampaignWithRoleString -> Json.Encode.Value
-- payload user =
--     Json.Encode.object
--         [ ( "first_name", Json.Encode.string user.first_name )
--         , ( "last_name", Json.Encode.string user.last_name )
--         , ( "email", Json.Encode.string user.email )
--         , ( "photo_url", Json.Encode.string user.photo_url )
--         , ( "roles", Json.Encode.string user.roles )
--         ]
--
--
-- payload2 : Campaign.CampaignWithRoles -> Json.Encode.Value
-- payload2 user =
--     Json.Encode.object
--         [ ( "first_name", Json.Encode.string user.first_name )
--         , ( "last_name", Json.Encode.string user.last_name )
--         , ( "email", Json.Encode.string user.email )
--         , ( "photo_url", Json.Encode.string user.photo_url )
--         ]
--
--


post : Campaign.CampaignWithRoleString -> Cmd AppMsg.Msg
post user =
    Cmd.none



--     let
--         body =
--             Http.stringBody "application/json"
--                 (Json.Encode.encode 0 (payload user))
--
--         jj =
--             Debug.log "json" body
--     in
--         --ProcessCampaignPost (Result Http.Error Campaign)
--         --Http.send ProcessCampaignPost (Http.post url body decoder)
--         --send first arg is a function that can translate a result into a message
--         Http.send (\result -> AppMsg.MsgForCampaign (ProcessCampaignPost result)) (Http.post urlCampaigns body decoder)
--
--
-- put : Campaign.CampaignWithRoleString -> Cmd AppMsg.Msg
-- put user =
--     let
--         putUrl =
--             if user.id < 1 then
--                 urlCampaigns ++ "/bad"
--             else
--                 urlCampaigns ++ "/" ++ (toString user.id)
--
--         body =
--             Http.stringBody "application/json"
--                 (Json.Encode.encode 0 (payload user))
--
--         putRequest =
--             Http.request
--                 { method = "PUT"
--                 , headers = []
--                 , url = putUrl
--                 , body = body
--                 , expect = Http.expectJson decoder
--                 , timeout = Nothing
--                 , withCredentials = False
--                 }
--     in
--         Http.send (\result -> AppMsg.MsgForCampaign (ProcessCampaignPost result)) putRequest
--
--
--
-- --Http.send (AppMsg.MsgForCampaign ProcessCampaignPost) putRequest
--
--


delete : Campaign.CampaignWithRoles -> Cmd AppMsg.Msg
delete user =
    Cmd.none



--     let
--         putUrl =
--             if user.id < 1 then
--                 urlCampaigns ++ "/bad"
--             else
--                 urlCampaigns ++ "/" ++ (toString user.id)
--
--         body =
--             Http.stringBody "application/json"
--                 (Json.Encode.encode 0 (payload2 user))
--
--         putRequest =
--             Http.request
--                 { method = "DELETE"
--                 , headers = []
--                 , url = putUrl
--                 , body = body
--                 , expect = Http.expectJson decoder
--                 , timeout = Nothing
--                 , withCredentials = False
--                 }
--     in
--         --Http.send (AppMsg.MsgForCampaign ProcessCampaignPost) putRequest
--         Http.send (\result -> AppMsg.MsgForCampaign (ProcessCampaignDelete result)) putRequest
