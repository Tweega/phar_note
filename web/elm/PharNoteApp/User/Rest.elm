module PharNoteApp.User.Rest exposing (..)

import PharNoteApp.Msg as AppMsg
import PharNoteApp.User.Msg exposing (..)
import PharNoteApp.User.Model exposing (..)
import Http
import Http exposing (..)
import Json.Decode
import Json.Encode
import Json.Decode.Pipeline


listDecoder : Json.Decode.Decoder (List User)
listDecoder =
    Json.Decode.list decoder


decoder : Json.Decode.Decoder User
decoder =
    Json.Decode.Pipeline.decode User
        |> Json.Decode.Pipeline.required "id" Json.Decode.int
        |> Json.Decode.Pipeline.required "first_name" Json.Decode.string
        |> Json.Decode.Pipeline.required "last_name" Json.Decode.string
        |> Json.Decode.Pipeline.required "email" Json.Decode.string
        |> Json.Decode.Pipeline.required "photo_url" Json.Decode.string


url : String
url =
    "http://localhost:4000/api/users"


get : Cmd AppMsg.Msg
get =
    --Http.send AppMsg.MsgForUser ProcessUserGet (Http.get url listDecoder)
    Http.send (\result -> AppMsg.MsgForUser (ProcessUserGet result)) (Http.get url listDecoder)


payload : Model -> Json.Encode.Value
payload model =
    Json.Encode.object
        [ ( "first_name", Json.Encode.string model.firstNameInput )
        , ( "last_name", Json.Encode.string model.lastNameInput )
        , ( "email", Json.Encode.string model.emailInput )
        , ( "photo_url", Json.Encode.string model.photoUrlInput )
        ]


post : Model -> Cmd AppMsg.Msg
post model =
    let
        body =
            Http.stringBody "application/json"
                (Json.Encode.encode 0 (payload model))
    in
        --ProcessUserPost (Result Http.Error User)
        --Http.send ProcessUserPost (Http.post url body decoder)
        --send first arg is a function that can translate a result into a message
        Http.send (\result -> AppMsg.MsgForUser (ProcessUserPost result)) (Http.post url body decoder)


put : Model -> Cmd AppMsg.Msg
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
        Http.send (\result -> AppMsg.MsgForUser (ProcessUserPost result)) putRequest



--Http.send (AppMsg.MsgForUser ProcessUserPost) putRequest


delete : Model -> Cmd AppMsg.Msg
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
        --Http.send (AppMsg.MsgForUser ProcessUserPost) putRequest
        Http.send (\result -> AppMsg.MsgForUser (ProcessUserPost result)) putRequest
