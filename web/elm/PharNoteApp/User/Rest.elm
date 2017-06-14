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
        |> Json.Decode.Pipeline.required "user_roles" Role.listDecoder


url : String
url =
    "http://localhost:4000/api/users"


get : Cmd AppMsg.Msg
get =
    --Http.send AppMsg.MsgForUser ProcessUserGet (Http.get url listDecoder)
    Http.send (\result -> AppMsg.MsgForUser (ProcessUserGet result)) (Http.get url listDecoder)


getRefData : Cmd AppMsg.Msg
getRefData =
    --Http.send AppMsg.MsgForUser ProcessUserGet (Http.get url listDecoder)
    Http.send (\result -> AppMsg.MsgForUser (ProcessRefDataGet result)) (Http.get url Role.listDecoder)


payload : User.UserWithRoles -> Json.Encode.Value
payload user =
    let
        uroles =
            List.map (\r -> r.id) user.roles
    in
        Json.Encode.object
            [ ( "first_name", Json.Encode.string user.first_name )
            , ( "last_name", Json.Encode.string user.last_name )
            , ( "email", Json.Encode.string user.email )
            , ( "photo_url", Json.Encode.string user.photo_url )
            , ( "roles", Json.Encode.list (List.map Json.Encode.int uroles) )
            ]


post : User.Model -> Cmd AppMsg.Msg
post model =
    let
        body =
            Http.stringBody "application/json"
                (Json.Encode.encode 0 (payload model.scratchUser))
    in
        --ProcessUserPost (Result Http.Error User)
        --Http.send ProcessUserPost (Http.post url body decoder)
        --send first arg is a function that can translate a result into a message
        Http.send (\result -> AppMsg.MsgForUser (ProcessUserPost result)) (Http.post url body decoder)


put : User.Model -> Cmd AppMsg.Msg
put model =
    let
        putUrl =
            case model.selectedUserId of
                Nothing ->
                    url ++ "/bad"

                Just id ->
                    url ++ "/" ++ (toString id)

        body =
            Http.stringBody "application/json"
                (Json.Encode.encode 0 (payload model.scratchUser))

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


delete : User.Model -> Cmd AppMsg.Msg
delete model =
    let
        putUrl =
            case model.selectedUserId of
                Nothing ->
                    url ++ "/bad"

                Just id ->
                    url ++ "/" ++ (toString id)

        body =
            Http.stringBody "application/json"
                (Json.Encode.encode 0 (payload model.scratchUser))

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
        Http.send (\result -> AppMsg.MsgForUser (ProcessUserPost result)) putRequest
