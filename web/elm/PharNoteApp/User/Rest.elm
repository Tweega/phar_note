module PharNoteApp.User.Rest exposing (..)

import PharNoteApp.Msg as AppMsg
import PharNoteApp.User.Msg exposing (..)
import PharNoteApp.User.BaseModel as UserBase
import PharNoteApp.User.Model as User
import PharNoteApp.Role.Rest as Role
import Http
import Http exposing (..)
import Json.Decode
import Json.Encode
import Json.Decode.Pipeline


listDecoder : Json.Decode.Decoder (List User.UserWithRoles)
listDecoder =
    Json.Decode.list decoder


decoder : Json.Decode.Decoder User.UserWithRoles
decoder =
    Json.Decode.Pipeline.decode User.UserWithRoles
        |> Json.Decode.Pipeline.required "id" Json.Decode.int
        |> Json.Decode.Pipeline.required "first_name" Json.Decode.string
        |> Json.Decode.Pipeline.required "last_name" Json.Decode.string
        |> Json.Decode.Pipeline.required "email" Json.Decode.string
        |> Json.Decode.Pipeline.required "photo_url" Json.Decode.string
        |> Json.Decode.Pipeline.required "roles" Role.listDecoder


urlUsers : String
urlUsers =
    "http://localhost:4000/api/users"


urlRefData : String
urlRefData =
    "http://localhost:4000/api/roledata"


get : Cmd AppMsg.Msg
get =
    --Http.send AppMsg.MsgForUser ProcessUserGet (Http.get url listDecoder)
    Http.send (\result -> AppMsg.MsgForUser (ProcessUserGet result)) (Http.get urlUsers listDecoder)


getRefData : Cmd AppMsg.Msg
getRefData =
    --Http.send AppMsg.MsgForUser ProcessUserGet (Http.get url listDecoder)
    Http.send (\result -> AppMsg.MsgForUser (ProcessRefDataGet result)) (Http.get urlRefData Role.listDecoder)


payload : User.UserWithRoleString -> Json.Encode.Value
payload user =
    Json.Encode.object
        [ ( "first_name", Json.Encode.string user.first_name )
        , ( "last_name", Json.Encode.string user.last_name )
        , ( "email", Json.Encode.string user.email )
        , ( "photo_url", Json.Encode.string user.photo_url )
        , ( "roles", Json.Encode.string user.roles )
        ]


payload2 : User.UserWithRoles -> Json.Encode.Value
payload2 user =
    Json.Encode.object
        [ ( "first_name", Json.Encode.string user.first_name )
        , ( "last_name", Json.Encode.string user.last_name )
        , ( "email", Json.Encode.string user.email )
        , ( "photo_url", Json.Encode.string user.photo_url )
        ]


post : User.UserWithRoleString -> Cmd AppMsg.Msg
post user =
    let
        body =
            Http.stringBody "application/json"
                (Json.Encode.encode 0 (payload user))

        jj =
            Debug.log "json" body
    in
        --ProcessUserPost (Result Http.Error User)
        --Http.send ProcessUserPost (Http.post url body decoder)
        --send first arg is a function that can translate a result into a message
        Http.send (\result -> AppMsg.MsgForUser (ProcessUserPost result)) (Http.post urlUsers body decoder)


put : User.UserWithRoleString -> Cmd AppMsg.Msg
put user =
    let
        putUrl =
            if user.id < 1 then
                urlUsers ++ "/bad"
            else
                urlUsers ++ "/" ++ (toString user.id)

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
        Http.send (\result -> AppMsg.MsgForUser (ProcessUserPost result)) putRequest



--Http.send (AppMsg.MsgForUser ProcessUserPost) putRequest


delete : User.UserWithRoles -> Cmd AppMsg.Msg
delete user =
    let
        putUrl =
            if user.id < 1 then
                urlUsers ++ "/bad"
            else
                urlUsers ++ "/" ++ (toString user.id)

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
        --Http.send (AppMsg.MsgForUser ProcessUserPost) putRequest
        Http.send (\result -> AppMsg.MsgForUser (ProcessUserDelete result)) putRequest
