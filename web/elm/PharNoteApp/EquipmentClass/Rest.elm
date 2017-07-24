module PharNoteApp.EquipmentClass.Rest exposing (..)

import PharNoteApp.Msg as AppMsg
import PharNoteApp.EquipmentClass.Msg exposing (..)
import PharNoteApp.EquipmentClass.BaseModel as EquipmentClassBase
import PharNoteApp.EquipmentClass.Model as EquipmentClass
import PharNoteApp.Role.Rest as Role
import Http
import Http exposing (..)
import Json.Decode
import Json.Encode
import Json.Decode.Pipeline


listDecoder : Json.Decode.Decoder (List EquipmentClass.EquipmentClassWithRoles)
listDecoder =
    Json.Decode.list decoder


decoder : Json.Decode.Decoder EquipmentClass.EquipmentClassWithRoles
decoder =
    Json.Decode.Pipeline.decode EquipmentClass.EquipmentClassWithRoles
        |> Json.Decode.Pipeline.required "id" Json.Decode.int
        |> Json.Decode.Pipeline.required "first_name" Json.Decode.string
        |> Json.Decode.Pipeline.required "last_name" Json.Decode.string
        |> Json.Decode.Pipeline.required "email" Json.Decode.string
        |> Json.Decode.Pipeline.required "photo_url" Json.Decode.string
        |> Json.Decode.Pipeline.required "roles" Role.listDecoder


urlEquipmentClasss : String
urlEquipmentClasss =
    "http://localhost:4000/api/users"


urlRefData : String
urlRefData =
    "http://localhost:4000/api/roledata"


get : Cmd AppMsg.Msg
get =
    --Http.send AppMsg.MsgForEquipmentClass ProcessEquipmentClassGet (Http.get url listDecoder)
    Http.send (\result -> AppMsg.MsgForEquipmentClass (ProcessEquipmentClassGet result)) (Http.get urlEquipmentClasss listDecoder)


getRefData : Cmd AppMsg.Msg
getRefData =
    --Http.send AppMsg.MsgForEquipmentClass ProcessEquipmentClassGet (Http.get url listDecoder)
    Http.send (\result -> AppMsg.MsgForEquipmentClass (ProcessRefDataGet result)) (Http.get urlRefData Role.listDecoder)


payload : EquipmentClass.EquipmentClassWithRoleString -> Json.Encode.Value
payload user =
    Json.Encode.object
        [ ( "first_name", Json.Encode.string user.first_name )
        , ( "last_name", Json.Encode.string user.last_name )
        , ( "email", Json.Encode.string user.email )
        , ( "photo_url", Json.Encode.string user.photo_url )
        , ( "roles", Json.Encode.string user.roles )
        ]


payload2 : EquipmentClass.EquipmentClassWithRoles -> Json.Encode.Value
payload2 user =
    Json.Encode.object
        [ ( "first_name", Json.Encode.string user.first_name )
        , ( "last_name", Json.Encode.string user.last_name )
        , ( "email", Json.Encode.string user.email )
        , ( "photo_url", Json.Encode.string user.photo_url )
        ]


post : EquipmentClass.EquipmentClassWithRoleString -> Cmd AppMsg.Msg
post user =
    let
        body =
            Http.stringBody "application/json"
                (Json.Encode.encode 0 (payload user))

        jj =
            Debug.log "json" body
    in
        --ProcessEquipmentClassPost (Result Http.Error EquipmentClass)
        --Http.send ProcessEquipmentClassPost (Http.post url body decoder)
        --send first arg is a function that can translate a result into a message
        Http.send (\result -> AppMsg.MsgForEquipmentClass (ProcessEquipmentClassPost result)) (Http.post urlEquipmentClasss body decoder)


put : EquipmentClass.EquipmentClassWithRoleString -> Cmd AppMsg.Msg
put user =
    let
        putUrl =
            if user.id < 1 then
                urlEquipmentClasss ++ "/bad"
            else
                urlEquipmentClasss ++ "/" ++ (toString user.id)

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
        Http.send (\result -> AppMsg.MsgForEquipmentClass (ProcessEquipmentClassPost result)) putRequest



--Http.send (AppMsg.MsgForEquipmentClass ProcessEquipmentClassPost) putRequest


delete : EquipmentClass.EquipmentClassWithRoles -> Cmd AppMsg.Msg
delete user =
    let
        putUrl =
            if user.id < 1 then
                urlEquipmentClasss ++ "/bad"
            else
                urlEquipmentClasss ++ "/" ++ (toString user.id)

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
        --Http.send (AppMsg.MsgForEquipmentClass ProcessEquipmentClassPost) putRequest
        Http.send (\result -> AppMsg.MsgForEquipmentClass (ProcessEquipmentClassDelete result)) putRequest
