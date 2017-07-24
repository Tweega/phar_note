module PharNoteApp.Equipment.Rest exposing (..)

import PharNoteApp.Msg as AppMsg
import PharNoteApp.Equipment.Msg exposing (..)
import PharNoteApp.Equipment.BaseModel as EquipmentBase
import PharNoteApp.Equipment.Model as Equipment
import PharNoteApp.Role.Rest as Role
import Http
import Http exposing (..)
import Json.Decode
import Json.Encode
import Json.Decode.Pipeline


listDecoder : Json.Decode.Decoder (List Equipment.EquipmentWithRoles)
listDecoder =
    Json.Decode.list decoder


decoder : Json.Decode.Decoder Equipment.EquipmentWithRoles
decoder =
    Json.Decode.Pipeline.decode Equipment.EquipmentWithRoles
        |> Json.Decode.Pipeline.required "id" Json.Decode.int
        |> Json.Decode.Pipeline.required "first_name" Json.Decode.string
        |> Json.Decode.Pipeline.required "last_name" Json.Decode.string
        |> Json.Decode.Pipeline.required "email" Json.Decode.string
        |> Json.Decode.Pipeline.required "photo_url" Json.Decode.string
        |> Json.Decode.Pipeline.required "roles" Role.listDecoder


urlEquipments : String
urlEquipments =
    "http://localhost:4000/api/users"


urlRefData : String
urlRefData =
    "http://localhost:4000/api/roledata"


get : Cmd AppMsg.Msg
get =
    --Http.send AppMsg.MsgForEquipment ProcessEquipmentGet (Http.get url listDecoder)
    Http.send (\result -> AppMsg.MsgForEquipment (ProcessEquipmentGet result)) (Http.get urlEquipments listDecoder)


getRefData : Cmd AppMsg.Msg
getRefData =
    --Http.send AppMsg.MsgForEquipment ProcessEquipmentGet (Http.get url listDecoder)
    Http.send (\result -> AppMsg.MsgForEquipment (ProcessRefDataGet result)) (Http.get urlRefData Role.listDecoder)


payload : Equipment.EquipmentWithRoleString -> Json.Encode.Value
payload user =
    Json.Encode.object
        [ ( "first_name", Json.Encode.string user.first_name )
        , ( "last_name", Json.Encode.string user.last_name )
        , ( "email", Json.Encode.string user.email )
        , ( "photo_url", Json.Encode.string user.photo_url )
        , ( "roles", Json.Encode.string user.roles )
        ]


payload2 : Equipment.EquipmentWithRoles -> Json.Encode.Value
payload2 user =
    Json.Encode.object
        [ ( "first_name", Json.Encode.string user.first_name )
        , ( "last_name", Json.Encode.string user.last_name )
        , ( "email", Json.Encode.string user.email )
        , ( "photo_url", Json.Encode.string user.photo_url )
        ]


post : Equipment.EquipmentWithRoleString -> Cmd AppMsg.Msg
post user =
    let
        body =
            Http.stringBody "application/json"
                (Json.Encode.encode 0 (payload user))

        jj =
            Debug.log "json" body
    in
        --ProcessEquipmentPost (Result Http.Error Equipment)
        --Http.send ProcessEquipmentPost (Http.post url body decoder)
        --send first arg is a function that can translate a result into a message
        Http.send (\result -> AppMsg.MsgForEquipment (ProcessEquipmentPost result)) (Http.post urlEquipments body decoder)


put : Equipment.EquipmentWithRoleString -> Cmd AppMsg.Msg
put user =
    let
        putUrl =
            if user.id < 1 then
                urlEquipments ++ "/bad"
            else
                urlEquipments ++ "/" ++ (toString user.id)

        body =
            Http.stringBody "application/json"
                (Json.Encode.encode 0 (payload user))

        putRequest =
            Http.request
                { method = "PUT"
                , headers = []
                , url = putUrl
                , body = body
                , expect = Http.expectJson decoder
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send (\result -> AppMsg.MsgForEquipment (ProcessEquipmentPost result)) putRequest



--Http.send (AppMsg.MsgForEquipment ProcessEquipmentPost) putRequest


delete : Equipment.EquipmentWithRoles -> Cmd AppMsg.Msg
delete user =
    let
        putUrl =
            if user.id < 1 then
                urlEquipments ++ "/bad"
            else
                urlEquipments ++ "/" ++ (toString user.id)

        body =
            Http.stringBody "application/json"
                (Json.Encode.encode 0 (payload2 user))

        putRequest =
            Http.request
                { method = "DELETE"
                , headers = []
                , url = putUrl
                , body = body
                , expect = Http.expectJson decoder
                , timeout = Nothing
                , withCredentials = False
                }
    in
        --Http.send (AppMsg.MsgForEquipment ProcessEquipmentPost) putRequest
        Http.send (\result -> AppMsg.MsgForEquipment (ProcessEquipmentDelete result)) putRequest
