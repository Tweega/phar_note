module UserHttp exposing (..)

import Http
import Json.Decode
import Json.Encode
import Json.Decode.Pipeline
import Model exposing (..)
import User exposing (..)


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


get : Cmd Msg
get =
    Http.send ProcessUserGet (Http.get url listDecoder)


payload : Model -> Json.Encode.Value
payload model =
    Json.Encode.object
        [ ( "first_name", Json.Encode.string model.firstNameInput )
        , ( "last_name", Json.Encode.string model.lastNameInput )
        , ( "email", Json.Encode.string model.emailInput )
        , ( "photo_url", Json.Encode.string model.photoUrlInput )
        ]


post : Model -> Cmd Msg
post model =
    let
        body =
            Http.stringBody "application/json"
                (Json.Encode.encode 0 (payload model))
    in
        Http.send ProcessUserPost (Http.post url body decoder)


put : Model -> Cmd Msg
put model =
    let
        putUrl =
            case model.selectedUser of
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
        Http.send ProcessUserPost putRequest


delete : Model -> Cmd Msg
delete model =
    let
        putUrl =
            case model.selectedUser of
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
        Http.send ProcessUserPost putRequest
