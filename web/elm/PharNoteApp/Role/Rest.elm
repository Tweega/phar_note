module PharNoteApp.Role.Rest exposing (..)

import PharNoteApp.Msg as AppMsg
import PharNoteApp.Role.Msg exposing (..)
import PharNoteApp.Role.Model as Model
import PharNoteApp.Role.BaseModel as BaseModel
import Http
import Http exposing (..)
import Json.Decode
import Json.Encode
import Json.Decode.Pipeline


listDecoder : Json.Decode.Decoder (List BaseModel.Role)
listDecoder =
    Json.Decode.list decoder


decoder : Json.Decode.Decoder BaseModel.Role
decoder =
    Json.Decode.Pipeline.decode BaseModel.Role
        |> Json.Decode.Pipeline.required "id" Json.Decode.int
        |> Json.Decode.Pipeline.required "role_name" Json.Decode.string
        |> Json.Decode.Pipeline.required "role_desc" Json.Decode.string


url : String
url =
    "http://localhost:4000/api/roles"


get : Cmd AppMsg.Msg
get =
    --Http.send AppMsg.MsgForRole ProcessRoleGet (Http.get url listDecoder)
    Http.send (\result -> AppMsg.MsgForRole (ProcessRoleGet result)) (Http.get url listDecoder)


payload : Model.Model -> Json.Encode.Value
payload model =
    Json.Encode.object
        [ ( "role_name", Json.Encode.string model.roleNameInput )
        , ( "role_desc", Json.Encode.string model.roleDescInput )
        ]


post : Model.Model -> Cmd AppMsg.Msg
post model =
    let
        body =
            Http.stringBody "application/json"
                (Json.Encode.encode 0 (payload model))
    in
        --ProcessRolePost (Result Http.Error Role)
        --Http.send ProcessRolePost (Http.post url body decoder)
        --send first arg is a function that can translate a result into a message
        Http.send (\result -> AppMsg.MsgForRole (ProcessRolePost result)) (Http.post url body decoder)


put : Model.Model -> Cmd AppMsg.Msg
put model =
    let
        putUrl =
            case model.selectedRole of
                Nothing ->
                    url ++ "/bad"

                Just id ->
                    url ++ "/" ++ (toString id)

        body =
            Http.stringBody "application/json"
                (Json.Encode.encode 0 (payload model))

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
        Http.send (\result -> AppMsg.MsgForRole (ProcessRolePost result)) putRequest



--Http.send (AppMsg.MsgForRole ProcessRolePost) putRequest


delete : Model.Model -> Cmd AppMsg.Msg
delete model =
    let
        putUrl =
            case model.selectedRole of
                Nothing ->
                    url ++ "/bad"

                Just id ->
                    url ++ "/" ++ (toString id)

        body =
            Http.stringBody "application/json"
                (Json.Encode.encode 0 (payload model))

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
        --Http.send (AppMsg.MsgForRole ProcessRolePost) putRequest
        Http.send (\result -> AppMsg.MsgForRole (ProcessRolePost result)) putRequest
